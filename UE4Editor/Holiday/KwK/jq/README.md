# Game.locres.yaml > StringTables.csv

```bat
@ECHO OFF

FOR %%L IN (de es en fr it pt-BR) DO (
	IF NOT EXIST "%~dp0jq\%%L\" (
		mkdir "%~dp0jq\%%L\"
	)
	FOR %%F IN (STT_Boukennosho_DLC_Text STT_Career_StoryUISys STT_CareerStoryVer1 STT_CareerStoryVer2 STT_CommonItem STT_EventPalceName STT_Monster_Tips1_ver1 STT_Monster_Tips1_ver2 STT_Monster_Tips2_ver1 STT_Monster_Tips2_Ver2 STT_Quest_ItemGet STT_QuestListDetail STT_QuestListName STT_QuestListSeries STT_System_Charamake STT_System_Common) DO (
		ECHO:
		ECHO creating " %~dp0jq\%%L\%%F.csv "
		ECHO:
		yq eval ^
		"%~dp0..\..\..\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" ^
		-o json ^
		--yaml-fix-merge-anchor-to-spec ^
		| jq ^
		--arg FILENAME "%%F" ^
		--arg LANGUAGE "%%L" ^
		--from-file StringTables_csv.jq ^
		--raw-output ^
		> "%~dp0jq\%%L\%%F.csv"
		type "%~dp0jq\%%L\%%F.csv"
		ECHO:
		ECHO ----------------------------------------------------------------------------------------------------
		ECHO:
	)
)

PAUSE
```
