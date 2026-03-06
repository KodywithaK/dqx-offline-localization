@ECHO OFF

R:
IF NOT EXIST "R:\DEBUG\" (
    mkdir "R:\DEBUG\"
)
cd "R:\DEBUG\"

SETLOCAL EnableDelayedexpansion

(SET \n=^

)

: --------------------------------------------------- Prompt user for preferred language(s) ---------------------------------------------------
@REM SET /P LANGUAGE="!\n!Which language to output? (de, en, es, fr, it, ja, ko, pt-BR, zh-Hans, zh-Hant, ALL)!\n!"
SET /P TargetLanguage="!\n!Which language(s) to output? If multiple, separate by spaces (de en es fr it pt-BR ALL ja ko zh-Hans zh-Hant)!\n!"

CALL :Divider

SET DATE=$(echo -e $(date -u +%%Y.%%m.%%d ))

: -------------------------------------------------------------- Checkout_Repos --------------------------------------------------------------
IF NOT EXIST "R:\DEBUG\dqx_dat_dump" (
    gh repo clone KodywithaK/dqx_dat_dump -- --branch testing --single-branch
	ECHO:
)
IF NOT EXIST "R:\DEBUG\dqx-offline-localization" (
    gh repo clone KodywithaK/dqx-offline-localization -- --branch main --single-branch
	ECHO:
)
IF NOT EXIST "R:\DEBUG\LocRes-Builder" (
    gh repo clone KodywithaK/LocRes-Builder -- --branch testing --single-branch
	ECHO:
)
IF NOT EXIST "R:\DEBUG\LocRes-Builder\INPUT\" (
    mkdir "R:\DEBUG\LocRes-Builder\INPUT"
)

CALL :Divider

:: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy
xcopy /f /j /v /y "R:\DEBUG\dqx-offline-localization\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\locmetav2.json" "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json*"

: -------------------------------------------------- Game.locres.yaml > {LANGUAGE}.json --------------------------------------------------
cd "R:\DEBUG\LocRes-Builder\INPUT\"
FOR %%L IN (de en es fr it ja ko la pt-BR zh-Hans zh-Hant) DO (
    @ECHO Splitting %%L
    yq "." ^
    "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" ^
     --yaml-fix-merge-anchor-to-spec -o json ^
    | jq --arg LANGUAGE %%L ^
    --from-file "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.json_--from-file.txt" ^
    > "R:\DEBUG\LocRes-Builder\INPUT\%%L.json"
)

IF NOT EXIST "R:\DEBUG\LocRes-Builder\OUTPUT\" (
    mkdir "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CRC32"
    mkdir "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CityHash64_UTF16"
)

: ------------------------------- Parallel commands start, pauses main script while subcommand windows exist -------------------------------
(
	:: start "Optimized_CRC32" cmd.exe /c "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\LocRes-Builder_v2.bat"
	start "Optimized_CRC32" cmd.exe /S /C " python "R:\DEBUG\LocRes-Builder\src\main.py" -i "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json" -v 2 -o "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CRC32" "
	:: start "Optimized_CityHash64_UTF16" cmd.exe /c "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\LocRes-Builder_v3.bat"
	start "Optimized_CityHash64_UTF16" cmd.exe /S /C " python "R:\DEBUG\LocRes-Builder\src\main.py" -i "R:\DEBUG\LocRes-Builder\INPUT\locmeta.json" -v 3 -o "R:\DEBUG\LocRes-Builder\OUTPUT\Optimized_CityHash64_UTF16" "
	start "YAML_to_ETP" cmd.exe /C "C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\YAML_to_ETP.bat"
) | PAUSE

ECHO Parallel commands finished
CALL :Divider

: ------------------------------------------------------------ UnrealPak_-Create ------------------------------------------------------------
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
				@REM ECHO %%P
				IF %%V == Optimized_CRC32 (
					CALL :responseFile ja
					@REM CALL :RunUAT ja
				) ELSE (
					CALL :responseFile ko zh-Hans zh-Hant
					@REM CALL :RunUAT ASIA
				)
			)
			: -------------------------------------------------- Switch --------------------------------------------------
			IF %%P == Switch			(
				@REM ECHO %%P
				IF %%V == Optimized_CRC32 (
					ECHO %%V
					SET DESTINATION=Holiday
					CALL :responseFile ja
					CALL :RunUAT ja

					@REM copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
					copy "R:\DEBUG\releases\pakchunk0-%%P_JAPAN_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc" "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\!LANGUAGE!\romfs\Holiday\Content\Paks\"
				) ELSE (
					@REM CALL :responseFile ko zh-Hans zh-Hant
					@REM CALL :RunUAT ko zh-Hans zh-Hant
				)
			)
			: -------------------------------------------------- WindowsNoEditor --------------------------------------------------
			IF %%P == WindowsNoEditor	(
				ECHO %%V
				SET DESTINATION=Game
				@REM ECHO %%P
				IF %%V == Optimized_CRC32 (
					CALL :responseFile ja
					@REM CALL :RunUAT ja
				) ELSE (
					CALL :responseFile ko zh-Hans zh-Hant
					@REM CALL :RunUAT ko zh-Hans zh-Hant
				)
			)
		)
		: -------------------------------------------------- END --------------------------------------------------
		CALL :Divider
	)
)

explorer.exe "R:\DEBUG\releases"
@REM	explorer.exe "Z:\Games\Nintendo_Switch_1\(EMULATOR) Citron\v0.11.0\user\load\0100E2E0152E4000\en\romfs\Holiday\Content\Paks"

ENDLOCAL

PAUSE

: --------------------------------------------------------------- Subroutine ---------------------------------------------------------------

@REM :responseFile__ASIA
@REM (
@REM 	: -------------------------------------------------- create responseFile.txt --------------------------------------------------
@REM 	wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\version_settings.json"
@REM 	ECHO "R:\DEBUG\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
@REM 	IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\" (
@REM 		mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\"
@REM 	)
@REM 	copy "R:\DEBUG\LocRes-Builder\OUTPUT\!LocResVersion!\Game\!LANGUAGE!\Game.locres" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!"
@REM 	FOR %%A IN (ko zh-Hans zh-Hant) DO (
@REM 		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\" (
@REM 			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\"
@REM 		)
@REM 		: ---------------------------------------- ko + zh-Hans + zh-Hant fail-safes ----------------------------------------
@REM 		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres"
@REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres" "../../../!DESTINATION!/Content/Localization/Game/%%A/Game.locres" >> "R:\DEBUG\staging\responseFile.txt"
@REM 		SET ETP=%%A
@REM 		SET newETP=!ETP:-=_!
@REM 		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\" (
@REM 			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\"
@REM 		)
@REM 		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP\" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\"
@REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP_!newETP!\*" "../../../!DESTINATION!/Content/NonAssets/ETP_!newETP!/" >> "R:\DEBUG\staging\responseFile.txt"
@REM 	)
@REM 	ECHO:
@REM 	EXIT /B
@REM )

@REM :responseFile__JAPAN
@REM (
@REM 	: -------------------------------------------------- create responseFile.txt --------------------------------------------------
@REM 	wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\version_settings.json"
@REM 	ECHO "R:\DEBUG\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
@REM 	FOR %%A IN (ja) DO (
@REM 		IF NOT EXIST "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\" (
@REM 			mkdir "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\"
@REM 		)
@REM 		copy "R:\DEBUG\LocRes-Builder\OUTPUT\!LocResVersion!\Game\!LANGUAGE!\Game.locres" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!"
@REM 		: -------------------------------------------------- ja fail-safe --------------------------------------------------
@REM 		copy "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\Game.locres.!LocResVersion!" "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres"
@REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\Localization\Game\%%A\Game.locres" "../../../!DESTINATION!/Content/Localization/Game/%%A/Game.locres" >> "R:\DEBUG\staging\responseFile.txt"
@REM 		ECHO "R:\DEBUG\staging\!LANGUAGE!\Game\Content\NonAssets\ETP\*" "../../../!DESTINATION!/Content/NonAssets/ETP/" >> "R:\DEBUG\staging\responseFile.txt"
@REM 	)
@REM 	ECHO:
@REM 	EXIT /B
@REM )

:responseFile
(
	: -------------------------------------------------- create responseFile.txt --------------------------------------------------
	@REM wsl.exe jq -n "{\"AppVersionString\": \"2.0.1\n!LANGUAGE!_v!DATE!\n!PLATFORM!\"}" > "R:\DEBUG\staging\version_settings.json"
	@REM ECHO "R:\DEBUG\staging\version_settings.json" "../../../!DESTINATION!/Content/Settings/Version/version_settings.json" > "R:\DEBUG\staging\responseFile.txt"
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
			@REM ECHO JAPAN
			@REM ECHO A = %%A
			SET ETP="ETP"
			SET REGION="JAPAN"
		)
		IF "%*"=="ko zh-Hans zh-Hant" (
			@REM ECHO ASIA
			@REM ECHO A = %%A
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
	EXIT /B
)

:UnrealPak_Create
(
	%UE_5.1%UnrealPak "R:\DEBUG\releases\pakchunk0-!PLATFORM!_%1_!LANGUAGE!_Dialogue_Latest_P.pak" -Create="R:\DEBUG\staging\responseFile.txt"
	%UE_5.1%UnrealPak "R:\DEBUG\releases\pakchunk0-!PLATFORM!_%1_!LANGUAGE!_Dialogue_Latest_P.pak" -List
	move "R:\DEBUG\staging\responseFile.txt" "R:\DEBUG\staging\!LANGUAGE!\responseFile.%1.txt"
	ECHO:
	EXIT /B
)

:RunUAT
(
	: --------------------------------------------------------- Copy files to UE4Editor ---------------------------------------------------------
	del /Q /S F:\Test\Holiday\Content\Localization\*
	del /Q /S F:\Test\Holiday\Content\NonAssets\*
	del /Q /S F:\Test\Holiday\Content\Settings\*
	del /Q /S F:\Test\Holiday\Content\StringTables\*
	@REM del /Q /S R:\Holiday\Content\Localization\*
	@REM del /Q /S R:\Holiday\Content\NonAssets\*
	@REM del /Q /S R:\Holiday\Content\Settings\*
	@REM del /Q /S R:\Holiday\Content\StringTables\*
	xcopy /f /j /s /v /y "R:\DEBUG\staging\!LANGUAGE!\Game\Content\*" "F:\Test\Holiday\Content\i18n\!LANGUAGE!\"
	xcopy /f /j /s /v /y "F:\Test\Holiday\Content\i18n\!LANGUAGE!\*" "F:\Test\Holiday\Content\"
	@REM xcopy /f /j /s /v /y "R:\DEBUG\staging\!LANGUAGE!\Game\Content\*" "R:\Holiday\Content\i18n\!LANGUAGE!\"
	@REM xcopy /f /j /s /v /y "R:\Holiday\Content\i18n\!LANGUAGE!\*" "R:\Holiday\Content\"
	IF "%*"=="ja" (
		SET REGION=JAPAN
		del /Q /S F:\Test\Holiday\Content\Localization\Game\ko\Game.locres
		del /Q /S F:\Test\Holiday\Content\Localization\Game\zh-Hans\Game.locres
		del /Q /S F:\Test\Holiday\Content\Localization\Game\zh-Hant\Game.locres
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP_ko\*
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP_zh_Hans\*
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP_zh_Hant\*
		@REM del /Q /S R:\Holiday\Content\Localization\Game\ko\Game.locres
		@REM del /Q /S R:\Holiday\Content\Localization\Game\zh-Hans\Game.locres
		@REM del /Q /S R:\Holiday\Content\Localization\Game\zh-Hant\Game.locres
		@REM del /Q /S R:\Holiday\Content\NonAssets\ETP_ko\*
		@REM del /Q /S R:\Holiday\Content\NonAssets\ETP_zh_Hans\*
		@REM del /Q /S R:\Holiday\Content\NonAssets\ETP_zh_Hant\*
		: --------------------------------------------------------------- Bad files ---------------------------------------------------------------
		@REM BATTLE {0} being rendered literally, empty variable
		del /Q /S F:\Test\Holiday\Content\StringTables\Game\Battle\STT_BattleAbiMsg.uasset
		@REM  BATTLE overwrites STT_ActionMsg_Simple3's "takes damage" with "miss! No damage taken"
		del /Q /S F:\Test\Holiday\Content\StringTables\Game\Battle\ActionMsg\Simple\STT_ActionMsg_Simple5.uasset
		@REM del /Q /S F:\Test\Holiday\Content\StringTables\Game\Battle\STT_BattleSysMsg_LOG.uasset
	)
	IF "%*"=="ko zh-Hans zh-Hant" (
		SET REGION=ASIA
		del /Q /S F:\Test\Holiday\Content\Localization\Game\ja\Game.locres
		del /Q /S F:\Test\Holiday\Content\NonAssets\ETP\*
		@REM del /Q /S R:\Holiday\Content\Localization\Game\ja\Game.locres
		@REM del /Q /S R:\Holiday\Content\NonAssets\ETP\*
	)
	del /Q /S F:\Test\Holiday\Content\Localization\Game\Game.locres.Optimized_CityHash64_UTF16
	del /Q /S F:\Test\Holiday\Content\Localization\Game\Game.locres.Optimized_CRC32
	: ---------------------------------------------------------- Build RunUAT outputs ----------------------------------------------------------
	"%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=F:/Test/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	@REM "%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=R:/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output
	: --------------------------------------------------- Move RunUAT outputs to \releases\* ---------------------------------------------------
	move "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.pak" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.pak"
	move "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.ucas" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.ucas"
	move "R:\DEBUG\releases\UE4Editor\WindowsNoEditor\Holiday\Content\Paks\pakchunk30-WindowsNoEditor.utoc" "R:\DEBUG\releases\pakchunk0-!PLATFORM!_!REGION!_!LANGUAGE!_Dialogue_Latest__RunUAT_P.utoc"
)

:Divider
(
	ECHO:
	ECHO --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	ECHO:
)