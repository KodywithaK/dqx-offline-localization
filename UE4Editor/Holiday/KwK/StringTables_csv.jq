.[$FILENAME] as $obj
| reduce ( $obj | keys_unsorted )[] as $k (
    { "Key":"SourceString" };
    .[$k] += (
        if ( $obj[$k].[$LANGUAGE] != "" )
        then ( $obj[$k].[$LANGUAGE] )
        else ( $obj[$k].["ja"] )
        end
    )
)
| to_entries[] | [.key, .value]
| @csv