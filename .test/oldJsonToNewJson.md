<details><summary>Test</summary><a id="test"></a>

# Input
```json
// eventTextIeR5JayrDungrServer.win32.json
{
  "143652": {
    "返事がない。\nただの　しかばねのようだ……。": 
    "No response. It seems that it is just a corpse......"
  },
  "88166": {
    "遺跡の回廊が　くずれている。\nここから　先へは進めないようだ。": 
    "The ruin's passage is crumbling. It seems that you\ncannot go beyond this point."
  }
}
```
# JQ Query
```js
to_entries
| map(
    .value = ({
        "de": "",
        "en": (.value | values | to_entries[].value),
        "es": "",
        "fr": "",
        "it": "",
        "ja": (.value | values | to_entries[].key),
        "ko": "",
        "zh-hans": "",
        "zh-hant": ""
    })
)
| from_entries
```
# Output
```json
{
  "143652": {
    "de": "",
    "en": "No response. It seems that it is just a corpse......",
    "es": "",
    "fr": "",
    "it": "",
    "ja": "返事がない。\nただの　しかばねのようだ……。",
    "ko": "",
    "zh-hans": "",
    "zh-hant": ""
  },
  "88166": {
    "de": "",
    "en": "The ruin's passage is crumbling. It seems that you\ncannot go beyond this point.",
    "es": "",
    "fr": "",
    "it": "",
    "ja": "遺跡の回廊が　くずれている。\nここから　先へは進めないようだ。",
    "ko": "",
    "zh-hans": "",
    "zh-hant": ""
  }
}
```

</details>

<details><summary>All files</summary>

# Input
- `Steam/**/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP`
  - (old format)
# CMD FOR /F Loop > JQ Query
```bat
FOR /F %A IN ('dir /b') DO jq "to_entries| map(.value = ({\"de\": \"\",\"en\": (.value | values | to_entries[].value),\"es\": \"\",\"fr\": \"\",\"it\": \"\",\"ja\": (.value | values | to_entries[].key),\"ko\": \"\",\"zh-hans\": \"\",\"zh-hant\": \"\"}))| from_entries" "%A" ^[> "./test/%A"
```
- rename newly created `test` folder to `ETP`
# Output
- See [Test's Output](#test)

</details>

<details>

# Input
- `Steam/**/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP`
  - (new format)

# JQ Query
- reduces both incomplete files into 1 complete file
```js
[
	(.[1] | to_entries | map(.value = ({"ko": (.value | values | to_entries[].key)}))| from_entries) as $ko
    | .[0], $ko
    # OR
    # (.[1] | to_entries | map(.value = ({"zh-hans": (.value | values | to_entries[].key)}))| from_entries) as $ko
    # | .[0], $zh-hans
    # OR
    # (.[1] | to_entries | map(.value = ({"zh-hant": (.value | values | to_entries[].key)}))| from_entries) as $ko
    # | .[0], $zh-hant
]
| group_by(keys_unsorted)
| map(
	reduce .[] as $obj ({}; . * $obj)
)[]
```

# CMD FOR /F Loop > JQ Query
```bat
FOR /F %A IN ('dir ETP /b') DO jq -s "[(.[1] | to_entries | map(.value = ({\"ko\": (.value | values | to_entries[].key)}))| from_entries) as $ko| .[0], $ko]| group_by(keys_unsorted)| map(reduce .[] as $obj ({}; . * $obj))[]" "./ETP/%A" "S:/Consoles/Valve Steam/tools/DUMPs/DRAGON QUEST X OFFLINE/Fmodel/Properties/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP_ko/%A" ^[> "./test/%A"
```
- rename newly created `test` folder to `ETP`

# Output
- See [Test's Output](#test)

</details>
