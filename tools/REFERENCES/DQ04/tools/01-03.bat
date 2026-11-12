@ECHO OFF

REM path of the directory where you cloned the repository is located
SET "{github_directory}=R:"
REM path of the directory where your DQ04 (nds) extracted files are located
SET "{NTR-YIVx-xxx_directory}=S:\Consoles\Nintendo DS\ROMs\Dragon Quest Ⅳ Chapters of the Chosen ｢導かれし者たち｣"
REM path of the directory where your DQ05 (nds) extracted files are located
SET "{NTR-YV5x-xxx_directory}=S:\Consoles\Nintendo DS\ROMs\Dragon Quest Ⅴ Hand of the Heavenly Bride ｢天空の花嫁｣"
REM path of the directory where your DQ06 (nds) extracted files are located
REM SET "{NTR-YVIx-xxx_directory}=S:\Consoles\Nintendo DS\ROMs\Dragon Quest Ⅵ Realms of Revelation ｢幻の大地｣"
SET "{NTR-YVIx-xxx_directory}=S:\Consoles\Apple_IOS\ROMs\Dragon Quest #06 - Realms Of Revelation ｢幻の大地｣"

SETLOCAL EnableDelayedExpansion

CALL :ANSI TIP: {github_directory}       = !{github_directory}!
CALL :ANSI TIP: {NTR-YIVx-xxx_directory} = !{NTR-YIVx-xxx_directory}!
CALL :ANSI TIP: {NTR-YV5x-xxx_directory} = !{NTR-YV5x-xxx_directory}!
CALL :ANSI TIP: {NTR-YVIx-xxx_directory} = !{NTR-YVIx-xxx_directory}!

: ------------------------------------------- 00. Inputs -------------------------------------------
:INPUTS
CALL :ANSI NOTE: "Which game(s) to output? If multiple, separate by spaces (DQ04 DQ05 DQ06)"
SET /P GAMES=""
CALL :DIVIDER
CALL :ANSI NOTE: "Which language(s) to output? If multiple, separate by spaces (de en es fr it ja)"
SET /P LANGUAGES=""
CALL :DIVIDER
CALL :ANSI NOTE: "Which file(s) to output? If multiple, separate by spaces (b0000000 b0001000 . . . b1010000)"
SET /P FILES=""
CALL :DIVIDER

FOR %%G IN (!GAMES!) DO (
	IF [%%G]==[DQ04] (
		CALL :ANSI TIP: Game = %%G
		CALL :ANSI IMPORTANT: CALL :MPT_to_YAML "!{NTR-YIVx-xxx_directory}!\data\MESS"
		CALL :MPT_to_YAML "!{NTR-YIVx-xxx_directory}!\data\MESS"
	) ELSE IF [%%G]==[DQ05] (
		CALL :ANSI TIP: Game = %%G
		CALL :ANSI IMPORTANT: CALL :MPT_to_YAML "!{NTR-YV5x-xxx_directory}!\data\MESS5"
		CALL :MPT_to_YAML "!{NTR-YV5x-xxx_directory}!\data\MESS5"
	) ELSE IF [%%G]==[DQ06] (
		CALL :ANSI TIP: Game = %%G
		CALL :ANSI IMPORTANT: CALL :MPT_to_YAML "!{NTR-YVIx-xxx_directory}!\DQ6 1.1.1\Payload\DQ6.app\Data\Raw\msg"
		CALL :MPT_to_YAML "!{NTR-YVIx-xxx_directory}!\DQ6 1.1.1\Payload\DQ6.app\Data\Raw\msg"
	) ELSE (
		CALL :ANSI CAUTION: Valid game not specified [DQ04 DQ05 DQ06]. Please try again.
		PAUSE
		GOTO :INPUTS
	)
)

PAUSE

GOTO :EOF

: ------------------------------------------- Subroutines -------------------------------------------

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

:MPT_to_YAML
(
	CALL :IMHEX %1
	CALL :PYTHON
	CALL :JQ
	EXIT /B 0
)

:IMHEX
(
	: -------------------------------------------- 01. ImHex --------------------------------------------
	FOR %%F IN (!FILES!) DO (
		FOR %%L IN (!LANGUAGES!) DO (
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L" (
				MKDIR "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L"
			)
			CALL :ANSI NOTE: "%ProgramFiles%\ImHex\imhex.exe" --pl format --formatter json --input "%~1\%%L\%%F.mpt" --output "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.json" --pattern "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\imHex-DQ04-06.hexpat"
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.json" (
				"%ProgramFiles%\ImHex\imhex.exe" ^
				--pl format ^
				--formatter json ^
				--input "%~1\%%L\%%F.mpt" ^
				--output "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.temp.json" ^
				--pattern "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\imHex-DQ04-06.hexpat"
				jq ^
				--arg LANGUAGE %%L ^
				--from-file "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\b#######.mpt.01.jq" ^
				"!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.temp.json" ^
				> "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.json"
			)
		)
	)
	CALL :DIVIDER
)

:PYTHON
(
	: ------------------------------------------- 02. python -------------------------------------------
	CALL :ANSI TIP: CD /D "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python"
	CD /D "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python"
	
	FOR %%F IN (!FILES!) DO (
		FOR %%L IN (!LANGUAGES!) DO (
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L" (
				MKDIR "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L"
			)
			CALL :ANSI NOTE: py "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\b#######.mpt.py" "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.json" "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L\%%F.mpt.json"
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L\%%F.mpt.json" (
				py "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\b#######.mpt.py" "!{github_directory}!\tools\REFERENCES\%%G\tools\01. ImHex\%%L\%%F.mpt.json" "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L\%%F.mpt.json"
			)
		)
	)
	CALL :DIVIDER
)

:JQ
(
	: --------------------------------------------- 03. jq ---------------------------------------------
	CALL :ANSI TIP: CD /D "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq"
	CD /D "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq"
	
	FOR %%F IN (!FILES!) DO (
		FOR %%L IN (!LANGUAGES!) DO (
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL" (
				MKDIR "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL"
			)
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json" (
				type nul>"!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json"
			)
			IF NOT EXIST "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\%%L" (
				MKDIR "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\%%L"
			)
			CALL :ANSI NOTE: jq --arg FILENAME %%F --arg LANGUAGE %%L "reduce .[] as $LANGUAGES ( {}; . * $LANGUAGES )" -s "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json" "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L\%%F.mpt.json" ^> "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.temp.json"
			jq ^
			--arg FILENAME %%F ^
			--arg LANGUAGE %%L ^
			"reduce .[] as $LANGUAGES ( {}; . * $LANGUAGES )" -s ^
			"!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json" "!{github_directory}!\tools\REFERENCES\%%G\tools\02. python\%%L\%%F.mpt.json" ^
			> "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.temp.json"
			CALL :ANSI NOTE: MOVE /Y "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.temp.json" "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json"
			MOVE /Y "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.temp.json" "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json"
		)
		CALL :ANSI TIP: jq --arg FILENAME %%F --arg LANGUAGE %%L --from-file "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\b#######.mpt.03.jq" "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json" ^| yq ".. style=\"double\"" -p json -o yaml ^> "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.yaml"
		jq ^
		--arg FILENAME %%F ^
		--arg LANGUAGE %%L ^
		--from-file "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\b#######.mpt.03.jq" ^
		"!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.json" ^
		| yq ".. style=\"double\"" -p json -o yaml > "!{github_directory}!\tools\REFERENCES\%%G\tools\03. jq\ALL\%%F.mpt.yaml"
	)
	CALL :DIVIDER
)
