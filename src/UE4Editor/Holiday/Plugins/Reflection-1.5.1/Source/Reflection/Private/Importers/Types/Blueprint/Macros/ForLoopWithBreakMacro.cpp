/* Copyright Reflection Contributors 2024-2026 */

#include "Importers/Types/Blueprint/MacroPattern.h"

using namespace MacroReading;

/* ForLoopWithBreak, as StandardMacros defines it:
 *
 *     Tunnel(in)  execute -> Clear,  FirstIndex -> Assign,  LastIndex -> LessEqual.B,
 *                 Break -> Raise the flag
 *     Clear       Broke = false                          -> Assign
 *     Assign      Counter = FirstIndex                   -> Branch
 *     Branch      Condition <- And(Not(Broke), LessEqual(Counter, LastIndex))
 *                 then -> Sequence,  else -> Completed
 *     Sequence    then_0 -> LoopBody,  then_1 -> Next
 *     Next        Counter = Add_IntInt(Counter, 1)       -> Branch
 *     Tunnel(out) LoopBody,  Index <- Counter,  Completed
 *
 * which is the plain ForLoop with a flag in front of it. The loop comes back not to the comparison
 * but to the reading of the flag, and what the comparison decides is decided together with it, so
 * the run leaves by Completed the first time round after the body puts the flag up.
 *
 * Written in the order it runs in a function, and stitched together by jumps in an event graph, so
 * this is read by following the run rather than by walking the list. */
struct FForLoopWithBreakMacro final : FMacroPattern {
	virtual const TCHAR* GetName() const override { return TEXT("ForLoopWithBreak"); }

	virtual bool Match(const TArray<FUObjectJsonValueExport>& Statements, const int32 At, FMacroMatch& Out) const override {
		if (!Statements.IsValidIndex(At)) return false;

		TSet<int32> Inside;

		int32 Where = AddressOf(Statements[At]);
		int32 Look = At;

		/* Putting the flag down, which is the first thing the loop does and the one thing the plain
		 * ForLoop never does */
		if (!IsLet(TokenOf(Statements[Look]))) return false;

		const FString Broke = WrittenTo(Statements[Look]);

		if (!Broke.StartsWith(TEXT("Temp_"))) return false;
		if (TokenOf(Statements[Look].GetObject(TEXT("Expression"))) != TEXT("EX_False")) return false;

		Inside.Add(Where);

		/* Everything after this is reached by following the run rather than by reading on */
		auto Carry = [&Statements, &Inside, &Where, &Look]() {
			Where = NextInRun(Statements, Where, Inside);
			Look = Where == INDEX_NONE ? INDEX_NONE : IndexOfAddress(Statements, Where);

			return Look != INDEX_NONE;
		};

		/* The counter, started wherever the caller said */
		if (!Carry() || !IsLet(TokenOf(Statements[Look]))) return false;

		const FString Counter = WrittenTo(Statements[Look]);

		if (!Counter.StartsWith(TEXT("Temp_")) || Counter == Broke) return false;

		const FUObjectJsonValueExport From = Statements[Look].GetObject(TEXT("Expression"));

		Inside.Add(Where);

		/* Where the run comes back to every time round, which is the flag being read rather than
		 * the counter being compared */
		if (!Carry() || !IsLet(TokenOf(Statements[Look]))) return false;

		const int32 Compare = Where;

		const FUObjectJsonValueExport Asking = Statements[Look].GetObject(TEXT("Expression"));

		if (CallsTo(Asking) != TEXT("Not_PreBool")) return false;

		const TArray<FUObjectJsonValueExport> Asked = Asking.Has(TEXT("Parameters")) ? Asking.GetArray(TEXT("Parameters")) : TArray<FUObjectJsonValueExport>();

		if (Asked.Num() < 1 || ReadFrom(Asked[0]) != Broke) return false;

		const FString Carrying = WrittenTo(Statements[Look]);

		Inside.Add(Where);

		/* Whether there is another one, which is the counter against the last index */
		if (!Carry() || !IsLet(TokenOf(Statements[Look]))) return false;

		const FUObjectJsonValueExport Condition = Statements[Look].GetObject(TEXT("Expression"));

		if (CallsTo(Condition) != TEXT("LessEqual_IntInt")) return false;

		const TArray<FUObjectJsonValueExport> Operands = Condition.Has(TEXT("Parameters")) ? Condition.GetArray(TEXT("Parameters")) : TArray<FUObjectJsonValueExport>();

		if (Operands.Num() < 2 || ReadFrom(Operands[0]) != Counter) return false;

		const FString Within = WrittenTo(Statements[Look]);

		Inside.Add(Where);

		/* Both of them at once, which is what the break costs. Which side is which is the macro's
		 * own wiring and not worth insisting on. */
		if (!Carry() || !IsLet(TokenOf(Statements[Look]))) return false;

		const FUObjectJsonValueExport Both = Statements[Look].GetObject(TEXT("Expression"));

		if (CallsTo(Both) != TEXT("BooleanAND")) return false;

		const TArray<FUObjectJsonValueExport> Sides = Both.Has(TEXT("Parameters")) ? Both.GetArray(TEXT("Parameters")) : TArray<FUObjectJsonValueExport>();

		if (Sides.Num() < 2) return false;

		const FString Left = ReadFrom(Sides[0]);
		const FString Right = ReadFrom(Sides[1]);

		if (!((Left == Carrying && Right == Within) || (Left == Within && Right == Carrying))) return false;

		Inside.Add(Where);

		/* The run ends where either of them says so */
		if (!Carry()) return false;

		const FString Ending = TokenOf(Statements[Look]);

		if (Ending != TEXT("EX_PopExecutionFlowIfNot") && Ending != TEXT("EX_JumpIfNot")) return false;

		Inside.Add(Where);

		/* A conditional jump says where it goes when it fails. A conditional pop carries on wherever
		 * it was pushed to, which is not this macro's to say. */
		if (Ending == TEXT("EX_JumpIfNot")) {
			Out.Leads.Add(TEXT("Completed"), Statements[Look].GetInteger(TEXT("CodeOffset"), INDEX_NONE));
		}

		/* The body and the raising of the counter, one after the other */
		if (!Carry() || TokenOf(Statements[Look]) != TEXT("EX_PushExecutionFlow")) return false;

		const int32 Raise = Statements[Look].GetInteger(TEXT("PushingAddress"), INDEX_NONE);

		Inside.Add(Where);

		if (!Carry()) return false;

		Out.Leads.Add(TEXT("LoopBody"), Where);

		/* Raising the counter, which is where the body was pushed to */
		const int32 Raising = Raise == INDEX_NONE ? INDEX_NONE : IndexOfAddress(Statements, Raise);

		if (Raising == INDEX_NONE || !IsLet(TokenOf(Statements[Raising]))) return false;
		if (CallsTo(Statements[Raising].GetObject(TEXT("Expression"))) != TEXT("Add_IntInt")) return false;

		Inside.Add(Raise);

		Where = Raise;

		if (!Carry() || WrittenTo(Statements[Look]) != Counter) return false;

		Inside.Add(Where);

		/* And back round to the flag, or this is some other loop entirely */
		if (!Carry() || Where != Compare) return false;

		/* Where the body says to stop, which is the flag being put up. Whatever run reached it is
		 * the run somebody wired into Break, so that is where it goes. */
		for (int32 Which = 0; Which < Statements.Num(); Which++) {
			if (!IsLet(TokenOf(Statements[Which]))) continue;
			if (WrittenTo(Statements[Which]) != Broke) continue;
			if (TokenOf(Statements[Which].GetObject(TEXT("Expression"))) != TEXT("EX_True")) continue;

			Out.Internal.Add(Which);
			Out.Takes.Add(Which, TEXT("Break"));
		}

		/* Every read of the counter in the body is a read of what the macro hands out */
		Out.Handouts.Add(Counter, TEXT("Index"));

		Out.Inputs.Add(TEXT("FirstIndex"), From);
		Out.Deferred.Add(TEXT("LastIndex"), Operands[1]);

		/* Placed where the run reaches it, which is where it began rather than where it is written */
		Out.First = At;
		Out.Last = At;

		for (const int32 Address : Inside) {
			const int32 Which = IndexOfAddress(Statements, Address);

			if (Which == INDEX_NONE) continue;

			Out.Internal.Add(Which);

			Out.Last = FMath::Max(Out.Last, Which);
		}

		return true;
	}
};

REGISTER_MACRO(FForLoopWithBreakMacro)
