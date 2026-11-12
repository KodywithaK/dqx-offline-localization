# cls & FOR %F IN (b1000000) DO FOR %L IN (en) DO jq --arg FILENAME %%F --arg LANGUAGE %%L --from-file "!{github_directory}!\tools\REFERENCES\DQ04\tools\03. jq\b#######.mpt.03.jq" "!{github_directory}!\tools\REFERENCES\DQ04\tools\03. jq\ALL\%%F.mpt.json" | yq "with_entries( .key = ( .key | to_number ) ) | .. style=\"double\" | sort_keys( .. )" -p json -o yaml > "!{github_directory}!\tools\REFERENCES\DQ04\tools\03. jq\ALL\%%F.mpt.yaml"

if ( $FILENAME | test("b1000000|b1002000") )
then (
    to_entries
    | map(
        .value = (
            .value
            | to_entries
            | map(
                .LANGUAGES = {}
                | if ( .key | test("de|en|es|fr|it|ja") )
                then (
                    .LANGUAGES += {
                        "gender": ( { (.key): ( .value | split("@0")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "genderless": ( { (.key): ( .value | split("@1")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "singular_definite": ( { (.key): ( .value | split("@2")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "singular_indefinite": ( { (.key): ( .value | split("@3")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "singular": ( { (.key): ( .value | split("@4")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "plural_definite": ( { (.key): ( .value | split("@5")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "plural_indefinite": ( { (.key): ( .value | split("@6")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "plural": ( { (.key): ( .value | split("@7")[1] | split("@")[0] ) } )? // ( { (.key) : "" } ),
                        "yesno_idk_yet": ( { (.key): ( .value | split("@8")[1] | split("@")[0] ) } )? // ( { (.key) : "" } )
                    }
                )
                else ( . )
                end
                | .LANGUAGES
            )
            | reduce .[] as $LANGUAGES ( {}; . * $LANGUAGES )
        )
    )
    | sort_by( .key = ( ( .key | tonumber + 1000000 ) | tostring ) )
    | from_entries
)
else ( . )
end
