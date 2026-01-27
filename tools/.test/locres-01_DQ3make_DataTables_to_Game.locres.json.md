# `Combine DataTables`

## Input

-   `GOP_Text_Noun_<LANGUAGE>.uasset.json`

## JQ Query

```js
# jq -s
.[][].Rows
| to_entries
| map(
    # select(.key | match(".*<NAMESPACE>"))
    select(.key | match(".*Magic_Name"))
    | .key = (
        # (.key | sub("TEXT_NOUN_(.*?)_<NAMESPACE>(?<b>.*)";"<KEY>\(.b)" | ascii_upcase))
        (.key | sub("TEXT_NOUN_(.*?)_Magic_Name(?<b>.*)";"PA_ACTION_NO\(.b)" | ascii_upcase))

    )
    | .value.en = .value
    # | .value = {"<LANGUAGE>": .value.<LANGUAGE>.<VALUE>}
    # | .value = {"de": .value.en.ListNoun_N}
    | .value = {"en": .value.en.ListNoun}
)
| from_entries

| {"STT_BattleSpecialSkillItem": .}
```

## Output

```json
{
    "STT_BattleSpecialSkillItem": {
        "PA_ACTION_NO_MERA": {
            "en": "Frizz"
        }
        // ...
    }
}
```

---

# `Game.locres.json` + `Combined DataTables`

## Input

```json
# jq -s
// Game.locres.json
{
	// ...
    "STT_SkillName": {
		// ...
        "PA_ACTION_NO_AINOMUTI": {
            "comments": "",
            "de": "",
            "en": "",
            "es": "",
            "fr": "",
            "it": "",
            "ja": "愛のムチ",
            "ko": "사랑의 채찍",
            "zh-Hans": "爱之鞭",
            "zh-Hant": "愛之鞭"
        }
		// ...
    }
	// ...
}
// Combined DataTables
{
    "STT_SkillName": {
        //  ...
        "PA_ACTION_NO_AINOMUTI": {
            "de": "Hiebe der Liebe",
            "en": "Lashings of Love",
            "es": "Latigazos de amor",
            "fr": "Lien de l'amour",
            "it": "Frustathon"
        }
        // ...
    }
}
```

## JQ Query

-   DQ3make's DataTable's sometimes have extra French entries, so searching for them specifically ensures none sneak in.

```js
# jq -s
reduce .[] as $obj ({}; . * $obj)

| walk(
    if
        type =="object"
        and
        (. | has("fr"))
    then
        select( has("ja"))
    else .
    end
)
```

## Output

```json
{
    // ...
    "STT_SkillName": {
        // ...
        "PA_ACTION_NO_AINOMUTI": {
            "comments": "",
            "de": "Hiebe der Liebe",
            "en": "Lashings of Love",
            "es": "Latigazos de amor",
            "fr": "Lien de l'amour",
            "it": "Frustathon",
            "ja": "愛のムチ",
            "ko": "사랑의 채찍",
            "zh-Hans": "爱之鞭",
            "zh-Hant": "愛之鞭"
        }
        // ...
    }
    // ...
}
```

---

# `DataTable/Text/<LANGUAGE>`

## Input

-   `DataTable/Text/<LANGUAGE>/*.uasset.json`

## JQ Query

```js
jq -s
[
    .[][].Rows
    | if (.Txt_BattleMenu_Top_COMMAND_00.Text == "たたかう")
    then
        (
            to_entries
            | map(
                .key = (.key | sub("Txt_BattleMenu_";"BattleUI_") )
                | .value = {
                    ja: {value}
                }
                | del(.value.ja.SelfId)
                | .value.ja = .value.ja.value.Text
            )
        )
    elif
        (.Txt_BattleMenu_Top_COMMAND_00.Text == "Fight")
    then
        (
            to_entries
            | map(
                .key = (.key | sub("Txt_BattleMenu_";"BattleUI_") )
                | .value = {
                    en: {value}
                }
                | del(.value.en.SelfId)
                | .value.en = .value.en.value.Text
            )
        )
    elif
        (.Txt_BattleMenu_Top_COMMAND_00.Text == "Kämpfen")
    then
        (
            to_entries
            | map(
                .key = (.key | sub("Txt_BattleMenu_";"BattleUI_") )
                | .value = {
                    de: {value}
                }
                | del(.value.de.SelfId)
                | .value.de = .value.de.value.Text
            )
        )
    elif
        (.Txt_BattleMenu_Top_COMMAND_00.Text == "Luchar")
    then
        (
            to_entries
            | map(
                .key = (.key | sub("Txt_BattleMenu_";"BattleUI_") )
                | .value = {
                    es: {value}
                }
                | del(.value.es.SelfId)
                | .value.es = .value.es.value.Text
            )
        )
    elif
        (.Txt_BattleMenu_Top_COMMAND_00.Text == "Combat")
    then
        (
            to_entries
            | map(
                .key = (.key | sub("Txt_BattleMenu_";"BattleUI_") )
                | .value = {
                    fr: {value}
                }
                | del(.value.fr.SelfId)
                | .value.fr = .value.fr.value.Text
            )
        )
    elif
        (.Txt_BattleMenu_Top_COMMAND_00.Text == "Lotta")
    then
        (
            to_entries
            | map(
                .key = (.key | sub("Txt_BattleMenu_";"BattleUI_") )
                | .value = {
                    it: {value}
                }
                | del(.value.it.SelfId)
                | .value.it = .value.it.value.Text
            )
        )
    else
        .
    end
    | from_entries
]
| reduce .[] as $obj ({}; . * $obj)

| {STT_Battle_UI: .}
```

## Output

```json

```

---

```js
map(
    .[].Rows
    | to_entries[]
    | select(.key | test("Monster_Name"))
    | if
        .key | test("_GERMAN")
    then
        .key = (.key | sub("_GERMAN";""))
        | .value = {"de": .value.ListNoun_N}
    elif
        .key | test("_ENGLISH")
    then
        .key = (.key | sub("_ENGLISH";""))
        | .value = {"en": .value.ListNoun}
    elif
        .key | test("_NEUTRALSPANISH")
    then
        .key = (.key | sub("_NEUTRALSPANISH";""))
        | .value = {"es": .value.ListNoun_N}
    elif
        .key | test("_FRENCH")
    then
        .key = (.key | sub("_FRENCH";""))
        | .value = {"fr": .value.ListNoun_N}
    elif
        .key | test("_ITALIAN")
    then
        .key = (.key | sub("_ITALIAN";""))
        | .value = {"it": .value.ListNoun_N}
    else
        .
    end
)
| group_by(.key)
| map(reduce .[] as $obj ({}; . * $obj))
| from_entries
```
