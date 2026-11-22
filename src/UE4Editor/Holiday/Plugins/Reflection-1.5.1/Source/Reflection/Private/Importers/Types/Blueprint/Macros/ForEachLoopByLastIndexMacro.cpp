/* Copyright Reflection Contributors 2024-2026 */

#include "Importers/Types/Blueprint/MacroPattern.h"

using namespace MacroReading;

/* ForEachLoop, counted against the array's last index.
 *
 * The same node comes out of the compiler in more than one shape, because the macro it stands for
 * has been written more than one way. One asks how long the array is and counts below that, keeping
 * a second scratch for the index it hands out. This one asks for the last index instead and counts
 * up to it, with one scratch doing for both:
 *
 *     Counter = 0
 *     LastIndex = Array_LastIndex(Array)
 *     if (!(Counter <= LastIndex)) the run ends
 *     push where the counter is raised, run the body, pop back
 *     Counter = Add_IntInt(Counter, 1)
 *     and round to the last index again
 *
 * None of that is written one statement after another. An event graph is written as blocks stitched
 * together by jumps, and this loop's first statement is written after everything it runs, so it is
 * read by following the run rather than by walking the list.
 *
 * What the body reads out of the array is left where it is. The element is read wherever the body
 * wanted it rather than at the top of the loop, so it stays the reading it was, against the index
 * the macro hands out. */
struct FForEachLoopByLastIndexMacro final : FMacroPattern {
	virtual const TCHAR* GetName() const override { return TEXT("ForEachLoop"); }

	virtual bool Match(const TArray<FUObjectJsonValueExport>& Statements, const int32 At, FMacroMatch& Out) const override {
		if (!Statements.IsValidIndex(At)) return false;

		TSet<int32> Inside;

		/* Zeroing the counter, which is the first thing the loop does */
		int32 Where = AddressOf(Statements[At]);
		int32 Look = At;

		if (!IsLet(TokenOf(Statements[Look]))) return false;

		const FString Counter = WrittenTo(Statements[Look]);

		if (!Counter.StartsWith(TEXT("Temp_"))) return false;
		if (TokenOf(Statements[Look].GetObject(TEXT("Expression"))) != TEXT("EX_IntConst")) return false;

		Inside.Add(Where);

		/* Everything after this is reached by following the run rather than by reading on */
		auto Carry = [&Statements, &Inside, &Where, &Look]() {
			Where = NextInRun(Statements, Where, Inside);
			Look = Where == INDEX_NONE ? INDEX_NONE : IndexOfAddress(Statements, Where);

			return Look != INDEX_NONE;
		};

		/* The last index of the array, which is the only place the array itself is named */
		if (!Carry() || !IsLet(TokenOf(Statements[Look]))) return false;

		const FString Ends = WrittenTo(Statements[Look]);
		const FUObjectJsonValueExport Measuring = Statements[Look].GetObject(TEXT("Expression"));
		const FUObjectJsonValueExport Measures = Measuring.Has(TEXT("ContextExpression")) ? Measuring.GetObject(TEXT("ContextExpression")) : Measuring;

		if (CallsTo(Measures) != TEXT("Array_LastIndex")) return false;

		const TArray<FUObjectJsonValueExport> Measured = Measures.Has(TEXT("Parameters")) ? Measures.GetArray(TEXT("Parameters")) : TArray<FUObjectJsonValueExport>();

		if (Measured.Num() < 1) return false;

		Inside.Add(Where);

		/* Where the run comes back to every time round */
		const int32 Compare = Where;

		/* Whether there is another one, which is the counter against the last index */
		if (!Carry() || !IsLet(TokenOf(Statements[Look]))) return false;

		const FUObjectJsonValueExport Condition = Statements[Look].GetObject(TEXT("Expression"));

		if (CallsTo(Condition) != TEXT("LessEqual_IntInt")) return false;

		const TArray<FUObjectJsonValueExport> Operands = Condition.Has(TEXT("Parameters")) ? Condition.GetArray(TEXT("Parameters")) : TArray<FUObjectJsonValueExport>();

		if (Operands.Num() < 2 || ReadFrom(Operands[0]) != Counter || ReadFrom(Operands[1]) != Ends) return false;

		Inside.Add(Where);

		/* The run ends where the comparison fails */
		if (!Carry()) return false;

		const FString Ending = TokenOf(Statements[Look]);

		if (Ending != TEXT("EX_PopExecutionFlowIfNot") && Ending != TEXT("EX_JumpIfNot")) return false;

		Inside.Add(Where);

		/* A conditional jump says where it goes when it fails. A conditional pop carries on wherever
		 * it was pushed to, which is not this macro's to say, so nothing runs from Completed. */
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

		/* And back round to the last index, or this is some other loop entirely */
		if (!Carry() || Where != Compare) return false;

		/* Every read of the counter in the body is a read of what the macro hands out */
		Out.Handouts.Add(Counter, TEXT("Array Index"));

		Out.Inputs.Add(TEXT("Array"), Measured[0]);

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

REGISTER_MACRO(FForEachLoopByLastIndexMacro)
