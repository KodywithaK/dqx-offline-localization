/* Copyright Reflection Contributors 2024-2026 */

#include "Importers/Types/Blueprint/GraphTidy.h"

#include "EdGraph/EdGraph.h"
#include "EdGraphSchema_K2.h"
#include "K2Node_DynamicCast.h"

DECLARE_LOG_CATEGORY_CLASS(LogReflectionTidyPureCast, All, All);

/* A cast the run never went through.
 *
 * A cast is written down the same way whichever kind it is: the thing cast into a local, whether it
 * worked into another, and the second one read. What says which kind it was is what reads it. The
 * run testing it and going one way or the other is a cast with two ways out, which is an impure
 * one. Anything else reading it is a value like any other, which is a pure one.
 *
 * Read as written they all come back impure, and the ones that were not are left standing in the
 * run with a bool coming off the side of them. Worse, a pure cast guards what is read through it by
 * itself: the compiler writes that guard into the condition, so the graph gains an And nobody drew,
 * with the cast wired into it.
 *
 * Which kind it was cannot be told when it is laid down, since what reads it comes later, so it is
 * settled here once everything is placed. */
struct FPureCastTidy final : FGraphTidy {
	virtual const TCHAR* GetName() const override { return TEXT("PureCast"); }

	virtual int32 Apply(UEdGraph* Graph) const override {
		if (Graph == nullptr) return 0;

		int32 Turned = 0;

		TArray<UEdGraphNode*> Nodes = Graph->Nodes;

		for (UEdGraphNode* Node : Nodes) {
			UK2Node_DynamicCast* Casting = Cast<UK2Node_DynamicCast>(Node);

			if (Casting == nullptr || Casting->IsNodePure()) continue;

			/* Whether it worked, read as a value. Nothing reads that off an impure cast: the run
			 * asks it by going one way or the other, which is what the two ways out are for. */
			UEdGraphPin* Worked = Casting->GetBoolSuccessPin();

			if (Worked == nullptr || Worked->LinkedTo.Num() == 0) continue;

			/* Unless the run does go the other way somewhere, in which case it is impure after all
			 * and what reads the bool is reading it off a cast that answers both ways */
			UEdGraphPin* Failed = Casting->GetInvalidCastPin();

			if (Failed != nullptr && Failed->LinkedTo.Num() > 0) continue;

			/* What the run does either side of it, since a pure one is not in the run at all and
			 * taking it out would leave what came before it with nowhere to go */
			UEdGraphPin* Into = Casting->GetExecPin();
			UEdGraphPin* OnFrom = Casting->GetValidCastPin();

			TArray<UEdGraphPin*> Before = Into != nullptr ? Into->LinkedTo : TArray<UEdGraphPin*>();
			TArray<UEdGraphPin*> After = OnFrom != nullptr ? OnFrom->LinkedTo : TArray<UEdGraphPin*>();

			/* Asked after the pins exist, since it is the pins it rebuilds */
			Casting->SetPurity(true);

			/* And the run carries on straight through where it used to stop */
			for (UEdGraphPin* From : Before) {
				for (UEdGraphPin* To : After) {
					if (From != nullptr && To != nullptr) From->MakeLinkTo(To);
				}
			}

			Turned++;
		}

		if (Turned > 0) {
			UE_LOG(LogReflectionTidyPureCast, Display, TEXT("\"%s\" had %d cast(s) standing in the run that nothing ever went the other way out of"), *Graph->GetName(), Turned);
		}

		return Turned;
	}
};

REGISTER_TIDY(FPureCastTidy)
