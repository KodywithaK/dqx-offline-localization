@ECHO OFF

REM path of the directory where you cloned the repository is located
SET "${{ github.repository }}=D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main"
REM path of the directory where your working directory is located
SET "${{ github.workspace }}=R:\DEBUG"
REM path of the directory where your UE4.27 project is located
SET "${{ UE4Editor.project }}=F:\Test"

SETLOCAL EnableDelayedExpansion

CALL :ANSI TIP: SET "${{ github.repository }}=!${{ github.repository }}!"
CALL :ANSI TIP: SET "${{ github.workspace }}=!${{ github.workspace }}!"
CALL :ANSI TIP: SET "${{ UE4Editor.project }}=!${{ UE4Editor.project }}!"

IF NOT EXIST "!${{ github.workspace }}!" (
	MKDIR "!${{ github.workspace }}!"
)

ECHO CD /D "!${{ github.workspace }}!" && CD /D "!${{ github.workspace }}!"

IF [%1]==[] (
	: --------------- WITHOUT ARGUMENT ---------------
	REM ECHO ~1 = %~1
) ELSE (
	: ---------------- WITH  ARGUMENT ----------------
	SET "ARGUMENT_1=%~1"
	SET "SUBROUTINE=!ARGUMENT_1:~0,1!"
	IF [!SUBROUTINE!]==[:] (
		ECHO CALL %*
		CALL %*
		PAUSE
		GOTO :EOF
	) ELSE (
		ECHO SET "TargetLanguage=%*"
		SET "TargetLanguage=%*"
		GOTO :START
	)
)
: ----------------------------------------------- Prompt for language(s) -----------------------------------------------
CALL :ANSI NOTE: "Which language(s) to output? If multiple, separate by spaces (de en es fr it pt-BR ja ko zh-Hans zh-Hant)"
SET /P TargetLanguage=""
:START
SET DATE=$(echo -e $(date -u +%%Y.%%m.%%d ))
CALL :DIVIDER
: --------------------------------------------------- Checkout_Repos ---------------------------------------------------
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
IF NOT EXIST "!${{ github.workspace }}!\LocRes-Builder\src" (
	CALL :ANSI TIP: "gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch"
	gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "!${{ github.workspace }}!\LocRes-Builder\INPUT" (
	mkdir "!${{ github.workspace }}!\LocRes-Builder\INPUT"
)

:: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy
REM xcopy /f /j /v /y "!${{ github.workspace }}!\dqx-offline-localization\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\locmetav2.json" "!${{ github.workspace }}!\LocRes-Builder\INPUT\locmeta.json*"
CALL :ANSI NOTE: "COPY "!${{ github.workspace }}!\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\locmeta.json" "!${{ github.workspace }}!\LocRes-Builder\INPUT\locmeta.json""
COPY "!${{ github.workspace }}!\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\locmeta.json" "!${{ github.workspace }}!\LocRes-Builder\INPUT\locmeta.json"
REM COPY "!${{ github.workspace }}!\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\locmeta.json" "!${{ github.workspace }}!\LocRes-Builder\INPUT\locmeta.json"

: ----------------------------------------- Game.locres.yaml > {LANGUAGE}.json -----------------------------------------
CD /D "!${{ github.workspace }}!\LocRes-Builder\INPUT\"
FOR %%L IN (de en es fr it ja ko la pt-BR zh-Hans zh-Hant) DO (
	@ECHO Splitting %%L
	yq "." ^
	"!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.yaml" ^
	-o json --yaml-fix-merge-anchor-to-spec ^
	| jq ^
	--arg LANGUAGE %%L ^
	--from-file "!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.jq" ^
	> "!${{ github.workspace }}!\LocRes-Builder\INPUT\%%L.json"
)

IF NOT EXIST "!${{ github.workspace }}!\LocRes-Builder\OUTPUT\" (
	mkdir "!${{ github.workspace }}!\LocRes-Builder\OUTPUT\Optimized_CRC32"
	mkdir "!${{ github.workspace }}!\LocRes-Builder\OUTPUT\Optimized_CityHash64_UTF16"
)

: --------------------- Parallel commands start, pauses main script while subcommand windows exist ---------------------
(
	START "Optimized_CRC32" cmd.exe /S /C " python "%${{ github.workspace }}%\LocRes-Builder\src\main.py" -i "%${{ github.workspace }}%\LocRes-Builder\INPUT\locmeta.json" -v 2 -o "%${{ github.workspace }}%\LocRes-Builder\OUTPUT\Optimized_CRC32" "
	START "Optimized_CityHash64_UTF16" cmd.exe /S /C " python "%${{ github.workspace }}%\LocRes-Builder\src\main.py" -i "%${{ github.workspace }}%\LocRes-Builder\INPUT\locmeta.json" -v 3 -o "%${{ github.workspace }}%\LocRes-Builder\OUTPUT\Optimized_CityHash64_UTF16" "
	START "YAML_to_ETP" cmd.exe /S /C " "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!    02_Create_Latest_Release.yml.bat" :YAML_to_ETP "
) | PAUSE

ECHO Parallel commands finished
CALL :DIVIDER

: -------------------------------------------------- UnrealPak_-Create --------------------------------------------------
:UnrealPak_-Create
FOR %%L IN (!TargetLanguage!) DO (
	FOR %%P IN (ps4 Switch WindowsNoEditor) DO (
		FOR %%V IN (Optimized_CRC32 Optimized_CityHash64_UTF16) DO (
			SET LANGUAGE=%%L
			SET PLATFORM=%%P
			SET LocResVersion=%%V
			: -------------------------------------------------- ps4 --------------------------------------------------
			IF %%P == ps4				(
				ECHO %%V
				SET DESTINATION=Holiday
				REM ECHO %%P
				IF %%V == Optimized_CRC32 (
					CALL :responseFile ja
					REM CALL :RunUAT ja
				) ELSE (
					CALL :responseFile ko zh-Hans zh-Hant
					REM CALL :RunUAT ASIA
				)
			)
			: -------------------------------------------------- Switch --------------------------------------------------
			IF %%P == Switch			(
				REM ECHO %%P
				IF %%V == Optimized_CRC32 (
					ECHO %%V
					SET DESTINATION=Holiday
					CALL :responseFile ja
					REM 2026.06.06 - Exclude "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\Localization\\" and "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\NonAssets\\"
					REM CALL :RunUAT ja
					CALL :RunUAT__TEST ja
					REM 2026.06.06 - Exclude "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\Localization\\" and "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\NonAssets\\"

					: -------------------------------------------------------- DEMO --------------------------------------------------------
					: ----------------------------------- Citron -----------------------------------
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					: ------------------------------------ Eden ------------------------------------
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"

					: -------------------------------------------------------- PAID --------------------------------------------------------
					: ----------------------------------- Citron -----------------------------------
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					: ------------------------------------ Eden ------------------------------------
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "!${{ github.workspace }}!\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
				) ELSE (
					REM CALL :responseFile ko zh-Hans zh-Hant
					REM CALL :RunUAT ko zh-Hans zh-Hant
				)
			)
			: -------------------------------------------------- WindowsNoEditor --------------------------------------------------
			IF %%P == WindowsNoEditor	(
				ECHO %%V
				SET DESTINATION=Game
				REM ECHO %%P
				IF %%V == Optimized_CRC32 (
					CALL :responseFile ja
					REM CALL :RunUAT ja
					: --------------------------------- copy Switch_*__RunUAT_P to ps4 ---------------------------------
					copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "!${{ github.workspace }}!\releases\pakchunk0-ps4_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
					copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "!${{ github.workspace }}!\releases\pakchunk0-ps4_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
					copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "!${{ github.workspace }}!\releases\pakchunk0-ps4_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
					: --------------------------- copy Switch_*__RunUAT_P to WindowsNoEditor ---------------------------
					copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
					copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
					copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"

					copy "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak.!LANGUAGE!"
					copy "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas.!LANGUAGE!"
					copy "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc.!LANGUAGE!"
					copy "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak.!LANGUAGE!"
					IF EXIST "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" (
						MOVE /Y "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak.!LANGUAGE!" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
					)
					IF EXIST "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" (
						MOVE /Y "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas.!LANGUAGE!" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
					)
					IF EXIST "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" (
						MOVE /Y "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc.!LANGUAGE!" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
					)
					IF EXIST "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" (
						MOVE /Y "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak.!LANGUAGE!" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak"
					)
				) ELSE (
					CALL :responseFile ko zh-Hans zh-Hant
					REM CALL :RunUAT ko zh-Hans zh-Hant
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak.!LANGUAGE!"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas.!LANGUAGE!"
					REM copy "!${{ github.workspace }}!\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc.!LANGUAGE!"
					copy "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest_P.pak" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest_P.pak.!LANGUAGE!"
				)
			)
		)
		: -------------------------------------------------- END --------------------------------------------------
		CALL :DIVIDER
	)
)

REM explorer.exe "L:\home\shr002\actions-runner\_work\dqx-offline-localization\dqx-offline-localization\BUILD\releases"
explorer.exe "!${{ github.workspace }}!\releases"
: ----------- Creating pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest_P.pak.zip ----------
ECHO wsl -e "/mnt/c/Users/Ryzen3/Desktop/pakchunk0-{PLATFORM}_LocResBuilder_P.pak/^!    03_zip-uj.sh"
wsl -e "/mnt/c/Users/Ryzen3/Desktop/pakchunk0-{PLATFORM}_LocResBuilder_P.pak/^!    03_zip-uj.sh"

ENDLOCAL

PAUSE

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

:CUE4Parse.CLI
(
	REM CALL :CUE4Parse.CLI
	REM https://github.com/joric/CUE4Parse.CLI
	IF NOT EXIST "!${{ github.workspace }}!\CUE4Parse.CLI\" (
		mkdir "!${{ github.workspace }}!\CUE4Parse.CLI"
		REM curl -LO --output-dir "!${{ github.workspace }}!\CUE4Parse.CLI\" https://github.com/joric/CUE4Parse.CLI/releases/tag/cli-0.1.3
		copy "T:\Downloads\CUE4Parse.CLI-0.1.3-Win64-bin.zip" "!${{ github.workspace }}!\CUE4Parse.CLI\CUE4Parse.CLI-0.1.3-Win64-bin.zip"
		tar -C "!${{ github.workspace }}!\CUE4Parse.CLI" -xf "!${{ github.workspace }}!\CUE4Parse.CLI\CUE4Parse.CLI-0.1.3-Win64-bin.zip"
	)
	: --------------------------------- Holiday/Content/StringTables/**/*.uasset to .json  ---------------------------------
	"!${{ github.workspace }}!\CUE4Parse.CLI\cue4parse.exe"
	FOR %%N IN (2060401 2060402) DO (
		"!${{ github.workspace }}!\CUE4Parse.CLI\cue4parse.exe" ^
		--format json ^
		--game GAME_UE4_26 ^
		--input "S:\Steam\game_backups\steamapps\common\DRAGON QUEST X OFFLINE Demo\.DepotDownloader\%%N\Game" ^
		--key 0x8B51D59ED5C495E1ECF7E2960F218F4868A31CEF3DBC5248F70CADCF809D1193 ^
		--mappings "S:\Consoles\Valve Steam\tools\DUMPs\DRAGON QUEST X OFFLINE\Steam--App_ID-1358750--Build_ID-14529657.usmap" ^
		--output "!${{ github.workspace }}!\CUE4Parse.CLI" ^
		--package "Game/Content/StringTables/*"
		ECHO:
	)
	del "!${{ github.workspace }}!\CUE4Parse.CLI\Game\Content\StringTables\Game\Battle\PAL_BattleMessage.json"
	REM robocopy "!${{ github.workspace }}!\CUE4Parse.CLI\Game\Content\StringTables\\" "%~dp0StringTables\\" /S /Z
	: ----------------------------- Game.locres.yaml to Holiday/Content/StringTables/**/*.json  -----------------------------
	CALL :DIVIDER
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

:responseFile
(
	: ----------------------------------------------- create responseFile.txt -----------------------------------------------
	REM wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "!${{ github.workspace }}!\staging\version_settings.json"
	REM ECHO "!${{ github.workspace }}!\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "!${{ github.workspace }}!\staging\responseFile.txt"
	IF NOT EXIST "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Settings\Version\" (
		mkdir "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Settings\Version\"
	)
	wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Settings\Version\version_settings.json"
	ECHO "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Settings\Version\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "!${{ github.workspace }}!\staging\responseFile.txt"
	FOR %%A IN (%*) DO (
		IF NOT EXIST "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\" (
			mkdir "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\"
		)
		copy "!${{ github.workspace }}!\LocRes-Builder\OUTPUT\!LocResVersion!\Game\!LANGUAGE!\Game.locres" "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!"
		: -------------------------------------------------- ja fail-safe --------------------------------------------------
		copy "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!" "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres"
		ECHO "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres" "../../../!DESTINATION!/Content/Localization/Game/%%A/Game.locres" >> "!${{ github.workspace }}!\staging\responseFile.txt"
		IF "%*"=="ja" (
			SET ETP="ETP"
			SET REGION="JAPAN"
		)
		IF "%*"=="ko zh-Hans zh-Hant" (
			SET ETP=%%A
			SET ETP="ETP_!ETP:-=_!"
			SET REGION="ASIA"
			IF NOT EXIST "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\" (
				mkdir "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\"
			)
			copy "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\NonAssets\ETP\" "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\"
		)
		SET ETP=!ETP:"=!
		ECHO "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\*" "../../../!DESTINATION!/Content/NonAssets/!ETP!/" >> "!${{ github.workspace }}!\staging\responseFile.txt"
	)
	CALL :UnrealPak_Create !REGION:"=!
	ECHO:
	EXIT /B 0
)

:UnrealPak_Create
(
	"%UE_5.1%\UnrealPak.exe" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_%1_!LANGUAGE!_Dialogue_Latest_P.pak" -Create="!${{ github.workspace }}!\staging\responseFile.txt"
	REM "%UE_5.1%\UnrealPak.exe" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_%1_!LANGUAGE!_Dialogue_Latest_P.pak" -List
	MOVE "!${{ github.workspace }}!\staging\responseFile.txt" "!${{ github.workspace }}!\staging\!LANGUAGE!\responseFile.%1.txt"
	ECHO:
	EXIT /B 0
)

:RunUAT__TEST
(
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\DLC\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\NonAssets\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Settings\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\StringTables\*
	: ----------------------------------------------- Copy files to UE4Editor -----------------------------------------------
	CALL :ANSI IMPORTANT: "ROBOCOPY '!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\i18n\\!LANGUAGE!\\\\\\' '!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\\\\\' /MT:32 /NFL /NDL /S /XD '!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\i18n\\!LANGUAGE!\\Localization\\\\\\' '!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\i18n\\!LANGUAGE!\\NonAssets\\\\\\' /Z"

	ROBOCOPY "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\\" "!${{ UE4Editor.project }}!\Holiday\Content\\" /MT:32 /NFL /NDL /S /XD ^
	"!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\Localization\\" ^
	"!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\NonAssets\\" ^
	/Z

	CALL :DIVIDER
	: ----------------------------------------------------- SET REGION -----------------------------------------------------
	IF "%*"=="ja" (
		SET REGION=JAPAN
	)
	IF "%*"=="ko zh-Hans zh-Hant" (
		SET REGION=ASIA
	)
	CALL :ANSI TIP: "REGION = !REGION!"
	: ------------------------------------------------ Build RunUAT outputs ------------------------------------------------
	CALL :ANSI NOTE: "Build RunUAT outputs"
	"%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="!${{ github.workspace }}:\=/!/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=!${{ UE4Editor.project }}:\=/!/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	REM "%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="!${{ github.workspace }}:\=/!/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=R:/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	: ----------------------------------------- Move RunUAT outputs to \releases\* -----------------------------------------
	CALL :ANSI NOTE: "Move RunUAT outputs to releases"
	MOVE "!${{ github.workspace }}!\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.pak"  "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
	MOVE "!${{ github.workspace }}!\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.ucas" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
	MOVE "!${{ github.workspace }}!\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.utoc" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
	CALL :DIVIDER
)

:RunUAT
(
	: ----------------------------------------------- Copy files to UE4Editor -----------------------------------------------
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\NonAssets\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Settings\*
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\StringTables\*
	CALL :ANSI IMPORTANT: "ROBOCOPY "!${{ github.workspace }}:\=\\!\\staging\\!LANGUAGE!\\Game\\Content\\\\" "!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\i18n\\!LANGUAGE!\\\\" /MT:32 /NFL /NDL /S /XF *.etp /Z"
	ROBOCOPY "!${{ github.workspace }}!\staging\!LANGUAGE!\Game\Content\\" "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\\" /MT:32 /NFL /NDL /S /XF *.etp /Z
	CALL :DIVIDER
	REM xcopy /f /j /s /v /y "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\*" "!${{ UE4Editor.project }}!\Holiday\Content\"
	CALL :ANSI IMPORTANT: "ROBOCOPY "!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\i18n\\!LANGUAGE!\\\\" "!${{ UE4Editor.project }}:\=\\!\\Holiday\\Content\\\\" /MT:32 /NFL /NDL /S /XF *.etp /Z"
	ROBOCOPY "!${{ UE4Editor.project }}!\Holiday\Content\i18n\!LANGUAGE!\\" "!${{ UE4Editor.project }}!\Holiday\Content\\" /MT:32 /NFL /NDL /S /Z
	CALL :DIVIDER
	IF "%*"=="ja" (
		SET REGION=JAPAN
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\Game\ko\Game.locres
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\Game\zh-Hans\Game.locres
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\Game\zh-Hant\Game.locres
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\NonAssets\ETP_ko\*
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\NonAssets\ETP_zh_Hans\*
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\NonAssets\ETP_zh_Hant\*
	)
	IF "%*"=="ko zh-Hans zh-Hant" (
		SET REGION=ASIA
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\Game\ja\Game.locres
		del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\NonAssets\ETP\*
		REM del /Q /S R:\Holiday\Content\Localization\Game\ja\Game.locres
		REM del /Q /S R:\Holiday\Content\NonAssets\ETP\*
	)
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\Game\Game.locres.Optimized_CityHash64_UTF16
	del /Q /S !${{ UE4Editor.project }}!\Holiday\Content\Localization\Game\Game.locres.Optimized_CRC32
	: ---------------------------------------------------------- Build RunUAT outputs ----------------------------------------------------------
	"%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="!${{ github.workspace }}:\=/!/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=!${{ UE4Editor.project }}:\=/!/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	REM "%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="!${{ github.workspace }}:\=/!/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=R:/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	: --------------------------------------------------- Move RunUAT outputs to \releases\* ---------------------------------------------------
	MOVE "!${{ github.workspace }}!\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.pak" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
	MOVE "!${{ github.workspace }}!\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.ucas" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
	MOVE "!${{ github.workspace }}!\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.utoc" "!${{ github.workspace }}!\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
)

:YAML_to_ETP
(
	REM START "YAML_to_ETP" cmd.exe /S /C " "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!    pakchunk0-WindowsNoEditor_LocResBuilder_P.pak.20260306.bat" :YAML_to_ETP "
	: ------------------------------------ Split ETP.yaml 2026.05.08 ------------------------------------
	ECHO CD /D "!${{ github.workspace }}!\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP"
	CD /D "!${{ github.workspace }}!\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP"
	ECHO Splitting ETP.yaml
	yq eval ^
	"!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP\ETP.yaml" ^
	-o json --yaml-fix-merge-anchor-to-spec ^
	| jq ^
	--from-file "!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP\ETP.jq" ^
	| yq ".[]" --split-exp-file ^
	"!${{ github.repository }}!\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP\ETP.yq" ^
	-o json
	del "./anchors.json"
	: ------------------------------------ dqx_dat_dump ( no cache ) ------------------------------------
	ECHO dqx_dat_dump ( no cache ^)
	CD /D "!${{ github.workspace }}!\dqx_dat_dump"
	python -m venv venv
	REM "\venv\bin\activate"
	venv\Scripts\activate
	pip install -r requirements.txt
	CD /D "./tools/packing/"
	FOR %%L IN (de en es fr it ja ko pt-BR zh-Hans zh-Hant) DO (
		python pack_etp--KwK_20260306.py -L %%L
	)
	deactivate
	EXIT /B 0
)
