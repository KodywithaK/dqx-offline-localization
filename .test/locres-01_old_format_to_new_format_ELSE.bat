@REM  jq "
@REM  to_entries
@REM  | map(
@REM      reduce . as $obj ({};
@REM          {
@REM              "key": $obj.["key"],
@REM              "value": (
@REM                  $obj.["value"]
@REM                  | to_entries
@REM                  | map({
@REM                      "key": .key,
@REM                      "value": {
@REM                          "comments": "",
@REM                          "de": "",
@REM                          "en": "",
@REM                          "es": "",
@REM                          "fr": "",
@REM                          "it": "",
@REM                          "ja": .value,
@REM                          "ko": "",
@REM                          "zh-Hans": "",
@REM                          "zh-Hant": "",
@REM                      }
@REM                  })
@REM                  | from_entries
@REM              )
@REM          }
@REM      )
@REM  )
@REM  | from_entries
@REM  "^
@REM 
@REM Escape Quotation Marks with a backslash
ECHO
 jq -s "to_entries| map(reduce . as $obj ({};{\"key\": $obj.[\"key\"],\"value\": ($obj.[\"value\"]| to_entries| map({\"key\": .key,\"value\": {\"comments\": \"\",\"de\": \"\",\"en\": \"\",\"es\": \"\",\"fr\": \"\",\"it\": \"\",\"ja\": .value,\"ko\": \"\",\"zh-Hans\": \"\",\"zh-Hant\": \"\",}})| from_entries)}))| from_entries"^
 "T:\Downloads\! test\delete\Game.locres.json"^
 > "T:\Downloads\! test\delete\INPUT.json"
PAUSE