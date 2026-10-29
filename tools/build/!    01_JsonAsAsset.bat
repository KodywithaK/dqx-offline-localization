@ECHO OFF

SET "BATCH=%~dpnx0"
SET "02_Create_Latest_Release.yml.bat=%~dp0!    02_Create_Latest_Release.yml.bat"

REM path of the directory where you cloned the repository is located
SET "${{ github.repository }}=D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main"
REM path of the directory where your working directory is located
SET "${{ github.workspace }}=R:\DEBUG"
REM path of the directory where your FModel output directory is located ( Settings - General - Output Directory * )
SET "${{ Fmodel.Output_Directory }}=R:\Temp"
REM path of the directory where your UE4.27 project is located
SET "${{ UE4Editor.project }}=F:\Test"

SETLOCAL EnableDelayedExpansion

CALL :ANSI TIP: SET "${{ github.repository }}=!${{ github.repository }}!"
CALL :ANSI TIP: SET "${{ github.workspace }}=!${{ github.workspace }}!"
CALL :ANSI TIP: SET "${{ Fmodel.Output_Directory }}=!${{ Fmodel.Output_Directory }}!"
CALL :ANSI TIP: SET "${{ UE4Editor.project }}=!${{ UE4Editor.project }}!"

IF NOT EXIST "!${{ github.workspace }}!" (
	MKDIR "!${{ github.workspace }}!"
)

ECHO CD /D "!${{ github.workspace }}!" && CD /D "!${{ github.workspace }}!"

: ---------------------------------------------------- PREREQUISITE ----------------------------------------------------

REM "!${{ github.repository }}!\src\UE4Editor\Holiday\KwK\StringTables\Game\**\*"

IF [%1]==[] (
	: ---------------------------------------- WITHOUT ARGUMENT ----------------------------------------
	REM ECHO ~1 = %~1
) ELSE (
	: ----------------------------------------- WITH ARGUMENT -----------------------------------------
	CALL :ANSI NOTE: "~0 = %~0"
	CALL :ANSI NOTE: "~1 = %~1"
	CALL :ANSI NOTE: "~2 = %~2"
	CALL %~1 %~2
	PAUSE
	GOTO :EOF
)

: ----------------------------------------------- Prompt for language(s) -----------------------------------------------

CALL :ANSI NOTE: "Which language(s) to output? If multiple, separate by spaces (de en es fr it pt-BR ja ko zh-Hans zh-Hant)"
REM CALL :ANSI NOTE: "Which language\(s\) to output? If multiple, separate by spaces \(de en es fr it pt-BR ja ko zh-Hans zh-Hant\)"
SET /P TargetLanguage=""
CALL :DIVIDER

: -------------------------------------------------------------- Checkout_Repos --------------------------------------------------------------
IF NOT EXIST "!${{ github.workspace }}!\dqx_dat_dump" (
	CALL :ANSI TIP: "gh repo clone KodywithaK/dqx_dat_dump -- --branch testing --single-branch"
	gh repo clone KodywithaK/dqx_dat_dump -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "!${{ github.workspace }}!\dqx-offline-localization" (
	CALL :ANSI TIP: "gh repo clone KodywithaK/dqx-offline-localization -- --branch main --single-branch"
	gh repo clone KodywithaK/dqx-offline-localization -- --branch main --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "!${{ github.workspace }}!\LocRes-Builder" (
	CALL :ANSI TIP: "gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch"
	gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "!${{ github.workspace }}!\LocRes-Builder\INPUT" (
	mkdir "!${{ github.workspace }}!\LocRes-Builder\INPUT"
)

:START
IF NOT EXIST "!${{ github.workspace }}!\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\\" (
	CALL :ANSI TIP: "ROBOCOPY "!${{ github.repository }}:\=\\!\\src\\UE4Editor\\Holiday\\KwK\\StringTables\\\\" "!${{ github.workspace }}:\=\\!\\dqx-offline-localization\\src\\UE4Editor\\Holiday\\KwK\\StringTables\\\\" /MT:32 /NFL /NDL /S /Z"
	ROBOCOPY ^
	"!${{ github.repository }}!\src\UE4Editor\Holiday\KwK\StringTables\\" ^
	"!${{ github.workspace }}!\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\\" ^
	/MT:32 /NDL /NFL /S /Z
	CALL :DIVIDER
)
IF NOT EXIST "!${{ github.workspace }}!\dqx-offline-localization\src\UE4Editor\Holiday\Content\i18n\\" (
	CALL :ANSI TIP: "ROBOCOPY "!${{ github.repository }}:\=\\!\\src\\UE4Editor\\Holiday\\Content\\i18n\\\\" "!${{ github.workspace }}:\=\\!\\dqx-offline-localization\\src\\UE4Editor\\Holiday\\Content\\i18n\\\\" /MT:32 /NFL /NDL /S /XF *.uasset /Z"
	ROBOCOPY ^
	"!${{ github.repository }}!\src\UE4Editor\Holiday\Content\i18n\\" ^
	"!${{ github.workspace }}!\dqx-offline-localization\src\UE4Editor\Holiday\Content\i18n\\" ^
	/MT:32 /NDL /NFL /S /XF *.uasset /Z
	CALL :DIVIDER
)
FOR %%L IN (!TargetLanguage!) DO (
	SET LANGUAGE=%%L
	CALL :ANSI TIP: "NOW LOADING . . . !LANGUAGE!"
	REM START "!LANGUAGE!" cmd.exe /C "%~dpnx0" :Game.locres.yaml !LANGUAGE!
	START "!LANGUAGE!" cmd.exe /C "!BATCH!" :Game.locres.yaml !LANGUAGE!
)

CALL :DIVIDER

"!${{ UE4Editor.project }}!\Holiday\Holiday.uproject"

PAUSE

CALL :DIVIDER

CALL :ANSI TIP: "!02_Create_Latest_Release.yml.bat!" !TargetLanguage!
!02_Create_Latest_Release.yml.bat! !TargetLanguage!

ENDLOCAL

GOTO :EOF

: ----------------------------------------------------- Subroutines -----------------------------------------------------

:ANSI
(
	:: Capture the virtual terminal Escape character
	IF [!ESC!]==[] (
		FOR /F %%A IN ('ECHO PROMPT $E^| CMD') DO SET "ESC=%%A"
	)
	REM ECHO [~1]==[%~1]
	SET MESSAGE=%*
	SET MESSAGE=!MESSAGE:%1 =!
	IF [%~1]==[CAUTION:] (
		REM ECHO !ESC![31mCAUTION!ESC![00m
		ECHO !ESC![31m!MESSAGE!!ESC![00m
		EXIT /b 0
	) ELSE IF [%~1]==[TIP:] (
		REM ECHO !ESC![32mTIP!ESC![00m
		ECHO !ESC![32m!MESSAGE!!ESC![00m
		EXIT /b 0
	) ELSE IF [%~1]==[WARNING:] (
		REM ECHO !ESC![33mWARNING!ESC![00m
		ECHO !ESC![33m!MESSAGE!!ESC![00m
		EXIT /b 0
	) ELSE IF [%~1]==[NOTE:] (
		REM ECHO !ESC![34mNOTE!ESC![00m
		ECHO !ESC![34m!MESSAGE!!ESC![00m
		EXIT /b 0
	) ELSE IF [%~1]==[IMPORTANT:] (
		REM ECHO !ESC![35mIMPORTANT!ESC![00m
		ECHO !ESC![35m!MESSAGE!!ESC![00m
		EXIT /b 0
	)
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

:Game.locres.yaml
(
	IF NOT EXIST "!${{ github.workspace }}!\JsonAsAsset\%~1" (
		mkdir "!${{ github.workspace }}!\JsonAsAsset\%~1"
	)
	CD /D "!${{ github.workspace }}!\JsonAsAsset\%~1\"
	: ---------------------------- Splitting Game.locres.yaml by !LANGUAGE! ----------------------------
	ECHO Splitting Game.locres.yaml by %~1
	yq eval ^
	"!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.yaml" ^
	-o json --yaml-fix-merge-anchor-to-spec ^
	| jq ^
	--arg LANGUAGE "%~1" ^
	--from-file "!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.jq" ^
	> "!${{ github.workspace }}!\JsonAsAsset\%~1\_%~1.json"
	: ---------------------------- Splitting _!LANGUAGE!.json by Namespaces ----------------------------
	ECHO Splitting _%~1.json by Namespaces
	ECHO yq ".[]" -s "key" "!${{ github.workspace }}!\JsonAsAsset\%~1\_%~1.json"
	yq ".[]" -s "key" "!${{ github.workspace }}!\JsonAsAsset\%~1\_%~1.json"
	DEL "!${{ github.workspace }}!\JsonAsAsset\%~1\_%~1.json"
	: ---------------------------- Formatting *.json for JsonAsAsset import ----------------------------
	ECHO Formatting *.json for JsonAsAsset import
	FOR /F "usebackq delims=" %%N IN (`dir "!${{ github.workspace }}!\JsonAsAsset\%~1\" /b /o:n`) DO (
		jq "[{ StringTable: { KeysToEntries: . } }]" ^
		"!${{ github.workspace }}!\JsonAsAsset\%~1\%%N" ^
		> "!${{ github.workspace }}!\JsonAsAsset\%~1\%%N.tmp"
		REM ECHO         MOVE "!${{ github.workspace }}!\JsonAsAsset\%~1\%%N.tmp" "!${{ github.workspace }}!\JsonAsAsset\%~1\%%N"
		MOVE "!${{ github.workspace }}!\JsonAsAsset\%~1\%%N.tmp" "!${{ github.workspace }}!\JsonAsAsset\%~1\%%N"
	)
	: ----------------- %~dp0StringTables\**\*.json to i18n\%%L\StringTables\**\*.json -----------------
	SETLOCAL EnableDelayedExpansion
	FOR %%L IN (%~1) DO (
		FOR /F "usebackq delims=" %%F IN (`dir "!${{ github.workspace }}!\dqx-offline-localization\src\UE4Editor\Holiday\KwK\StringTables\Game\" /b /a-d /o:n /s`) DO (
			SET FILENAME=%%~nF
				ECHO FILENAME =         !FILENAME!
			SET INPUT_NEW=!${{ github.workspace }}!\JsonAsAsset\%%L\!FILENAME!.json
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
				CALL :ANSI CAUTION: "jq exit-status = !ERRORLEVEL!"
			) ELSE (
				CALL :ANSI CAUTION: "jq exit-status = !ERRORLEVEL!"
			)
			CALL :DIVIDER
		)
		: ----------------------------- Copy *.json to FModel export locations -----------------------------
		ROBOCOPY ^
		"!${{ github.workspace }}!\dqx-offline-localization\src\UE4Editor\Holiday\Content\i18n\%%L\StringTables\GAME\\" ^
		"!${{ Fmodel.Output_Directory }}!\Exports\Holiday\Content\i18n\%%L\StringTables\GAME\\" ^
		/MT:32 /NDL /NFL /S /XF *.uasset /Z

		ROBOCOPY ^
		"!${{ Fmodel.Output_Directory }}!\Exports\Holiday\Content\i18n\%%L\StringTables\GAME\Battle\\" ^
		"!${{ Fmodel.Output_Directory }}!\Exports\Holiday\Content\i18n\%%L\DLC\Ver2\StringTables\Game\Battle\\" ^
		"STT_EventMonsterName_2nd.json" ^
		/MOV /MT:32 /NDL /NFL
	)
	ENDLOCAL
	ECHO:
	EXIT /B 0
)
