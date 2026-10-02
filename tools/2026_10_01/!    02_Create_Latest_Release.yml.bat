@ECHO OFF

SETLOCAL EnableDelayedExpansion

R:
IF NOT EXIST "R:\DEBUG" (
	MKDIR "R:\DEBUG"
)
CD "R:\DEBUG"

IF [%1]==[] (
	: ---------------------------------------- WITHOUT ARGUMENT ----------------------------------------
	REM ECHO ~1 = %~1
) ELSE IF [%1]==[:UnrealPak_-Create] (
	ECHO ELSE IF [%1]==[:UnrealPak_-Create]
	ECHO 0 = %0
	ECHO 1 = %1
	ECHO 2 = %2
	ECHO * = %*
	PAUSE
	SET "TargetLanguage=%~2"
	SET "DATE=$(echo -e $(date -u +%%Y.%%m.%%d ))"
	GOTO :UnrealPak_-Create
) ELSE (
	: ----------------------------------------- WITH ARGUMENT -----------------------------------------
	REM ECHO %%0 = %0
	REM ECHO %%~1 = %~1
	CALL %~1 %~2
	PAUSE
	GOTO :EOF
)

: ----------------------------------------------- Prompt for language(s) -----------------------------------------------
CALL :NOTE Which language\(s\) to output? If multiple, separate by spaces \(de en es fr it pt-BR ja ko zh-Hans zh-Hant\)
SET /P TargetLanguage=""
SET DATE=$(echo -e $(date -u +%%Y.%%m.%%d ))

REM GOTO :UnrealPak_-Create

CALL :DIVIDER

: -------------------------------------------------------------- Checkout_Repos --------------------------------------------------------------
IF NOT EXIST "R:\DEBUG\dqx_dat_dump" (
	gh repo clone KodywithaK/dqx_dat_dump -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\dqx-offline-localization" (
	gh repo clone KodywithaK/dqx-offline-localization -- --branch main --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\LocRes-Builder\src" (
	gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch
	CALL :DIVIDER
)
IF NOT EXIST "R:\DEBUG\LocRes-Builder\INPUT" (
	mkdir "R:\DEBUG\LocRes-Builder\INPUT"
)

:: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy
REM xcopy /f /j /v /y "R:\DEBUG\dqx-offline-localization\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\locmetav2.json" "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json*"
ECHO copy "R:\DEBUG\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\locmeta.json" "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json"
copy "R:\DEBUG\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\locmeta.json" "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json"
REM copy "R:\DEBUG\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\locmeta.json" "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json"

: -------------------------------------------------- Game.locres.yaml > {LANGUAGE}.json --------------------------------------------------
cd "R:\DEBUG\LocRes-Builder\INPUT\"
FOR %%L IN (de en es fr it ja ko la pt-BR zh-Hans zh-Hant) DO (
	@ECHO Splitting %%L
	yq "." ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.yaml" ^
	-o json --yaml-fix-merge-anchor-to-spec ^
	| jq --arg LANGUAGE %%L ^
	--from-file "R:\DEBUG\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game\Game.locres.jq" ^
	> "R:\DEBUG\LocRes-Builder\INPUT\%%L.json"
)

IF NOT EXIST "R:\DEBUG\LocRes-Builder\OUTPUT\" (
	mkdir "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CRC32"
	mkdir "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CityHash64_UTF16"
)

: ------------------------------- Parallel commands start, pauses main script while subcommand windows exist -------------------------------
REM START "YAML_to_ETP" cmd.exe /C "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\YAML_to_ETP.bat"
REM START "YAML_to_ETP" cmd.exe /S /C " "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!    pakchunk0-WindowsNoEditor_LocResBuilder_P.pak.20260306.bat" :YAML_to_ETP "
(
	START "Optimized_CRC32" cmd.exe /S /C " python "R:\DEBUG\LocRes-Builder\src\main.py" -i "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json" -v 2 -o "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CRC32" "
	START "Optimized_CityHash64_UTF16" cmd.exe /S /C " python "R:\DEBUG\LocRes-Builder\src\main.py" -i "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json" -v 3 -o "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CityHash64_UTF16" "
	START "YAML_to_ETP" cmd.exe /S /C " "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!    02_Create_Latest_Release.yml.bat" :YAML_to_ETP "
) | PAUSE

ECHO Parallel commands finished
CALL :DIVIDER

: ------------------------------------------------------------ UnrealPak_-Create ------------------------------------------------------------
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
					REM 2026.06.06 - Exclude "F:\Test\Holiday\Content\i18n\!LANGUAGE!\Localization\\" and "F:\Test\Holiday\Content\i18n\!LANGUAGE!\NonAssets\\"
					REM CALL :RunUAT ja
					CALL :RunUAT__TEST ja
					REM 2026.06.06 - Exclude "F:\Test\Holiday\Content\i18n\!LANGUAGE!\Localization\\" and "F:\Test\Holiday\Content\i18n\!LANGUAGE!\NonAssets\\"

					: -------------------------------------------------------- DEMO --------------------------------------------------------
					: ----------------------------------- Citron -----------------------------------
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					: ------------------------------------ Eden ------------------------------------
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "%AppData%\eden\load\01006AA015502000\!LANGUAGE!\romfs\Holiday\Content\Paks\"

					: -------------------------------------------------------- PAID --------------------------------------------------------
					: ----------------------------------- Citron -----------------------------------
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					: ------------------------------------ Eden ------------------------------------
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "%AppData%\eden\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
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
					copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "R:\DEBUG\releases\pakchunk0-ps4_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
					copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "R:\DEBUG\releases\pakchunk0-ps4_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
					copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "R:\DEBUG\releases\pakchunk0-ps4_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
					: --------------------------- copy Switch_*__RunUAT_P to WindowsNoEditor ---------------------------
					copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
					copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
					copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"

					copy "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak.!LANGUAGE!"
					copy "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas.!LANGUAGE!"
					copy "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc.!LANGUAGE!"
					copy "R:\DEBUG\releases\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "F:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak.!LANGUAGE!"
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
					REM copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak.!LANGUAGE!"
					REM copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas.!LANGUAGE!"
					REM copy "R:\DEBUG\releases\pakchunk0-Switch_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc.!LANGUAGE!"
					copy "R:\DEBUG\releases\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest_P.pak" "W:\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\~mods\!LANGUAGE!\pakchunk0-!PLATFORM!_ASIA_!LANGUAGE!_Dialogue_Latest_P.pak.!LANGUAGE!"
				)
			)
		)
		: -------------------------------------------------- END --------------------------------------------------
		CALL :DIVIDER
	)
)

REM explorer.exe "L:\home\shr002\actions-runner\_work\dqx-offline-localization\dqx-offline-localization\BUILD\releases"
explorer.exe "R:\DEBUG\releases"
: ----------- Creating pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest_P.pak.zip ----------
ECHO wsl -e "/mnt/c/Users/Ryzen3/Desktop/pakchunk0-{PLATFORM}_LocResBuilder_P.pak/^!    03_zip-uj.sh"
wsl -e "/mnt/c/Users/Ryzen3/Desktop/pakchunk0-{PLATFORM}_LocResBuilder_P.pak/^!    03_zip-uj.sh"

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
	REM robocopy "R:\DEBUG\CUE4Parse.CLI\Game\Content\StringTables\\" "%~dp0StringTables\\" /S /Z
	: --------------------------------------- Game.locres.yaml to Holiday/Content/StringTables/**/*.json  ---------------------------------------
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

:responseFile
(
	: -------------------------------------------------- create responseFile.txt --------------------------------------------------
	REM wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\version_settings.json"
	REM ECHO "R:\DEBUG\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
	IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Settings\Version\" (
		mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Settings\Version\"
	)
	wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Settings\Version\version_settings.json"
	ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Settings\Version\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
	FOR %%A IN (%*) DO (
		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\" (
			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\"
		)
		copy "R:\DEBUG\LocRes-Builder\OUTPUT\!LocResVersion!\Game\!LANGUAGE!\Game.locres" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!"
		: -------------------------------------------------- ja fail-safe --------------------------------------------------
		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres"
		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres" "../../../!DESTINATION!/Content/Localization/Game/%%A/Game.locres" >> "R:\DEBUG\staging\responseFile.txt"
		IF "%*"=="ja" (
			REM ECHO JAPAN
			REM ECHO A = %%A
			SET ETP="ETP"
			SET REGION="JAPAN"
		)
		IF "%*"=="ko zh-Hans zh-Hant" (
			REM ECHO ASIA
			REM ECHO A = %%A
			SET ETP=%%A
			SET ETP="ETP_!ETP:-=_!"
			SET REGION="ASIA"
			IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\" (
				mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\"
			)
			copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP\" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\"
		)
		SET ETP=!ETP:"=!
		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\!ETP!\*" "../../../!DESTINATION!/Content/NonAssets/!ETP!/" >> "R:\DEBUG\staging\responseFile.txt"
	)
	CALL :UnrealPak_Create !REGION:"=!
	ECHO:
	EXIT /B 0
)

:UnrealPak_Create
(
	"%UE_5.1%\UnrealPak.exe" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_%1_!LANGUAGE!_Dialogue_Latest_P.pak" -Create="R:\DEBUG\staging\responseFile.txt"
	REM "%UE_5.1%\UnrealPak.exe" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_%1_!LANGUAGE!_Dialogue_Latest_P.pak" -List
	MOVE "R:\DEBUG\staging\responseFile.txt" "R:\DEBUG\staging\!LANGUAGE!\responseFile.%1.txt"
	ECHO:
	EXIT /B 0
)

:RunUAT__TEST
(
	del /Q /S F:\Test\Holiday\Content\DLC\*
	del /Q /S F:\Test\Holiday\Content\Localization\*
	del /Q /S F:\Test\Holiday\Content\NonAssets\*
	del /Q /S F:\Test\Holiday\Content\Settings\*
	del /Q /S F:\Test\Holiday\Content\StringTables\*
	: ----------------------------------------------- Copy files to UE4Editor -----------------------------------------------
	CALL :IMPORTANT ROBOCOPY 'F:\\Test\\Holiday\\Content\\i18n\\!LANGUAGE!\\\\\\' 'F:\\Test\\Holiday\\Content\\\\\\' /S /XD ^
	'F:\\Test\\Holiday\\Content\\i18n\\!LANGUAGE!\\Localization\\\\\\' ^
	'F:\\Test\\Holiday\\Content\\i18n\\!LANGUAGE!\\NonAssets\\\\\\' ^
	/Z

	ROBOCOPY "F:\Test\Holiday\Content\i18n\!LANGUAGE!\\" "F:\Test\Holiday\Content\\" /S /XD ^
	"F:\Test\Holiday\Content\i18n\!LANGUAGE!\Localization\\" ^
	"F:\Test\Holiday\Content\i18n\!LANGUAGE!\NonAssets\\" ^
	/Z

	CALL :DIVIDER
	: ----------------------------------------------------- SET REGION -----------------------------------------------------
	IF "%*"=="ja" (
		SET REGION=JAPAN
		CALL :TIP REGION = !REGION!
	)
	IF "%*"=="ko zh-Hans zh-Hant" (
		SET REGION=ASIA
		CALL :TIP REGION = !REGION!
	)
	: ------------------------------------------------ Build RunUAT outputs ------------------------------------------------
	CALL :NOTE Build RunUAT outputs
	"%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=F:/Test/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	REM "%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=R:/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	: ----------------------------------------- Move RunUAT outputs to \releases\* -----------------------------------------
	CALL :NOTE Move RunUAT outputs to releases
	MOVE "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.pak"  "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
	MOVE "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.ucas" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
	MOVE "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.utoc" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
	CALL :DIVIDER
)

:RunUAT
(
	: --------------------------------------------------------- Copy files to UE4Editor ---------------------------------------------------------
	del /Q /S F:\Test\Holiday\Content\Localization\*
	del /Q /S F:\Test\Holiday\Content\NonAssets\*
	del /Q /S F:\Test\Holiday\Content\Settings\*
	del /Q /S F:\Test\Holiday\Content\StringTables\*
	REM del /Q /S R:\Holiday\Content\Localization\*
	REM del /Q /S R:\Holiday\Content\NonAssets\*
	REM del /Q /S R:\Holiday\Content\Settings\*
	REM del /Q /S R:\Holiday\Content\StringTables\*
	REM 2026.06.05 - ROBOCOPY "R:\DEBUG\staging\!LANGUAGE!\Game\Content\\" "F:\Test\Holiday\Content\i18n\!LANGUAGE!\\" /S /XF *.etp /Z
	REM xcopy /f /j /s /v /y "R:\DEBUG\staging\!LANGUAGE!\Game\Content\*" "F:\Test\Holiday\Content\i18n\!LANGUAGE!\"
	CALL :IMPORTANT ROBOCOPY "R:\\DEBUG\\staging\\!LANGUAGE!\\Game\\Content\\\\" "F:\\Test\\Holiday\\Content\\i18n\\!LANGUAGE!\\\\" /S /XF *.etp /Z
	ROBOCOPY "R:\DEBUG\staging\!LANGUAGE!\Game\Content\\" "F:\Test\Holiday\Content\i18n\!LANGUAGE!\\" /S /XF *.etp /Z
	CALL :DIVIDER
	REM xcopy /f /j /s /v /y "F:\Test\Holiday\Content\i18n\!LANGUAGE!\*" "F:\Test\Holiday\Content\"
	CALL :IMPORTANT ROBOCOPY "F:\\Test\\Holiday\\Content\\i18n\\!LANGUAGE!\\\\" "F:\\Test\\Holiday\\Content\\\\" /S /XF *.etp /Z
	ROBOCOPY "F:\Test\Holiday\Content\i18n\!LANGUAGE!\\" "F:\Test\Holiday\Content\\" /S /Z
	CALL :DIVIDER
	REM 2026.06.05 - ROBOCOPY "R:\DEBUG\staging\!LANGUAGE!\Game\Content\\" "F:\Test\Holiday\Content\i18n\!LANGUAGE!\\" /S /XF *.etp /Z
	REM xcopy /f /j /s /v /y "R:\DEBUG\staging\!LANGUAGE!\Game\Content\*" "R:\Holiday\Content\i18n\!LANGUAGE!\"
	REM xcopy /f /j /s /v /y "R:\Holiday\Content\i18n\!LANGUAGE!\*" "R:\Holiday\Content\"
	IF "%*"=="ja" (
		SET REGION=JAPAN
		del /Q /S F:\Test\Holiday\Content\Localization\Game\ko\Game.locres
		del /Q /S F:\Test\Holiday\Content\Localization\Game\zh-Hans\Game.locres
		del /Q /S F:\Test\Holiday\Content\Localization\Game\zh-Hant\Game.locres
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP_ko\*
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP_zh_Hans\*
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP_zh_Hant\*
		REM del /Q /S R:\Holiday\Content\Localization\Game\ko\Game.locres
		REM del /Q /S R:\Holiday\Content\Localization\Game\zh-Hans\Game.locres
		REM del /Q /S R:\Holiday\Content\Localization\Game\zh-Hant\Game.locres
		REM del /Q /S R:\Holiday\Content\NonAssets\ETP_ko\*
		REM del /Q /S R:\Holiday\Content\NonAssets\ETP_zh_Hans\*
		REM del /Q /S R:\Holiday\Content\NonAssets\ETP_zh_Hant\*
		: --------------------------------------------------------------- Bad files ---------------------------------------------------------------
		REM BATTLE {0} being rendered literally, empty variable
		REM del /Q /S F:\Test\Holiday\Content\StringTables\Game\Battle\STT_BattleAbiMsg.uasset
		REM  BATTLE overwrites STT_ActionMsg_Simple3's "takes damage" with "miss! No damage taken"
		REM del /Q /S F:\Test\Holiday\Content\StringTables\Game\Battle\ActionMsg\Simple\STT_ActionMsg_Simple5.uasset
		REM del /Q /S F:\Test\Holiday\Content\StringTables\Game\Battle\STT_BattleSysMsg_LOG.uasset
	)
	IF "%*"=="ko zh-Hans zh-Hant" (
		SET REGION=ASIA
		del /Q /S F:\Test\Holiday\Content\Localization\Game\ja\Game.locres
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP\*
		REM del /Q /S R:\Holiday\Content\Localization\Game\ja\Game.locres
		REM del /Q /S R:\Holiday\Content\NonAssets\ETP\*
	)
	del /Q /S F:\Test\Holiday\Content\Localization\Game\Game.locres.Optimized_CityHash64_UTF16
	del /Q /S F:\Test\Holiday\Content\Localization\Game\Game.locres.Optimized_CRC32
	: ---------------------------------------------------------- Build RunUAT outputs ----------------------------------------------------------
	"%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=F:/Test/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	REM "%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=R:/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	: --------------------------------------------------- Move RunUAT outputs to \releases\* ---------------------------------------------------
	MOVE "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.pak" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
	MOVE "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.ucas" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
	MOVE "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.utoc" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
)

:YAML_to_ETP
(
	REM START "YAML_to_ETP" cmd.exe /S /C " "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!    pakchunk0-WindowsNoEditor_LocResBuilder_P.pak.20260306.bat" :YAML_to_ETP "
	R:
	: ------------------------------------ Split ETP.yaml 2026.05.08 ------------------------------------
	cd "R:\DEBUG\dqx-offline-localization\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP"
	ECHO Splitting ETP.yaml
	yq eval ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP\ETP.yaml" ^
	-o json --yaml-fix-merge-anchor-to-spec ^
	| jq --from-file ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP\ETP.jq" ^
	| yq ".[]" --split-exp-file ^
	"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP\ETP.yq" ^
	-o json
	del "./anchors.json"
	: ------------------------------------ dqx_dat_dump ( no cache ) ------------------------------------
	ECHO dqx_dat_dump ( no cache ^)
	cd "R:\DEBUG\dqx_dat_dump"
	python -m venv venv
	REM "\venv\bin\activate"
	venv\Scripts\activate
	pip install -r requirements.txt
	cd "./tools/packing/"
	FOR %%L IN (de en es fr it ja ko pt-BR zh-Hans zh-Hant) DO (
		python pack_etp--KwK_20260306.py -L %%L
	)
	deactivate
	EXIT /B 0
)

: ------------------------------------------------------ OUTDATED ------------------------------------------------------

REM :responseFile__ASIA
REM (
REM 	: -------------------------------------------------- create responseFile.txt --------------------------------------------------
REM 	wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\version_settings.json"
REM 	ECHO "R:\DEBUG\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
REM 	IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\" (
REM 		mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\"
REM 	)
REM 	copy "R:\DEBUG\LocRes-Builder\OUTPUT\!LocResVersion!\Game\!LANGUAGE!\Game.locres" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!"
REM 	FOR %%A IN (ko zh-Hans zh-Hant) DO (
REM 		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\" (
REM 			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\"
REM 		)
REM 		: ---------------------------------------- ko + zh-Hans + zh-Hant fail-safes ----------------------------------------
REM 		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres"
REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres" "../../../!DESTINATION!/Content/Localization/Game/%%A/Game.locres" >> "R:\DEBUG\staging\responseFile.txt"
REM 		SET ETP=%%A
REM 		SET newETP=!ETP:-=_!
REM 		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\" (
REM 			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\"
REM 		)
REM 		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP\" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\"
REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\*" "../../../!DESTINATION!/Content/NonAssets/ETP_!newETP!/" >> "R:\DEBUG\staging\responseFile.txt"
REM 	)
REM 	ECHO:
REM 	EXIT /B 0
REM )

REM :responseFile__JAPAN
REM (
REM 	: -------------------------------------------------- create responseFile.txt --------------------------------------------------
REM 	wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\version_settings.json"
REM 	ECHO "R:\DEBUG\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
REM 	FOR %%A IN (ja) DO (
REM 		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\" (
REM 			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\"
REM 		)
REM 		copy "R:\DEBUG\LocRes-Builder\OUTPUT\!LocResVersion!\Game\!LANGUAGE!\Game.locres" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!"
REM 		: -------------------------------------------------- ja fail-safe --------------------------------------------------
REM 		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres"
REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres" "../../../!DESTINATION!/Content/Localization/Game/%%A/Game.locres" >> "R:\DEBUG\staging\responseFile.txt"
REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP\*" "../../../!DESTINATION!/Content/NonAssets/ETP/" >> "R:\DEBUG\staging\responseFile.txt"
REM 	)
REM 	ECHO:
REM 	EXIT /B 0
REM )
