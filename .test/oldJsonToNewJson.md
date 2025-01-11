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
        "comments": "",
        "de": "",
        "en": (.value | values | to_entries[].value),
        "es": "",
        "fr": "",
        "it": "",
        "ja": (.value | values | to_entries[].key),
        "ko": "",
        "zh-Hans": "",
        "zh-Hant": ""
    })
)
| from_entries
```
# Output
```json
{
  "143652": {
    "comments": "",
    "de": "",
    "en": "No response. It seems that it is just a corpse......",
    "es": "",
    "fr": "",
    "it": "",
    "ja": "返事がない。\nただの　しかばねのようだ……。",
    "ko": "",
    "zh-Hans": "",
    "zh-Hant": ""
  },
  "88166": {
    "comments": "",
    "de": "",
    "en": "The ruin's passage is crumbling. It seems that you\ncannot go beyond this point.",
    "es": "",
    "fr": "",
    "it": "",
    "ja": "遺跡の回廊が　くずれている。\nここから　先へは進めないようだ。",
    "ko": "",
    "zh-Hans": "",
    "zh-Hant": ""
  }
}
```

</details>

<details><summary>All files</summary>

# Input
- `Steam/**/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP`
  - (old format)

# JQ Query
- separates key (ja) and value (en), from old format into new format
```js
to_entries
| map(
    .value = ({
        "comments": "",
        "de": "",
        "en": (.value | values | to_entries[].value),
        "es": "",
        "fr": "",
        "it": "",
        "ja": (.value | values | to_entries[].key),
        "ko": "",
        "zh-Hans": "",
        "zh-Hant": ""
    })
)
| from_entries
```

# CMD FOR /F Loop > JQ Query
```bat
FOR /F %A IN ('dir /b') DO jq "to_entries| map(.value = ({\"de\": \"\",\"en\": (.value | values | to_entries[].value),\"es\": \"\",\"fr\": \"\",\"it\": \"\",\"ja\": (.value | values | to_entries[].key),\"ko\": \"\",\"zh-Hans\": \"\",\"zh-Hant\": \"\"}))| from_entries" "%A" ^[> "./test/%A"
```
- rename newly created `test` folder to `ETP`
# Output
- See [Test's Output](#test)

</details>

<details><summary>Combine files by key</summary>

# Input
- `Steam/**/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP`
  - .[0] = (new format)
  - .[1] = (old format)

# JQ Query
- reduces both incomplete files into 1 complete file
```js
# jq -s
[
    (.[1] | to_entries | map(.value = ({"en": (.value | values | to_entries[].value)}))| from_entries) as $en
    | .[0], $en
    # OR
    # (.[1] | to_entries | map(.value = ({"ko": (.value | values | to_entries[].key)}))| from_entries) as $ko
    # | .[0], $ko
    # OR
    # (.[1] | to_entries | map(.value = ({"zh-Hans": (.value | values | to_entries[].key)}))| from_entries) as $ko
    # | .[0], $zh-Hans
    # OR
    # (.[1] | to_entries | map(.value = ({"zh-Hant": (.value | values | to_entries[].key)}))| from_entries) as $ko
    # | .[0], $zh-Hant
]
| group_by(.key)
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

<details><summary>Remove Duplicates</summary>

# Input
- Files where (for whatever reason) `oldJsonToNewJson.bat` produced duplicates of the japanese script.
```json
{
  "143657": {
    "comments": "",
    "de": "Keine Reaktion. Der Körper ist leblos......",
    "en": "No response. It seems that it is just a corpse......",
    "es": "No responde. Parece que no es más que un cadáver......",
    "fr": "Pas de réponse. Ce n'est qu'un cadavre......",
    "it": "Non risponde. È solo un cadavere......",
    "ja": "返事がない。\nただの　しかばねのようだ……。",
    "ko": "返事がない。\nただの　しかばねのようだ……。",
    "zh-Hans": "返事がない。\nただの　しかばねのようだ……。",
    "zh-Hant": "返事がない。\nただの　しかばねのようだ……。"
  }
}
```

# JQ Query
- `elif` wasn't working for me, so multiple `if`s instead.
```js
.[]
| to_entries
| map(
  if (.value.ja == .value."ko")
  then (.value."ko" = "")
  else .
  end
  |if (.value.ja == .value."zh-Hans")
  then (.value."zh-Hans" = "")
  else .
  end
  |if (.value.ja == .value."zh-Hant")
  then (.value."zh-Hant" = "")
  else .
  end
)
| from_entries
```

# Output
```json
{
  "143657": {
    "comments": "",
    "de": "Keine Reaktion. Der Körper ist leblos......",
    "en": "No response. It seems that it is just a corpse......",
    "es": "No responde. Parece que no es más que un cadáver......",
    "fr": "Pas de réponse. Ce n'est qu'un cadavre......",
    "it": "Non risponde. È solo un cadavere......",
    "ja": "返事がない。\nただの　しかばねのようだ……。",
    "ko": "",
    "zh-Hans": "",
    "zh-Hant": ""
  }
}
```

</details>