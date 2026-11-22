/* Copyright Reflection Contributors 2024-2026 */

#include "Settings/ReflectionSettings.h"
#include "Modules/Metadata.h"
#include "Modules/Support.h"
#include "Widgets/Input/SButton.h"
#include "Widgets/SBoxPanel.h"

FName GReflectionSettingsCategoryName = FName("Reflection");
FName GReflectionInternalName = FName("AmbientAudio");

UReflectionSettings::UReflectionSettings() {
	CategoryName = GReflectionSettingsCategoryName;
	SectionName = GReflectionName;
}

FText UReflectionSettings::GetSectionText() const {
	return FText::FromString("Settings");
}

#if WITH_EDITOR
void UReflectionSettings::PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent) {
	Super::PostEditChangeProperty(PropertyChangedEvent);

	/* The clock is stopped while the prompt is off, so turning it back on has to start one again. */
	if (PropertyChangedEvent.GetPropertyName() == GET_MEMBER_NAME_CHECKED(UReflectionSettings, ShowSupportPrompt)) {
		if (ShowSupportPrompt) {
			FReflectionSupport::Register();
		} else {
			FReflectionSupport::Unregister();
		}
	}
}
#endif
