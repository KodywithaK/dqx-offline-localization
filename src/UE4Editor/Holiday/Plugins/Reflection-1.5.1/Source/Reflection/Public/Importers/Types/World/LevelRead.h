/* Copyright Reflection Contributors 2024-2026 */

#pragma once

#include "CoreMinimal.h"
#include "Serializers/SerializerContainer.h"

class AActor;
struct FUObjectExport;

/* What a level read turned up, which is mostly what it could not do */
struct FRLevelReadResult {
	/* The level it made, by package name */
	FString Level;

	/* Placed and filled in */
	int32 Placed = 0;

	/* Named a blueprint that is in neither the project nor the Cloud */
	int32 MissingBlueprints = 0;

	/* Named a class the blueprint came across for and this engine still cannot make an actor of */
	int32 UnusableClasses = 0;

	/* Left out because the options said to leave it out */
	int32 LeftOut = 0;

	/* Levels this one brings in, read through reads of their own */
	int32 SubLevels = 0;

	/* Named a level that is in neither the project nor the Cloud */
	int32 MissingSubLevels = 0;

	/* HLOD actors tied back to the description in their proxy, and left without one */
	int32 HLODsTied = 0;
	int32 HLODsUntied = 0;

	/* Everything else: an export that is not an actor's, or one the world refused to spawn */
	int32 Failed = 0;

	int32 Missing() const {
		return MissingBlueprints + UnusableClasses + Failed;
	}
};

/* Reads a level by path like any other asset, into whatever level the editor has open */
class REFLECTION_API FLevelRead : public USerializerContainer {
public:
	/* Whether these are a level, which its world says and the first export does not */
	static bool Handles(const TArray<TSharedPtr<FJsonValue>>& Exports);

	/* Reads them into the open level. False where it is behind Experiments. */
	static bool FromCloud(const TArray<TSharedPtr<FJsonValue>>& Exports, const FString& Path, FRLevelReadResult* OutResult = nullptr);

private:
	FRLevelReadResult Read(const TArray<TSharedPtr<FJsonValue>>& Exports, const FString& Path);

	/* Whether the options allow an actor of this class, and whether the class may be fetched */
	bool Allows(const FUObjectExport* Export, bool& bOutMayFetch) const;

	/* The class an actor is of, fetched where allowed. Known keeps what each lookup answered. */
	UClass* ClassOf(FUObjectExport* Export, bool bMayFetch, TMap<FString, UClass*>& Known, FRLevelReadResult& Result) const;

	/* The level to read into: the one the package holds, emptied, or a new one */
	UWorld* LevelFor(UPackage* Package) const;

	/* Writes what the level says about itself onto the settings the new level already has */
	void ReadWorldSettings(UWorld* World, FUObjectExport* Export) const;

	/* The levels this one brings in: a foundation names one in AdditionalWorlds, a streaming level on its world */
	static void SubLevelsNamed(const TArray<TSharedPtr<FJsonValue>>& Exports, FUObjectExport* World, TArray<FString>& OutNamed);

	/* Reads each, skipping any the project already has. Named is in editor spelling. */
	void ReadSubLevels(const TArray<FString>& Named, FRLevelReadResult& Result) const;

	/* Ties the HLOD actors back to their proxies, since the map and the descriptions are editor-only and the cook drops both */
	void ReadHLODs(UWorld* World, const TArray<class ALODActor*>& Actors, FRLevelReadResult& Result) const;

	/* As many HLOD levels as the actors say: the setup is editor-only, and an empty one has every HLOD actor deleted */
	void ReadHLODSetup(UWorld* World, const TArray<class ALODActor*>& Actors) const;
};
