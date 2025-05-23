@REM jq "
@REM to_entries
@REM | map(
@REM 	reduce . as $obj ({}; 
@REM 		{
@REM 			"key": $obj.["key"],
@REM 			"value": (
@REM 				$obj.["value"]
@REM 				| to_entries
@REM 				| map(
@REM 					{
@REM 						"key": .key,
@REM 						"value": {
@REM 							"<LANGUAGE>": .value
@REM 						}
@REM 					}
@REM 				)
@REM 				| from_entries
@REM 			)
@REM 		}
@REM 	)
@REM )
@REM | from_entries
@REM "
@REM LocRes-Builder-v0.1.2/INPUT/<LANGUAGE>.json 
@REM > LocRes-Builder-v0.1.2/OUTPUT/<LANGUAGE>.locres.json

@REM Escape Quotation Marks with a backslash
ECHO
 FOR $LANGUAGE IN ko, zh-Hans, zh-Hant; DO ^
 jq "to_entries| map(reduce . as $obj ({};{\"key\": $obj.[\"key\"],\"value\": ($obj.[\"value\"]| to_entries| map({\"key\": .key,\"value\": {\"$LANGUAGE\": .value}})| from_entries)}))| from_entries" ^
 "LocRes-Builder-v0.1.2/INPUT/$LANGUAGE.json" ^
 "> LocRes-Builder-v0.1.2/OUTPUT/$LANGUAGE.locres.json"^
PAUSE