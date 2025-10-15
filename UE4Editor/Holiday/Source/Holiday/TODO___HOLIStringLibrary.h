#pragma once
#include "CoreMinimal.h"
//CROSS-MODULE INCLUDE V2: -ModuleName=Engine -ObjectName=BlueprintFunctionLibrary -FallbackName=BlueprintFunctionLibrary
#include Kismet/BlueprintFunctionLibrary.h // KwK
//
#include "HOLIStringLibrary.generated.h"

UCLASS(Blueprintable)
class HOLIDAY_API UHOLIStringLibrary : public UBlueprintFunctionLibrary {
    GENERATED_BODY()
public:
    UHOLIStringLibrary();

    UFUNCTION(BlueprintCallable)
    static bool SaveToTextFile(const FString& Filename, const FString& inString);
    
    UFUNCTION(BlueprintCallable)
    static void PrintErrorLog(const FString& LogText, float Duration);
    
    UFUNCTION(BlueprintCallable)
    static bool LoadFromTextFile(const FString& Filename, FString& OutString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static bool IsStringIdentifier(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static bool IsStringDigit(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static bool IsStringASCII(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static bool IsStringAlpha(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static FString EnumToString(const FString& EnumName, uint8 EnumValue);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static FString ConvertLowerFullPitchString(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static FString ConvertHalfToFullWidthIncAlph(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static FString ConvertHalfToFullWidth(const FString& inString);
    
    UFUNCTION(BlueprintCallable, BlueprintPure)
    static FString ConvertFullToHalfWidth(const FString& inString);
};
