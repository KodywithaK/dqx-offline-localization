# cls & FOR %F IN (b0000000) DO FOR %L IN (de en es fr it ja) DO jq --arg LANGUAGE %%L --from-file "!{github_directory}!\tools\REFERENCES\DQ04\tools\03. jq\b#######.mpt.01.jq" "!{github_directory}!\tools\REFERENCES\DQ04\tools\01. ImHex\%%L\%%F.mpt.temp.json" > "!{github_directory}!\tools\REFERENCES\DQ04\tools\01. ImHex\%%L\%%F.mpt.json"

.mpt.values
| with_entries(
    .key = ( .key | tostring )
    | .value = (
        {
            $LANGUAGE: (
                .value.string
                | gsub("%22"; "''") # es - json.loads() fix
            )
        }
    )
)
