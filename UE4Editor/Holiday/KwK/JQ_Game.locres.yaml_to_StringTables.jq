. as $obj
| reduce ( $obj | keys_unsorted )[] as $k (
    {};
    .StringTable.KeysToEntries.[$k] += (
        if ( $LANGUAGE != "la" )
        then (
            if   ( $obj[$k].[$LANGUAGE] != "" )
            then ( $obj[$k].[$LANGUAGE] )
            else ( $obj[$k].["ja"] )
            end
        )
        else (
            # ( $k | ascii_downcase )
            ( [ ( $k | ascii_downcase ), $obj[$k].["ja"] ] | join("\\n<br>\\n") )
        )
        end
    )
)
| [.]