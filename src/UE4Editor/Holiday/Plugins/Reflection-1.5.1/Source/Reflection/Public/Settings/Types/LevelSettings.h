/* Copyright Reflection Contributors 2024-2026 */

#pragma once

#include "CoreMinimal.h"
#include "LevelSettings.generated.h"

/* Which of a level's actors are placed, which is most of what reading one costs */
UENUM()
enum class ERLevelActors : uint8 {
	/* Everything the level lists, fetching whatever classes it names */
	Everything UMETA(DisplayName = "Everything"),

	/* Only what this engine already has a class for, so nothing is fetched to place an actor */
	NoBlueprints UMETA(DisplayName = "Nothing a Blueprint Makes"),

	/* Static mesh actors and nothing else */
	StaticMeshesOnly UMETA(DisplayName = "Static Mesh Actors Only"),

	/* The merged stand-ins and nothing else, which is the level at the distance it is seen from */
	HLODsOnly UMETA(DisplayName = "HLOD Actors Only"),

	/* None of them, which leaves whatever else below is switched on */
	Nothing UMETA(DisplayName = "Nothing")
};

/* Settings for reading a level */
USTRUCT()
struct FRLevelSettings {
	GENERATED_BODY()
public:
	/* Which of the level's actors are placed */
	UPROPERTY(EditAnywhere, Config, Category = LevelSettings)
	ERLevelActors Actors = ERLevelActors::Everything;

	/* The levels this one streams in, each a read of its own */
	UPROPERTY(EditAnywhere, DisplayName = "Sub Levels", Config, Category = LevelSettings)
	bool SubLevels = true;

	/* What it says about culling, navigation and the rest, onto the settings already there */
	UPROPERTY(EditAnywhere, DisplayName = "World Settings", Config, Category = LevelSettings)
	bool WorldSettings = true;

	/* The merged stand-ins drawn at distance, each naming an HLOD proxy to fetch */
	UPROPERTY(EditAnywhere, DisplayName = "LOD Actors", Config, Category = LevelSettings)
	bool LODActors = true;
};
