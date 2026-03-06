@ECHO OFF

SETLOCAL EnableDelayedExpansion

(SET \n=^

)

: -------------------------------------------------- Prompt user for preferred language(s) --------------------------------------------------

IF "%~1"=="subroutine" (
	REM CALL :TEST1 %~3
	ECHO ~1 %~1, ~2 %~2, ~3 %~3
	REM ECHO started @!time!
	CALL :%~2 "%~3"
	: --------------- Copy %~dp0..\Content\i18n\**\*.json to FModel json-exports [ R:\Temp\Exports\Game\Content\i18n\**\*.json ] ---------------
	: ----------------- UE4Editor to JsonAsAsset to import FModel json-exports [ R:\Temp\Exports\Game\Content\i18n\**\*.json ] -----------------
	: ------------------------------------------------------------ UnrealPak -Create ------------------------------------------------------------
	ECHO:
	ECHO %~1, completed @!time!
	PAUSE
	GOTO :EOF
)

SET /P TargetLanguage="Which language(s) to output? If multiple, separate by spaces (de en es fr it pt-BR ja ko zh-Hans zh-Hant)!\n!"

CALL :Divider

: ---------------------------------------------------------------- Routines ----------------------------------------------------------------

: : Copy 4sval's FModel / joric's CUE4Parse.CLI Holiday/Content/StringTables/**/*.uasset json-exports of Dragon Quest X Offline StringTables to this directory
: CALL :CUE4Parse.CLI

: ------------------------------------------------------------------ TEST ------------------------------------------------------------------

FOR %%L IN (!TargetLanguage!) DO (
	SET LANGUAGE=%%L
	CALL :TEST1 !LANGUAGE!
)

: ------------------------------------------------------------------ TEST ------------------------------------------------------------------

: REM FOR %%L IN (de en es fr it pt-BR) DO (
: FOR %%L IN (!TargetLanguage!) DO (
: 	SET LANGUAGE=%%L
: 	CALL :JQ_Game.locres.yaml_to_StringTable.json !LANGUAGE!
: 	REM FOR /F "usebackq delims=" %%F IN (`dir "R:\Temp\Exports\Game\Content\StringTables\Game\" /s /b /a-d /o:n`) DO (
: 	FOR /F "usebackq delims=" %%F IN (`dir "%~dp0StringTables\Game\" /b /a-d /o:n /s`) DO (
: 		SET FILENAME=%%~nF
: 			ECHO FILENAME =         !FILENAME!
: 		REM SET INPUT_NEW=%~dp0i18n\!FILENAME!.%%L.json
: 		SET INPUT_NEW=%~dp0temp\%%L\!FILENAME!.json
: 			ECHO INPUT_NEW =        !INPUT_NEW!
: 		SET FILEPATH=%%F
: 			ECHO FILEPATH =         !FILEPATH!
: 		SET SOURCE_PATH=!FILEPATH!
: 			ECHO SOURCE_PATH =      !SOURCE_PATH!
: 		SET DESTINATION_PATH=!SOURCE_PATH:\StringTables\=\..\Content\i18n\%%L\StringTables\!
: 			ECHO DESTINATION_PATH = !DESTINATION_PATH!
: 		CALL :JQ_StringTables_to_i18n
: 		CALL :Divider
: 	)
: )
: rmdir /Q /S "%~dp0temp\"

ENDLOCAL

PAUSE

GOTO :EOF

: --------------------------------------------------------------- Subroutines ---------------------------------------------------------------

:CUE4Parse.CLI
(
	REM CALL :CUE4Parse.CLI
	REM https://github.com/joric/CUE4Parse.CLI
	IF NOT EXIST "R:\DEBUG\CUE4Parse.CLI\" (
		mkdir "R:\DEBUG\CUE4Parse.CLI"
		REM curl -LO --output-dir "R:\DEBUG\CUE4Parse.CLI\" https://github.com/joric/CUE4Parse.CLI/releases/tag/cli-0.1.3
		copy "T:\Downloads\CUE4Parse.CLI-0.1.3-Win64-bin.zip" "R:\DEBUG\CUE4Parse.CLI\CUE4Parse.CLI-0.1.3-Win64-bin.zip"
		tar -C "R:\DEBUG\CUE4Parse.CLI" -xf "R:\DEBUG\CUE4Parse.CLI\CUE4Parse.CLI-0.1.3-Win64-bin.zip"
	)
	: ------------------------------------------- Holiday/Content/StringTables/**/*.uasset to .json  -------------------------------------------
	"R:\DEBUG\CUE4Parse.CLI\cue4parse.exe"
	FOR %%N IN (2060401 2060402) DO (
		"R:\DEBUG\CUE4Parse.CLI\cue4parse.exe" ^
		--format json ^
		--game GAME_UE4_26 ^
		--input "S:\Steam\game_backups\steamapps\common\DRAGON QUEST X OFFLINE Demo\.DepotDownloader\%%N\Game" ^
		--key 0x8B51D59ED5C495E1ECF7E2960F218F4868A31CEF3DBC5248F70CADCF809D1193 ^
		--mappings "S:\Consoles\Valve Steam\tools\DUMPs\DRAGON QUEST X OFFLINE\Steam--App_ID-1358750--Build_ID-14529657.usmap" ^
		--output "R:\DEBUG\CUE4Parse.CLI" ^
		--package "Game/Content/StringTables/*"
		ECHO:
	)
	del "R:\DEBUG\CUE4Parse.CLI\Game\Content\StringTables\Game\Battle\PAL_BattleMessage.json"
	robocopy "R:\DEBUG\CUE4Parse.CLI\Game\Content\StringTables\\" "%~dp0StringTables\\" /S /Z
	: --------------------------------------- Game.locres.yaml to Holiday/Content/StringTables/**/*.json  ---------------------------------------
	CALL :Divider
	EXIT /B 0
)

:Divider
(
	ECHO:
	ECHO --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	ECHO:
	EXIT /B 0
)

:TEST1
(
	ECHO %*, started @!time!
	: -------------------------------------- Start separate windows / parallel processes for each language --------------------------------------
	REM START "%*" cmd.exe /C %~dpnx0 "subroutine" TEST2 "%*"
	START "%*" cmd.exe /C %~dpnx0 "subroutine" TEST_JQ_Game.locres.yaml_to_StringTable.json "%*"
	EXIT /B 0
)

:TEST_JQ_Game.locres.yaml_to_StringTable.json
(
	IF NOT EXIST "%~dp0temp\%~1" (
		mkdir "%~dp0temp\%~1\"
	)
	ECHO:

	cd "%~dp0temp\%~1\"

	ECHO Splitting Game.locres.yaml by %~1
	REM yq eval "%~dp0Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec ^
	yq eval "%~dp0..\..\..\..\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec ^
	| jq --arg LANGUAGE "%~1" --from-file ^
	"%~dp0..\..\..\..\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.json_--from-file.txt" ^
	> "%~dp0temp\%~1\_%~1.json"
	
	ECHO Splitting _%~1.json by Namespaces
	yq ".[]" -s "key" "%~dp0temp\%~1\_%~1.json"
	del "%~dp0temp\%~1\_%~1.json"
	
	ECHO Formatting *.json for JsonAsAsset imports
	FOR /F "usebackq delims=" %%N IN (`dir "%~dp0temp\%~1\" /b /o:n`) DO (
		jq "[{ StringTable: { KeysToEntries: . } }]" "%~dp0temp\%~1\%%N" > "%~dp0temp\%~1\%%N.tmp"
		ECHO         move "%~dp0temp\%~1\%%N.tmp" "%~dp0temp\%~1\%%N"
		move "%~dp0temp\%~1\%%N.tmp" "%~dp0temp\%~1\%%N"
	)
	CALL :Divider
	: ------------------------------------- %~dp0StringTables\**\*.json to i18n\%%L\StringTables\**\*.json -------------------------------------
	FOR %%L IN (%~1) DO (
		FOR /F "usebackq delims=" %%F IN (`dir "%~dp0StringTables\Game\" /b /a-d /o:n /s`) DO (
			SET FILENAME=%%~nF
				ECHO FILENAME =         !FILENAME!
			SET INPUT_NEW=%~dp0temp\%%L\!FILENAME!.json
				ECHO INPUT_NEW =        !INPUT_NEW!
			SET FILEPATH=%%F
				ECHO FILEPATH =         !FILEPATH!
			SET SOURCE_PATH=!FILEPATH!
				ECHO SOURCE_PATH =      !SOURCE_PATH!
			SET DESTINATION_PATH=!SOURCE_PATH:\StringTables\=\..\Content\i18n\%%L\StringTables\!
				ECHO DESTINATION_PATH = !DESTINATION_PATH!
			CALL :JQ_StringTables_to_i18n
			CALL :Divider
		)
	)
	REM rmdir /Q /S "%~dp0temp\"
	EXIT /B 0
)

:JQ_StringTables_to_i18n
(
	jq --exit-status -n ^
	"input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) | [.]" ^
	"!SOURCE_PATH!" ^
	"!INPUT_NEW!" ^
	> nul
	REM ECHO jq exit-status = !ERRORLEVEL!
	IF !ERRORLEVEL! == 0 (
		ECHO:
		jq --exit-status -n ^
		"input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |=  if $new.StringTable.KeysToEntries[$k] ^!^= null then $new.StringTable.KeysToEntries[$k] else $old.StringTable.KeysToEntries[$k] end  ) | [.]" ^
		"!SOURCE_PATH!" ^
		"!INPUT_NEW!" ^
		> !DESTINATION_PATH!
	) ELSE IF !ERRORLEVEL! == 2 (
		ECHO:
		ECHO jq exit-status = !ERRORLEVEL!
		ECHO !SOURCE_PATH! >> %~dp0%~n0.missing_inputs.log
	) ELSE (
		ECHO jq exit-status = !ERRORLEVEL!
	)
	EXIT /B 0
)

REM :JQ_Game.locres.yaml_to_StringTable.json
REM (
REM 	IF NOT EXIST "%~dp0temp\%*" (
REM 		mkdir "%~dp0temp\%*\"
REM 	)
REM 	ECHO:
REM 
REM 	cd "%~dp0temp\%*\"
REM 
REM 	ECHO Splitting Game.locres.yaml by %*
REM 	REM yq eval "%~dp0Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec ^
REM 	yq eval "%~dp0..\..\..\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec ^
REM 	| jq --arg LANGUAGE "%*" --from-file ^
REM 	"%~dp0..\..\..\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.json_--from-file.txt" ^
REM 	> "%~dp0temp\%*\_%*.json"
REM 
REM 	ECHO Splitting _%*.json by Namespaces
REM 	yq ".[]" -s "key" "%~dp0temp\%*\_%*.json"
REM 	del "%~dp0temp\%*\_%*.json"
REM 
REM 	ECHO Formatting *.json for JsonAsAsset imports
REM 	FOR /F "usebackq delims=" %%N IN (`dir "%~dp0temp\%*\" /b /o:n`) DO (
REM 		jq "[{ StringTable: { KeysToEntries: . } }]" "%~dp0temp\%*\%%N" > "%~dp0temp\%*\%%N.tmp"
REM 		ECHO         move "%~dp0temp\%*\%%N.tmp" "%~dp0temp\%*\%%N"
REM 		move "%~dp0temp\%*\%%N.tmp" "%~dp0temp\%*\%%N"
REM 	)
REM 	EXIT /B 0
REM )
