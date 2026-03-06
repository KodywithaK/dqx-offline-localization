# StringTables

```bat
: --------------- Extract to StringTables.DEMO.ASIA, StringTables.DEMO.JAPAN, StringTables.PAID.ASIA, StringTables.PAID.JAPAN ---------------

REM : Use https://github.com/joric/CUE4Parse.CLI or https://github.com/4sval/FModel to extract the StringTables
REM : From DQXO DEMO & FULL "pakchunk0-<PLATFORM>.ucas\<Game,Holiday>\Content\StringTables\**\*.uasset" as .json

: ----------------------------- Combine StringTables.DEMO.JAPAN\**\*.json and StringTables.DEMO.ASIA\**\*.json -----------------------------

REM : %TEMP%\CUE4Parse.CLI\Game\Content OR %TEMP%\CUE4Parse.CLI\Holiday\Content>
cls && FOR /F "usebackq delims=" %F IN (`dir StringTables.DEMO.ASIA /b /a-d /o:n /s`) DO jq -S "." "%F" > "%F.tmp"
REM : copy StringTables.DEMO.JAPAN\Game\**\*.tmp files to StringTables.DEMO.JAPAN\Game\

REM : %TEMP%\CUE4Parse.CLI\Game\Content\StringTables.DEMO.JAPAN\Game OR %TEMP%\CUE4Parse.CLI\Holiday\Content\StringTables.DEMO.JAPAN\Game>
cls && FOR /F "usebackq delims=" %F IN (`dir *.json /b /a-d /o:n /s`) DO jq -S -s "reduce .[] as $obj ( {}; . |= $obj )" "%F" "%F.tmp" > "%F.DEMO"
REM : rename StringTables.DEMO.JAPAN to StringTables.DEMO

REM : %TEMP%\CUE4Parse.CLI\Game\Content\StringTables.DEMO OR %TEMP%\CUE4Parse.CLI\Holiday\Content\StringTables.DEMO>
cls && FOR /F "usebackq delims=" %F IN (`dir *.json /b /a-d /o:n /s`) DO del "%F"
cls && FOR /F "usebackq delims=" %F IN (`dir *.tmp /b /a-d /o:n /s`) DO del "%F"

: ----------------------------- Combine StringTables.PAID.JAPAN\**\*.json and StringTables.PAID.ASIA\**\*.json -----------------------------

REM : %TEMP%\CUE4Parse.CLI\Game\Content OR %TEMP%\CUE4Parse.CLI\Holiday\Content>
cls && FOR /F "usebackq delims=" %F IN (`dir StringTables.PAID.ASIA /b /a-d /o:n /s`) DO jq -S "." "%F" > "%F.tmp"
REM : copy StringTables.PAID.ASIA\Game\**\*.tmp files to StringTables.PAID.JAPAN\Game\

REM : %TEMP%\CUE4Parse.CLI\Game\Content\StringTables.PAID.ASIA\Game OR %TEMP%\CUE4Parse.CLI\Holiday\Content\StringTables.PAID.ASIA\Game>
cls && FOR /F "usebackq delims=" %F IN (`dir *.json /b /a-d /o:n /s`) DO jq -S -s "reduce .[] as $obj ( {}; . |= $obj )" "%F" "%F.tmp" > "%F.PAID"
REM : rename StringTables.PAID.JAPAN to StringTables.PAID

REM : %TEMP%\CUE4Parse.CLI\Game\Content\StringTables.PAID OR %TEMP%\CUE4Parse.CLI\Holiday\Content\StringTables.PAID>
cls && FOR /F "usebackq delims=" %F IN (`dir *.json /b /a-d /o:n /s`) DO del "%F"
cls && FOR /F "usebackq delims=" %F IN (`dir *.tmp /b /a-d /o:n /s`) DO del "%F"
REM : copy StringTables.PAID\Game\**\*.PAID files to StringTables.DEMO\Game\
REM : rename StringTables.DEMO to StringTables.COMPLETE

: ----------------------------------- Combine StringTables.DEMO\**\*.json and StringTables.PAID\**\*.json -----------------------------------

REM : %TEMP%\CUE4Parse.CLI\Game\Content\StringTables.COMPLETE\Game OR %TEMP%\CUE4Parse.CLI\Holiday\Content\StringTables.COMPLETE\Game>
cls && FOR /F "usebackq delims=" %F IN (`dir *.DEMO /b /a-d /o:n /s`) DO jq -S -s "reduce .[] as $obj ( {}; . |= $obj )" "%F" "%~dpnF.PAID" > "%~dpnF"
REM : *Almost* all files will be combined and output to *.json

: ---------------------------- Rename stray StringTables.COMPLETE\**\*.DEMO and StringTables.COMPLETE\**\*.PAID ----------------------------

REM : Some files need to be manually renamed because of a difference in the number of files between each platform and version
dir *.DEMO /b /a-d /o:n /s | clip
dir *.PAID /b /a-d /o:n /s | clip
REM : paste into new, separate text documents and diff to see what needs renamed to .json

REM : IMPORTANT "**\StringTables\Game\Battle\STT_BattleOddMsg_DAP_SYS.json" has an empty key that needs to be deleted for JsonAsAsset to not crash

cls && FOR /F "usebackq delims=" %F IN (`dir *.DEMO /b /a-d /o:n /s`) DO del "%F"
cls && FOR /F "usebackq delims=" %F IN (`dir *.PAID /b /a-d /o:n /s`) DO del "%F"
REM : rename StringTables.COMPLETE to StringTables

: -------------------------------------------------- StringTables_JsonAsAsset_YYYYMMDD.bat --------------------------------------------------

REM : Split Game.locres.yaml to temp\<LANGUAGE>\*.json
REM : Combine with the newly created StringTables\**\*.json
REM : Output to Holiday\Content\i18n\<LANGUAGE>\StringTables\**\*.json

: -------------------------------------------------- UE4Editor to JsonAsAsset to UnrealPak --------------------------------------------------

REM : IMPORTANT "**\StringTables\Game\Battle\STT_BattleOddMsg_DAP_SYS.json" has an empty key that needs to be deleted for JsonAsAsset to not crash
REM : Import and save Holiday\Content\i18n\<LANGUAGE>\StringTables\**\*.json as Holiday\Content\StringTables\**\*.uasset
REM : Create pakchunk0-<PLATFORM>_<REGION>_<LANGUAGE>_Dialogue_Latest*.<pak,ucas,utoc> with UnrealPak 5.1+ or RunUAT
REM : Copy pakchunk0-<PLATFORM>_<REGION>_<LANGUAGE>_Dialogue_Latest*.<pak,ucas,utoc> to your preferred platform for playtesting
```