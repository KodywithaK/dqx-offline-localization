@REM Place in "Steam/**/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/oldJsonToNewJson--removeDuplicates.bat"
@ECHO OFF
ECHO
FOR /F %%A IN ('dir ETP /b') DO jq -s ^
 ".[] | to_entries | map( if (.value.ja == .value.\"ko\") then (.value.\"ko\" = \"\") else . end |if (.value.ja == .value.\"zh-hans\") then (.value.\"zh-hans\" = \"\") else . end |if (.value.ja == .value.\"zh-hant\") then (.value.\"zh-hant\" = \"\") else . end)| from_entries" ^
 "./test/%%A" ^
 > "./removeDuplicates/%%A"
PAUSE