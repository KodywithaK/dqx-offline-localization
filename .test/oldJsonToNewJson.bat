@REM Place in "Steam/**/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/oldJsonToNewJson--removeDuplicates.bat"
@ECHO OFF
ECHO
FOR /F %%A IN ('dir ETP /b') DO jq -s ^
 "[(.[1] | to_entries | map(.value = ({(\"ko\"): (.value | values | to_entries[].key)}))| from_entries) as $ko| .[0], $ko| group_by(keys_unsorted)| map(reduce .[] as $obj ({}; . * $obj))[]" ^
 "./ETP/%%A" ^
 "S:/Consoles/Valve Steam/tools/DUMPs/DRAGON QUEST X OFFLINE/Fmodel/Properties/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP_ko/%%A" ^
 > "./test/%%A"
PAUSE