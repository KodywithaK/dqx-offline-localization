#pragma once
#include "CoreMinimal.h"
#include "Engine/DataTable.h" //CROSS-MODULE INCLUDE V2: -ModuleName=Engine -ObjectName=TableRowBase -FallbackName=TableRowBase
#include "HOLITextRubyData_TableRow.generated.h"

USTRUCT(BlueprintType)
struct FHOLITextRubyData_TableRow : public FTableRowBase {

    GENERATED_BODY()

public:
    UPROPERTY(BlueprintReadWrite, EditAnywhere, meta = (AllowPrivateAccess = true))
    FString Word;

    UPROPERTY(BlueprintReadWrite, EditAnywhere, meta = (AllowPrivateAccess = true))
    FString Ruby;

    UPROPERTY(BlueprintReadWrite, EditAnywhere, meta = (AllowPrivateAccess = true))
    int32 WordLength;

    UPROPERTY(BlueprintReadWrite, EditAnywhere, meta = (AllowPrivateAccess = true))
    int32 RubyLength;

    UPROPERTY(BlueprintReadWrite, EditAnywhere, meta = (AllowPrivateAccess = true))
    bool IsRubyTag;

    //HOLIDAY_API FHOLITextRubyData_TableRow();
    FHOLITextRubyData_TableRow();
};
