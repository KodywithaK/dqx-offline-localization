# pack_etp--KwK.py

- new argument added: `python pack_etp--KwK.py -L <language>`
  - Where `<language>` matches one from the new format (de, en, es, fr, it, ja, ko, zh-Hans, zh-Hant)
  - e.g.:
    - `python pack_etp--KwK.py -L en`, outputs english translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP_en**
    - `python pack_etp--KwK.py -L es`, outputs spanish translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP_es**
    - `python pack_etp--KwK.py -L ja`, outputs japanese translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP_ja**
    - etc.
  - Like the original `pack_etp.py`, it defaults to japanese, whenever translations are missing for a specific language.

---

# response_file--pakchunk0-WindowsNoEditor_EN_Latest.pak.txt

```bash
./UnrealEngine-4.27.2-release/Engine/Binaries/Linux/UnrealPak \
"../../../../actions-runner/_work/dqx-offline-localization/dqx-offline-localization/test/staging/pakchunk0-WindowsNoEditor_EN_Latest_P.pak" \
-Create="../../../../actions-runner/_work/dqx-offline-localization/dqx-offline-localization/test/staging/response_file--pakchunk0-WindowsNoEditor_EN_Latest.pak.txt"
```

<!--
- UnrealPak will exclude any mismatched directories, e.g.:
  - ```txt
    "source" "../../../destination"
    "Localization/Game/en" "../../../Localization/Game/ko"
    ```
    - ```bash
      LogPakFile: Display: Added 11 entries to add to pak file.
      LogPakFile: Display: Collecting files to add to pak file...
      LogPakFile: Display: Collected 10 files in 0.00s.
      ```
  - But renaming, source's foldername to match destination will properly create `.pak`
    - ```txt
      "source" "../../../destination"
      "Localization/Game/ko" "../../../Localization/Game/ko"
      which is actually ^^^ -> Localization/Game/en
      ```
      - ```bash
        LogPakFile: Display: Added 11 entries to add to pak file.
        LogPakFile: Display: Collecting files to add to pak file...
        LogPakFile: Display: Collected 11 files in 0.00s.
        ```
-->

---

# `.csv` > `.json`

## Input

- `FINAL/pakchunk0-Switch_P/Holiday/Content/StringTables/GAME/System/System_QuestList/STT_QuestListName.uasset.csv`

```json
Key,SourceString
SYSTEXT_QUESTLIST_NAME_AQ_001_1,"Seeking A Hermit's Remedy"
// ...
SYSTEXT_QUESTLIST_NAME_TQ_012_1,"Trendy Gadabout"
```

## JQ Query

```js
# jq -s -R
[
    split("\n")[]
    | sub(",";"???";"")
    | split("???")
]
| .[0] as $header
| .[1:]
| map(
    [$header, .]
    | transpose
    | map(
        {
            "key": (.[0]//""),
            "value": (.[1]//"")
            | sub("\\\\n";"\n";"g")
            #| sub("\\\"";"";"g")
            #| sub("\\\",";"")
        }
    )
    | from_entries
    | .value.["en"] = .SourceString
    | .value.["en"] = (.value.["en"] | sub("^\"";""))
    | .value.["en"] = (.value.["en"] | sub("\"$";""))
    | .value.["en"] = (.value.["en"] | sub("\\\\";"";"g"))
    | .value.["en"] = (.value.["en"] | sub("''";"\"";"g"))

    | del(.SourceString)
)
| from_entries
#| reduce . as $obj ({}; {"<Namespace>": $obj})
| reduce . as $obj ({}; {"STT_QuestListDetail": $obj})
|del(.[].[""])
```

## Output

```json
{
  "STT_QuestListName": {
    "SYSTEXT_QUESTLIST_NAME_AQ_001_1": {
      "en": "Seeking A Hermit's Remedy"
    },
    // ...
    "SYSTEXT_QUESTLIST_NAME_TQ_012_1": {
      "en": "Trendy Gadabout"
    }
  }
}
```

---

# `.csv` > `.json` > new format

## Input

- `Game.locres.json`
- `.csv` > `.json`

## JQ Query

```js
# jq -s
reduce .[] as $obj ({}; . * $obj)
# "Game.locres.json"
# "<CSV_TO_JSON>.json"
# > "output.json"
```

## Output

```json
{
  "STT_DaijinamonoItem": {
    "EXPLANATION_ID_ITEM_DAIJINAMONO_ADAMASUREZA": {
      "comments": "",
      "de": "",
      "en": "Very tough skin\neven scissors\ncan't cut.",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "ハサミでは\n切れないくらい\nとても丈夫な皮",
      "ko": "집게발로 자를 수\n없을 만큼 아주\n튼튼한 가죽",
      "zh-Hans": "用剪刀都剪不开\n非常结实的皮革",
      "zh-Hant": "用剪刀都剪不開\n非常結實的皮革"
    }
    // ...
  }
}
```

# Combine multiple `CSV_TO_JSON.json` files

## Input

- `Game.locres.json`
- `<CSV_TO_JSON's outputs>.json`

## JQ Query

```js
# jq --arg namespace "<CSV_TO_JSON's filename>" -s
# jq --arg namespace "STT_Battle_Levelup" -s
"reduce .[] as $obj ({}; . * $obj) | {$namespace: .[$namespace]}"
# "Game.locres.json"
# "<CSV_TO_JSON>_01.json"
# "<CSV_TO_JSON>_02.json"
# "<CSV_TO_JSON>_03.json"
# // ...
# or
# "<CSV_TO_JSON>*.json"
# > "output.json"
```

## Output

```js
{
  "STT_Battle_Levelup": {
    "SYSTXT_BATTLE_LEVELUP_00010": {
      "comments": "",
      "de": "",
      "en": "You learned a new skill!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "あたらしい\u3000特技を\u3000おぼえた！",
      "ko": "새로운 특기를 익혔다!",
      "zh-Hans": "学会了新的特技！",
      "zh-Hant": "習得了新的特技！"
    },
    "SYSTXT_BATTLE_LEVELUP_00020": {
      "comments": "",
      "de": "",
      "en": "You learned a new spell!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "あたらしい\u3000呪文を\u3000おぼえた！",
      "ko": "새로운 주문을 익혔다!",
      "zh-Hans": "学会了新的咒文！",
      "zh-Hant": "習得了新的咒文！"
    },
    "SYSTXT_BATTLE_LEVELUP_00030": {
      "comments": "",
      "de": "",
      "en": "You learned a new skill & spell!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "あたらしい\u3000特技と呪文を\u3000おぼえた！",
      "ko": "새로운 특기와 주문을 익혔다!",
      "zh-Hans": "学会了新的特技和咒文！",
      "zh-Hant": "習得了新的特技和咒文！"
    },
    "SYSTXT_BATTLE_LEVELUP_00040": {
      "comments": "",
      "de": "",
      "en": "Earned skill points",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "獲得スキルポイント",
      "ko": "획득 스킬 포인트",
      "zh-Hans": "获得技能点数",
      "zh-Hant": "獲得技能點數"
    },
    "SYSTXT_BATTLE_LEVELUP_00050": {
      "comments": "",
      "de": "",
      "en": "Total",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "現在",
      "ko": "현재",
      "zh-Hans": "现有",
      "zh-Hant": "現有"
    },
    "SYSTXT_BATTLE_LEVELUP_00060": {
      "comments": "",
      "de": "",
      "en": "{Character_Name} was promoted to level {Character_Level}!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "{Character_Name}は\u3000レベル{Character_Level}に\u3000あがった！",
      "ko": "{Character_Name}|hpp(은,는)\n{Character_Level} 레벨로 올랐다!",
      "zh-Hans": "{Character_Name}升到了{Character_Level}级！",
      "zh-Hant": "{Character_Name}提升至等級{Character_Level}了！"
    },
    "SYSTXT_BATTLE_LEVELUP_00070": {
      "comments": "",
      "de": "",
      "en": "{Character_Name} learned the {Spell_Name} spell!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "{Character_Name}は\u3000{Spell_Name}の呪文を覚えた！",
      "ko": "{Character_Name}|hpp(은,는) {Spell_Name} 주문을 익혔다!",
      "zh-Hans": "{Character_Name}学会了咒文{Spell_Name}！",
      "zh-Hant": "{Character_Name}習得了咒文「{Spell_Name}」！"
    },
    "SYSTXT_BATTLE_LEVELUP_00080": {
      "comments": "",
      "de": "",
      "en": "{Character_Name} learned the {Skill_Name} skill!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "{Character_Name}は\u3000{Skill_Name}の特技を覚えた！",
      "ko": "{Character_Name}|hpp(은,는) {Skill_Name} 특기를 익혔다!",
      "zh-Hans": "{Character_Name}学会了特技{Skill_Name}！",
      "zh-Hant": "{Character_Name}習得了特技「{Skill_Name}」！"
    },
    "SYSTXT_BATTLE_LEVELUP_00090": {
      "comments": "",
      "de": "",
      "en": "{SkillPoint} skill points were received!",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "{SkillPoint}Ｐの\u3000スキルポイントをかくとく！",
      "ko": "스킬 포인트 {SkillPoint}P를 획득했다!",
      "zh-Hans": "获得了{SkillPoint}点的技能点数！",
      "zh-Hant": "獲得了{SkillPoint}點的技能點數！"
    },
    "SYSTXT_BATTLE_LEVELUP_00100": {
      "comments": "",
      "de": "",
      "en": "Leveled up:",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "レベルが",
      "ko": "레벨이",
      "zh-Hans": "等级由",
      "zh-Hant": "等級由"
    },
    "SYSTXT_BATTLE_LEVELUP_00110": {
      "comments": "",
      "de": "",
      "en": "-->",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "から",
      "ko": "에서",
      "zh-Hans": "提升为",
      "zh-Hant": "提升為"
    },
    "SYSTXT_BATTLE_LEVELUP_00120": {
      "comments": "",
      "de": "",
      "en": "",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "にあがった！",
      "ko": "(으)로 올랐다!",
      "zh-Hans": "了！",
      "zh-Hant": "了！"
    }
  }
}
```

---
