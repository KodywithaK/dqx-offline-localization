@ECHO OFF

SET "BATCH=%~dpnx0"
SET "02_Create_Latest_Release.yml.bat=%~dp0!    02_Create_Latest_Release.yml.bat"

: ---------------------------------------------------- PREREQUISITE ----------------------------------------------------

REM "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\UE4Editor\Holiday\KwK\StringTables\Game\**\*"

IF [%1]==[] (
	: ---------------------------------------- WITHOUT ARGUMENT ----------------------------------------
	REM ECHO ~1 = %~1
) ELSE (
	: ----------------------------------------- WITH ARGUMENT -----------------------------------------
	CALL :NOTE ~0 = %~0
	CALL :NOTE ~1 = %~1
	CALL :NOTE ~2 = %~2
	CALL %~1 %~2
	PAUSE
	GOTO :EOF
)

R:
IF NOT EXIST "R:\DEBUG" (
	mkdir "R:\DEBUG"
)
cd "R:\DEBUG"

SETLOCAL EnableDelayedExpansion

: ----------------------------------------------- Prompt for language(s) -----------------------------------------------

CALL :NOTE Which language\(s\) to output? If multiple, separate by spaces \(de en es fr it pt-BR ja ko zh-Hans zh-Hant\)
SET /P TargetLanguage=""
CALL :DIVIDER

: -------------------------------------------------------------- Checkout_Repos --------------------------------------------------------------
IF NOT EXIST "R:\DEBUG\dqx_dat_dump" (
	CALL :TIP gh repo clone KodywithaK/dqx_dat_dump -- --branch testing --single-branch
	gh repo clone KodywithaK/dqx_dat_dump -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\dqx-offline-localization" (
	CALL :TIP gh repo clone KodywithaK/dqx-offline-localization -- --branch main --single-branch
	gh repo clone KodywithaK/dqx-offline-localization -- --branch main --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\LocRes-Builder" (
	CALL :TIP gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch
	gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\LocRes-Builder\INPUT" (
	mkdir "R:\DEBUG\LocRes-Builder\INPUT"
)

:START
REM RAMDISK SPEEDTEST 2026.05.17
IF NOT EXIST "R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\\" (
	CALL :TIP ROBOCOPY "D:\\Coding\\github.com\\repo\\KodywithaK\\dqx-offline-localization\\tree\\main\\src\\UE4Editor\\Holiday\\KwK\\StringTables\\\\" "R:\\DEBUG\\dqx-offline-localization\\src\\UE4Editor\\Holiday\\KwK\\StringTables\\\\" /S /Z
	ROBOCOPY "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\UE4Editor\Holiday\KwK\StringTables\\" "R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\\" /S /Z
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\Content\i18n\\" (
	CALL :TIP ROBOCOPY "D:\\Coding\\github.com\\repo\\KodywithaK\\dqx-offline-localization\\tree\\main\\src\\UE4Editor\\Holiday\\Content\\i18n\\\\" "R:\\DEBUG\\dqx-offline-localization\\src\\UE4Editor\\Holiday\\Content\\i18n\\\\" /S /XF *.uasset /Z
	ROBOCOPY "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\UE4Editor\Holiday\Content\i18n\\" "R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\Content\i18n\\" /S /XF *.uasset /Z
	CALL :DIVIDER
)
REM RAMDISK SPEEDTEST 2026.05.17
FOR %%L IN (!TargetLanguage!) DO (
	SET LANGUAGE=%%L
	CALL :TIP NOW LOADING . . . !LANGUAGE!
	REM START "!LANGUAGE!" cmd.exe /C "%~dpnx0" :Game.locres.yaml !LANGUAGE!
	START "!LANGUAGE!" cmd.exe /C "!BATCH!" :Game.locres.yaml !LANGUAGE!
)

CALL :DIVIDER

"F:\Test\Holiday\Holiday.uproject"

PAUSE

CALL :DIVIDER

CALL :TIP !02_Create_Latest_Release.yml.bat!
!02_Create_Latest_Release.yml.bat!

ENDLOCAL

GOTO :EOF

: ----------------------------------------------------- Subroutines -----------------------------------------------------

:Game.locres.yaml
(
	R:
	IF NOT EXIST "R:\DEBUG\JsonAsAsset\%~1" (
		mkdir "R:\DEBUG\JsonAsAsset\%~1"
	)
	CD "R:\DEBUG\JsonAsAsset\%~1\"
	: ---------------------------- Splitting Game.locres.yaml by !LANGUAGE! ----------------------------
	ECHO Splitting Game.locres.yaml by %~1
	yq eval ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.yaml" ^
	-o json --yaml-fix-merge-anchor-to-spec ^
	| jq --arg LANGUAGE "%~1" --from-file ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.jq" ^
	> "R:\DEBUG\JsonAsAsset\%~1\_%~1.json"
	: ---------------------------- Splitting _!LANGUAGE!.json by Namespaces ----------------------------
	ECHO Splitting _%~1.json by Namespaces
	ECHO yq ".[]" -s "key" "R:\DEBUG\JsonAsAsset\%~1\_%~1.json"
	yq ".[]" -s "key" "R:\DEBUG\JsonAsAsset\%~1\_%~1.json"
	DEL "R:\DEBUG\JsonAsAsset\%~1\_%~1.json"
	: ---------------------------- Formatting *.json for JsonAsAsset import ----------------------------
	ECHO Formatting *.json for JsonAsAsset import
	FOR /F "usebackq delims=" %%N IN (`dir "R:\DEBUG\JsonAsAsset\%~1\" /b /o:n`) DO (
		jq "[{ StringTable: { KeysToEntries: . } }]" ^
		"R:\DEBUG\JsonAsAsset\%~1\%%N" ^
		> "R:\DEBUG\JsonAsAsset\%~1\%%N.tmp"
		REM ECHO         MOVE "R:\DEBUG\JsonAsAsset\%~1\%%N.tmp" "R:\DEBUG\JsonAsAsset\%~1\%%N"
		MOVE "R:\DEBUG\JsonAsAsset\%~1\%%N.tmp" "R:\DEBUG\JsonAsAsset\%~1\%%N"
	)
	: ----------------- %~dp0StringTables\**\*.json to i18n\%%L\StringTables\**\*.json -----------------
	SETLOCAL EnableDelayedExpansion
	FOR %%L IN (%~1) DO (
		REM FOR /F "usebackq delims=" %%F IN (`dir "R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\Game\" /b /a-d /o:n /s`) DO (
		REM RAMDISK SPEEDTEST 2026.05.17
		REM FOR /F "usebackq delims=" %%F IN (`dir "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\UE4Editor\Holiday\KwK\StringTables\Game\" /b /a-d /o:n /s`) DO (
		REM RAMDISK SPEEDTEST 2026.05.17
		FOR /F "usebackq delims=" %%F IN (`dir "R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\Game\" /b /a-d /o:n /s`) DO (
			SET FILENAME=%%~nF
				ECHO FILENAME =         !FILENAME!
			SET INPUT_NEW=R:\DEBUG\JsonAsAsset\%%L\!FILENAME!.json
				ECHO INPUT_NEW =        !INPUT_NEW!
			SET FILEPATH=%%F
				ECHO FILEPATH =         !FILEPATH!
			SET SOURCE_PATH=!FILEPATH!
				ECHO SOURCE_PATH =      !SOURCE_PATH!
			SET DESTINATION_PATH=!SOURCE_PATH:\StringTables\=\..\Content\i18n\%%L\StringTables\!
				ECHO DESTINATION_PATH = !DESTINATION_PATH!
			REM CALL :JQ_StringTables_to_i18n
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
				CALL :CAUTION jq exit-status = !ERRORLEVEL!
			) ELSE (
				CALL :CAUTION jq exit-status = !ERRORLEVEL!
			)
			CALL :DIVIDER
		)
		: ----------------------------- Copy *.json to FModel export locations -----------------------------
		REM RAMDISK SPEEDTEST 2026.05.17
		REM ROBOCOPY ^
		REM "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\UE4Editor\Holiday\Content\i18n\%%L\StringTables\GAME\\" ^
		REM "R:\Temp\Exports\Holiday\Content\i18n\%%L\StringTables\GAME\\" ^
		REM /S /XF *.uasset /Z
		ROBOCOPY ^
		"R:\DEBUG\dqx-offline-localization\src\UE4Editor\Holiday\Content\i18n\%%L\StringTables\GAME\\" ^
		"R:\Temp\Exports\Holiday\Content\i18n\%%L\StringTables\GAME\\" ^
		/S /XF *.uasset /Z

		CALL :IMPORTANT ROBOCOPY 'R:\\Temp\\Exports\\Holiday\\Content\\i18n\\%%L\\StringTables\\GAME\\Battle\\\\\\' 'R:\\Temp\\Exports\\Holiday\\Content\\i18n\\%%L\\DLC\\Ver2\\StringTables\\Game\\Battle\\\\\\' ^
		'STT_EventMonsterName_2nd.json' ^
		/MOV

		ROBOCOPY ^
		"R:\Temp\Exports\Holiday\Content\i18n\%%L\StringTables\GAME\Battle\\" ^
		"R:\Temp\Exports\Holiday\Content\i18n\%%L\DLC\Ver2\StringTables\Game\Battle\\" ^
		"STT_EventMonsterName_2nd.json" ^
		/MOV
		REM RAMDISK SPEEDTEST 2026.05.17
	)
	ENDLOCAL
	ECHO:
	EXIT /B 0
)

:DIVIDER
(
	: ----------------------------------- Incorrect window width fix -----------------------------------
	mode con | findstr "Columns" > nul
	: ------------------------------------------ SET VARIABLE ------------------------------------------
	SET CHARACTER=X
	SET OUPUT_STRING=
	: ------------------------------------ Find the width of window ------------------------------------
	FOR /F "usebackq tokens=2 delims=:" %%B IN (`mode con ^| findstr "Columns"`) DO (
		FOR /F "tokens=*" %%C IN ("%%B") DO (
			REM ECHO C = %%C
			SET COUNT=%%C
		)
	)
	REM ECHO COUNT = !COUNT!
	: ------------------------------------ Create fullwidth divider ------------------------------------
	FOR /L %%i IN (1,1,!COUNT!) DO (
		REM Append the character in each iteration
		SET OUPUT_STRING=!OUPUT_STRING!!CHARACTER!
		REM ECHO OUPUT_STRING=!OUPUT_STRING!!CHARACTER!
	)
	REM ECHO OUTPUT_STRING = !OUPUT_STRING!
	: -------------------------------------------- :DIVIDER --------------------------------------------
	ECHO:
	ECHO !OUPUT_STRING!
	ECHO:
	EXIT /B 0
)

:CAUTION
(
	: --------------------------------------- ANSI Console Color ---------------------------------------
	wsl echo -e "\x1b[31m$(echo %*)\x1b[00m"
	EXIT /B 0
)

:TIP
(
	: --------------------------------------- ANSI Console Color ---------------------------------------
	wsl echo -e "\x1b[32m$(echo %*)\x1b[00m"
	EXIT /B 0
)

:WARNING
(
	: --------------------------------------- ANSI Console Color ---------------------------------------
	wsl echo -e "\x1b[33m$(echo %*)\x1b[00m"
	EXIT /B 0
)

:NOTE
(
	: --------------------------------------- ANSI Console Color ---------------------------------------
	wsl echo -e "\x1b[34m$(echo %*)\x1b[00m"
	EXIT /B 0
)

:IMPORTANT
(
	: --------------------------------------- ANSI Console Color ---------------------------------------
	wsl echo -e "\x1b[35m$(echo %*)\x1b[00m"
	EXIT /B 0
)
