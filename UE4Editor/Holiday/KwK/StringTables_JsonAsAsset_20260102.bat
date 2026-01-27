@ECHO OFF

SETLOCAL EnableDelayedExpansion

(SET \n=^

)

: -------------------------------------------------- Prompt user for preferred language(s) --------------------------------------------------

SET /P TargetLanguage="Which language(s) to output? If multiple, separate by spaces (de en es fr it pt-BR ja ko zh-Hans zh-Hant)!\n!"

: ---------------------------------------------------------------- Routines ----------------------------------------------------------------

@REM FOR %%L IN (de en es fr it pt-BR) DO (
FOR %%L IN (!TargetLanguage!) DO (
	SET LANGUAGE=%%L
	CALL :JQ_Game.locres.yaml_to_StringTable.json !LANGUAGE!
	FOR /F "usebackq delims=" %%F IN (`dir "%~dp0\StringTables\Game\" /s /b /a-d /o:n`) DO (
		SET FILENAME=%%~nF
			ECHO FILENAME =         !FILENAME!
		@REM SET INPUT_NEW=%~dp0\i18n\!FILENAME!.%%L.json
		SET INPUT_NEW=%~dp0\temp\%%L\!FILENAME!.json
			ECHO INPUT_NEW =        !INPUT_NEW!
		SET FILEPATH=%%F
			ECHO FILEPATH =         !FILEPATH!
		SET SOURCE_PATH=!FILEPATH!
			ECHO SOURCE_PATH =      !SOURCE_PATH!
		SET DESTINATION_PATH=!SOURCE_PATH:\StringTables\=\i18n\%%L\StringTables\!
			ECHO DESTINATION_PATH = !DESTINATION_PATH!
		CALL :JQ_StringTables_to_i18n
		CALL :DIVIDER
	)
)
rmdir /Q /S "%~dp0\temp\"

ENDLOCAL

PAUSE

: -------------------------------------------------------------- Subroutines --------------------------------------------------------------

:DIVIDER
(
	ECHO:
	ECHO --------------------------------------------------------------------------------------------------------------------------------------------
	ECHO:
	EXIT /B
)

:JQ_Game.locres.yaml_to_StringTable.json
(
	IF NOT EXIST "%~dp0\temp\%*" (
		mkdir "%~dp0\temp\%*\"
	)
	ECHO:

	cd "%~dp0\temp\%*\"

	ECHO Splitting Game.locres.yaml by LANGUAGE
	yq eval "%~dp0\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec ^
	| jq --arg LANGUAGE "%*" --from-file ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.json_--from-file.txt" ^
	> "%~dp0\temp\%*\_%*.json"

	ECHO Splitting _%*.json by Namespaces
	yq ".[]" -s "key" "%~dp0\temp\%*\_%*.json"
	del "%~dp0\temp\%*\_%*.json"

	ECHO Formatting *.json for JsonAsAsset imports
	FOR /F "usebackq delims=" %%N IN (`dir "%~dp0\temp\%*\" /b /o:n`) DO (
		jq "[{ StringTable: { KeysToEntries: . } }]" "%~dp0\temp\%*\%%N" > "%~dp0\temp\%*\%%N.tmp"
		move "%~dp0\temp\%*\%%N.tmp" "%~dp0\temp\%*\%%N"
	)
	EXIT /B
)

:JQ_StringTables_to_i18n
(
	ECHO:
	jq --exit-status -n ^
	"input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) | [.]" ^
	"!SOURCE_PATH!" ^
	"!INPUT_NEW!" ^
	> nul
	@REM ECHO jq exit-status = !ERRORLEVEL!
	IF !ERRORLEVEL! == 0 (
		ECHO:
		jq --exit-status -n ^
		"input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) | [.]" ^
		"!SOURCE_PATH!" ^
		"!INPUT_NEW!" ^
		> !DESTINATION_PATH!
	) ELSE IF !ERRORLEVEL! == 2 (
		ECHO jq exit-status = !ERRORLEVEL!
		ECHO !SOURCE_PATH! >> %~dp0\StringTables_JsonAsAsset_20260102_missing_inputs.log
	) ELSE (
		ECHO jq exit-status = !ERRORLEVEL!
	)
	EXIT /B
)