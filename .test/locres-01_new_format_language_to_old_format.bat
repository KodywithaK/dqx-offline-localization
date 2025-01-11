@REM jq --arg LANGUAGE "(de|en|es|fr|it|ja|ko|zh-Hans|zh-Hant)" 
@REM "
@REM to_entries
@REM | map(
@REM     reduce . as $obj ({};
@REM         {
@REM             "key": $obj.["key"],
@REM             "value": (
@REM                 $obj.["value"]
@REM                 | to_entries
@REM                 | map({
@REM                     "key": .key,
@REM                     "value": [(
@REM                         if (.value.[$LANGUAGE] != "")
@REM                         then (.value = .value.[$LANGUAGE])
@REM                         else (.value = .value.ja)
@REM                         end
@REM                     )]
@REM                     | from_entries[]
@REM                 })
@REM                 | from_entries
@REM             )
@REM         }
@REM     )
@REM )
@REM | from_entries
@REM "
@REM 
@REM Escape Quotation Marks with a backslash
@REM  jq "to_entries| map(reduce . as $obj ({};{\"key\": $obj.[\"key\"],\"value\": ($obj.[\"value\"]| to_entries| map({\"key\": .key,\"value\": .value.ja,})| from_entries)}))| from_entries"^
@REM  jq "to_entries| map(reduce . as $obj ({};{\"key\": $obj.[\"key\"],\"value\": ($obj.[\"value\"]| to_entries| map({\"key\": .key,\"value\": [(if (.value.en != \"\")then (.value = .value.en)else (.value = .value.ja)end)]| from_entries[]})| from_entries)}))| from_entries"^
 FOR /F %%A IN (locres-01_new_format_language_to_old_format.txt) DO jq --arg LANGUAGE "%%A"^
 "to_entries| map(reduce . as $obj ({};{\"key\": $obj.[\"key\"],\"value\": ($obj.[\"value\"]| to_entries| map({\"key\": .key,\"value\": [(if (.value.[$LANGUAGE] != \"\")then (.value = .value.[$LANGUAGE])else (.value = .value.ja)end)]| from_entries[]})| from_entries)}))| from_entries"^
 "..\Steam\App_ID-1358750\Build_ID-14529657\BACKLOG\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.json"^
 > "C:\Users\Ryzen3\Desktop\! DELETE\DRAGON QUEST X OFFLINE\LocRes-Builder-v0.1.2\INPUT\%%A.json"
@REM PAUSE