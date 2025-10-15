<details><summary><h1>`.etp` - Old to New Format</h1></summary>

> # JQ Query
>
> ```js
> ####################################################################################################
> # Expected Input:
> # - <ETP_NAME>.etp.json (old format)
> # // ```json
> # // {
> # //   "key_01": {
> # //     "<value_ja_01>": "<value_en_01>"
> # //   },
> # //   "key_0": {
> # //     "<value_ja_02>": "<value_en_02>"
> # //   },
> # //   "key_0": {
> # //     "<value_ja_03>": "<value_en_03>"
> # //   }
> # // }
> # // ```
> # // For Example:
> # // ```json
> # // {
> # //   "19000000": {
> # //     "<voice 00480_19000000><start_lip_sync br01 _normal m00001>「姉ちゃーん！<stop_lip_animation br01 CLOSE_MOUTH>": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>Hey, sis!<stop_lip_animation br01 CLOSE_MOUTH>"
> # //   },
> # //   "19000002": {
> # //     "<voice 00480_19000002><start_lip_sync br01 _normal m00001>「兄ちゃーん！<stop_lip_animation br01 CLOSE_MOUTH>": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>Hey, bro!<stop_lip_animation br01 CLOSE_MOUTH>"
> # //   },
> # //   "19000005": {
> # //     "<voice 00480_19000005><start_lip_sync br01 _normal m00001>「<pc>ー！<stop_lip_animation br01 CLOSE_MOUTH>": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>!<stop_lip_animation br01 CLOSE_MOUTH>"
> # //   }
> # // }
> # // ```
> ####################################################################################################
> # old format .etp to new english only format
> # jq
> to_entries
> | map(
>     reduce . as $obj ({}; {
>         "key": $obj.["key"],
>         "value": {"en": $obj.["value"][]}
>     })
> )
> | from_entries
> ####################################################################################################
> # old format .etp to new multilingual format
> # // # jq
> # // to_entries
> # // | map(
> # //     reduce . as $obj ({}; {
> # //         "key": $obj.["key"],
> # //         "value": {
> # //             "comments": "",
> # //             "de": "",
> # //             "en": $obj.["value"][],
> # //             "es": "",
> # //             "fr": "",
> # //             "it": "",
> # //             "ja": ($obj.["value"] | keys[]),
> # //             "ko": "",
> # //             "zh-Hans": "",
> # //             "zh-Hant": ""
> # //         }
> # //     })
> # // )
> # // | from_entries
> ####################################################################################################
> # Expected Output:
> # // ```json
> # // {
> # //   "key_01": {
> # //     "en": "value_01"
> # //   },
> # //   "key_02": {
> # //     "en": "value_02"
> # //   },
> # //   "key_03": {
> # //     "en": "value_03"
> # //   }
> # // }
> # // ...
> # // ```
> # For Example:
> # // ```json
> # // {
> # //   "19000000": {
> # //     "en": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>Hey, sis!<stop_lip_animation br01 CLOSE_MOUTH>"
> # //   },
> # //   "19000002": {
> # //     "en": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>Hey, bro!<stop_lip_animation br01 CLOSE_MOUTH>"
> # //   },
> # //   "19000005": {
> # //     "en": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>!<stop_lip_animation br01 CLOSE_MOUTH>"
> # //   }
> # // }
> # // ...
> # // ```
> ####################################################################################################
> # Next Step:
> # Merge new `ETP_NAME.etp.json` into Main
> ####################################################################################################
> ```
> - Powershell
> ```ps
> jq "to_entries| map(reduce . as `$obj ({}; {`"key`": `$obj.[`"key`"],`"value`": {`"en`": `$obj.[`"value`"][]}}))| from_entries" "OLD.json" > "OUTPUT.json"
> ```
>
> </details>
>
> > <details><summary><h2>Merge new `ETP_NAME.etp.json` into Main</h2></summary>
> >
> > ## JQ Query
> >
> > ```js
> > ####################################################################################################
> > # Expected Input:
> > # - <ETP_NAME>.etp.json (new formats)
> > # // {
> > # //   "key_01": {
> > # //     "de": "",
> > # //     "en": "",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<value_ja_01>",
> > # //     "ko": "<value_ko_01>",
> > # //     "zh-Hans": "<value_zh-Hans_01>",
> > # //     "zh-Hant": "<value_zh-Hant_01>",
> > # //   },
> > # //   "key_02": {
> > # //     "de": "",
> > # //     "en": "",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<value_ja_02>",
> > # //     "ko": "<value_ko_02>",
> > # //     "zh-Hans": "<value_zh-Hans_02>",
> > # //     "zh-Hant": "<value_zh-Hant_02>",
> > # //   },
> > # //   "key_03": {
> > # //     "de": "",
> > # //     "en": "",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<value_ja_03>",
> > # //     "ko": "<value_ko_03>",
> > # //     "zh-Hans": "<value_zh-Hans_03>",
> > # //     "zh-Hant": "<value_zh-Hant_03>",
> > # //   }
> > # // }
> > # // {
> > # //   "key_01": {
> > # //     "en": "<value_en_01>"
> > # //   },
> > # //   "key_02": {
> > # //     "en": "<value_en_03>"
> > # //   },
> > # //   "key_03": {
> > # //     "ja": "<value_en_02>"
> > # //   }
> > # // }
> > # For Example:
> > # // {
> > # //   "19000000": {
> > # //     "de": "",
> > # //     "en": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>Hey, sis!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>「姉ちゃーん！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "ko": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>: 누나~!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hans": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>姐姐！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hant": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>姊姊──！<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   },
> > # //   "19000002": {
> > # //     "de": "",
> > # //     "en": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>Hey, bro!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>「兄ちゃーん！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "ko": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>: 형~!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hans": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>哥哥！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hant": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>哥哥──！<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   },
> > # //   "19000005": {
> > # //     "de": "",
> > # //     "en": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<voice 00480_19000005><start_lip_sync br01 _normal m00001>「<pc>ー！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "ko": "<voice 00480_19000005><start_lip_sync br01 _normal m00001>: <pc>~!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hans": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hant": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>──！<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   }
> > # // }
> > # //
> > # // {
> > # //   "19000000": {
> > # //     "en": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>Hey, sis!<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   },
> > # //   "19000002": {
> > # //     "en": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>Hey, bro!<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   },
> > # //   "19000005": {
> > # //     "en": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>!<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   }
> > # // }
> > # // ...
> > ####################################################################################################
> > # jq -s
> > reduce .[] as $obj ({}; . * $obj)
> > ####################################################################################################
> > # Expected Output:
> > # // {
> > # //   "key_01": {
> > # //     "de": "",
> > # //     "en": "<value_en_01>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<value_ja_01>",
> > # //     "ko": "<value_ko_01>",
> > # //     "zh-Hans": "<value_zh-Hans_01>",
> > # //     "zh-Hant": "<value_zh-Hant_01>",
> > # //   },
> > # //   "key_02": {
> > # //     "de": "",
> > # //     "en": "<value_en_02>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<value_ja_02>",
> > # //     "ko": "<value_ko_02>",
> > # //     "zh-Hans": "<value_zh-Hans_02>",
> > # //     "zh-Hant": "<value_zh-Hant_02>",
> > # //   },
> > # //   "key_03": {
> > # //     "de": "",
> > # //     "en": "<value_en_03>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<value_ja_03>",
> > # //     "ko": "<value_ko_03>",
> > # //     "zh-Hans": "<value_zh-Hans_03>",
> > # //     "zh-Hant": "<value_zh-Hant_03>",
> > # //   }
> > # // }
> > # For Example:
> > # // {
> > # //   "19000000": {
> > # //     "de": "",
> > # //     "en": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>Hey, sis!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>「姉ちゃーん！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "ko": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>: 누나~!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hans": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>姐姐！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hant": "<voice 00480_19000000><start_lip_sync br01 _normal m00001>姊姊──！<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   },
> > # //   "19000002": {
> > # //     "de": "",
> > # //     "en": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>Hey, bro!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>「兄ちゃーん！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "ko": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>: 형~!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hans": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>哥哥！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hant": "<voice 00480_19000002><start_lip_sync br01 _normal m00001>哥哥──！<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   },
> > # //   "19000005": {
> > # //     "de": "",
> > # //     "en": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "es": "",
> > # //     "fr": "",
> > # //     "it": "",
> > # //     "ja": "<voice 00480_19000005><start_lip_sync br01 _normal m00001>「<pc>ー！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "ko": "<voice 00480_19000005><start_lip_sync br01 _normal m00001>: <pc>~!<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hans": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>！<stop_lip_animation br01 CLOSE_MOUTH>",
> > # //     "zh-Hant": "<voice 00480_19000005><start_lip_sync br01 _normal m00001><pc>──！<stop_lip_animation br01 CLOSE_MOUTH>"
> > # //   }
> > # // }
> > ####################################################################################################
> > ```
> > - Powershell
> > ```ps
> > jq -s "reduce .[] as `$obj ({}; . * `$obj)" "NEW.json" "OUTPUT.json" > "MAIN.json"
> > ```
> > </details>



---

<details><summary><h1>`StringTable.csv` to `StringTable.json`</h1></summary>

> # JQ Query
>
> ```js
> ####################################################################################################
> # Expected Input:
> # // ```csv
> # // Key,SourceString
> # // key_01,"value_01"
> # // key_02,"value_02"
> # For Example:
> # // ```csv
> # // Key,SourceString
> # // SYSTXT_BOUKENNOSHO_00010,"Venture, Forth"
> # // SYSTXT_BOUKENNOSHO_00020,"Create, """Adventure Log""""
> # // ```
> ####################################################################################################
> # jq -R
> split(",(?=(SourceString|\".*))"; null) # // Split after first comma
> | .[] = {
>             "key": .[0],
>             "value": ({"<LANGUAGE>":
>                 .[1]
>                 | sub("(^\\\"|\\\"$)";"";"g") # // Fix 'jq -R' (raw input) start & end double-quotes
>                 #| sub("\\\\n";"\n";"g") # // Fix newlines
>                 | sub("(\\\\\"|\"\")";"\"";"g") # // Fix double-quotes
>             })
>         }
> | from_entries
> ####################################################################################################
> # Expected Output:
> # // ```json
> # // {
> # //   "Key": {
> # //     "<LANGUAGE>": "SourceString"
> # //   }
> # // }
> # // {
> # //   "key_01": {
> # //     "<LANGUAGE>": "value_01"
> # //   }
> # // }
> # // {
> # //   "key_02": {
> # //     "<LANGUAGE>": "value_02"
> # //   }
> # // }
> # // ...
> # // ```
> # For Example:
> # // ```json
> # // {
> # //   "Key": {
> # //     "<LANGUAGE>": "SourceString"
> # //   }
> # // }
> # // {
> # //   "SYSTXT_BOUKENNOSHO_00010": {
> # //     "<LANGUAGE>": "Venture Forth"
> # //   }
> # // }
> # // {
> # //   "SYSTXT_BOUKENNOSHO_00020": {
> # //     "<LANGUAGE>": "Create \"Adventure\" \"Log\""
> # //   }
> # // }
> # // ...
> # // ```
> ####################################################################################################
> # Next Step:
> # Fix `StringTable.json`
> ####################################################################################################
> ```
>
> ---
>
> </details>

> <details><summary><h2>Fix `StringTable.json`</h2></summary>
>
> > ## JQ Query
> >
> > - `jq` does not have a convenient way of combining/"slurping" the output from the previous step (yet?), so a second command is needed.
> >
> > ```js
> > ####################################################################################################
> > # Expected Input:
> > # // ```json
> > # // {
> > # //   "Key": {
> > # //     "<LANGUAGE>": "SourceString"
> > # //   }
> > # // }
> > # // {
> > # //   "key_01": {
> > # //     "<LANGUAGE>": "value_01"
> > # //   }
> > # // }
> > # // {
> > # //   "key_02": {
> > # //     "<LANGUAGE>": "value_02"
> > # //   }
> > # // }
> > # // ...
> > # // ```
> > # For Example:
> > # // ```json
> > # // {
> > # //   "Key": {
> > # //     "<LANGUAGE>": "SourceString"
> > # //   }
> > # // }
> > # // {
> > # //   "SYSTXT_BOUKENNOSHO_00010": {
> > # //     "<LANGUAGE>": "Venture Forth"
> > # //   }
> > # // }
> > # // {
> > # //   "SYSTXT_BOUKENNOSHO_00020": {
> > # //     "<LANGUAGE>": "Create \"Adventure\" \"Log\""
> > # //   }
> > # // }
> > # // ...
> > # // ```
> > ####################################################################################################
> > # jq -s
> > add
> > | del(.Key)
> > | . as $output
> > | {"<StringTable Name>": $output}
> > # For Example: // | {"STT_System_Title": $output}
> > ####################################################################################################
> > # Expected Output:
> > # // ```json
> > # // {
> > # //   "<StringTable Name>": {
> > # //     "key_01": {
> > # //       "<LANGUAGE>": "value_01"
> > # //     },
> > # //     "key_02": {
> > # //       "<LANGUAGE>": "value_02"
> > # //     }
> > # //     ...
> > # //   }
> > # // }
> > # For Example:
> > # // ```json
> > # // {
> > # //   "STT_System_Title": {
> > # //     "SYSTXT_BOUKENNOSHO_00010": {
> > # //       "<LANGUAGE>": "Venture Forth"
> > # //     },
> > # //     "SYSTXT_BOUKENNOSHO_00020": {
> > # //       "<LANGUAGE>": "Create \"Adventure\" \"Log\""
> > # //     }
> > # //     ...
> > # //   }
> > # // }
> > # // ```
> > ####################################################################################################
> > # Next Step:
> > # Combine with `Game.locres.json`
> > ####################################################################################################
> > ```
>
> ---
>
> </details>

<details><summary><h1>`StringTable.json` to `StringTable.csv`</h1></summary>

> - For translating via `pakchunk#-<PLATFORM>.ucas/<PROJECT_NAME>/Content/StringTables/Game/**/<StringTable>.uasset` in Unreal Engine's UE4Editor
>
> # JQ Query
>
> ```js
> ####################################################################################################
> # Expected Input:
> # // ```json
> # // {
> # //   "<StringTable Name>": {
> # //     "key_01": {
> # //       "<LANGUAGE>": "value_01"
> # //     },
> # //     "key_02": {
> # //       "<LANGUAGE>": "value_02"
> # //     }
> # //     ...
> # //   }
> # // }
> # For Example:
> # // ```json
> # // {
> # //   "STT_System_Title": {
> # //     "SYSTXT_BOUKENNOSHO_00010": {
> # //       "<LANGUAGE>": "Venture Forth"
> # //     },
> # //     "SYSTXT_BOUKENNOSHO_00020": {
> # //       "<LANGUAGE>": "Create \"Adventure\" \"Log\""
> # //     }
> # //     ...
> # //   }
> # // }
> # // ```
> ####################################################################################################
> # jq -r
> "Key,SourceString",
> (
>     .[]
>     | to_entries
>     | map(
>         .value = (
>             .value[]
>         )
>         | "\(.key),\"\(
>             .value
>             | sub("\n";"\\n";"g")
>             | sub("\"";"\"\"";"g")
>         )\""
>     )
> )[]
> ####################################################################################################
> # Expected Output:
> # // ```csv
> # // Key,SourceString
> # // key_01,"value_01"
> # // key_02,"value_02"
> # // ...
> # // ```
> # For Example:
> # // ```csv
> # // Key,SourceString
> # // SYSTXT_BOUKENNOSHO_00010,"Venture Forth"
> # // SYSTXT_BOUKENNOSHO_00020,"Create\n""Adventure"" ""Log"""
> # // ...
> # // ```
> ####################################################################################################
> # Next Step:
> # - `import csv` into Unreal Engine project's StringTables
> ####################################################################################################
> ```
>
> ---
>
> </details>

<details><summary><h1>`StringTable.json` to `Game.locres.json`</h1></summary>

> - For translating via `pakchunk0-<PLATFORM>.pak/<PROJECT_NAME>/Content/Localization/Game/<LANGUAGE>/Game.locres` with LocRes-Builder
>
> ## JQ Query
>
> ```js
> ####################################################################################################
> # Expected Input:
> # // ```json
> # // {
> # //   "<StringTable Name>": {
> # //     "key_01": {
> # //       "<LANGUAGE>": "value_01"
> # //     },
> # //     "key_02": {
> # //       "<LANGUAGE>": "value_02"
> # //     }
> # //     ...
> # //   }
> # // }
> # For Example:
> # // {
> # //   "STT_CareerStoryVer1": {
> # //     "SYSTXT_CAREER_STORY_ATH1_001": {
> # //       "comments": "",
> # //       "de": "",
> # //       "en": "One day, {PC} woke up to find that\n{Brother_Name} had failed at an alchemy recipe\nand had turned the village supply of Pep Beans into ashes.\n{PC} was sent to Abba's house to apologize to\nher on behalf of {Zokugara}. It seems that\nAbba's house is on the hill beyond the bridge.",
> # //       "es": "",
> # //       "fr": "",
> # //       "it": "",
> # //       "ja": "ある日\u3000{PC}が\u3000目を覚ますと\n{Brother_Name}が\u3000錬金術に失敗して\n大事なハツラツ豆を灰にしてしまったと\n騒ぎになっていた。\n家に上がってきた\u3000村人に\u3000{Zokugara}の代わりに\nアバさまに謝ってこい！\u3000と言われた。\nアバの家は\u3000橋向こうの高台にあるらしい。",
> # //       "ko": "어느 날 {PC}|hpp(이,가) 눈을 뜨자\n{Brother_Name}의 연금술이 실패하는 바람에\n소중한 활력의 콩이 잿더미가 되었다며\n난리가 난 상태였다.\n집으로 찾아온 마을 주민은 {Brother_Name}|hpp(을,를)\n대신해서 아바 님께 사과하고 오라고 했다.\n아바의 집은 다리 건너 언덕에 있다 한다.",
> # //       "zh-Hans": "有一天，{PC}一觉醒来，\n发现{Brother_Name}因为炼金术失败\n而把重要的活力豆毁掉了，\n这件事在村里引起了骚动。\n一位村民来到家里，\n要求代替{Zokugara}向阿巴大人道歉。\n阿巴的家似乎就在桥对面的高地上。",
> # //       "zh-Hant": "有一天，{PC}一覺醒來，\n發現{Brother_Name}因為鍊金術失敗\n而把重要的活力豆毀掉了，\n這件事在村裡引起了騷動。\n一位村民來到家裡，\n要求代替{Zokugara}去向阿巴大人道歉。\n阿巴的家似乎就在橋對面的高地上。"
> # //     },
> # //     "SYSTXT_CAREER_STORY_ATH1_002": {
> # //       "comments": "",
> # //       "de": "",
> # //       "en": "When {PC} arrived at Abba's house\nthey met with Abba's grandson, Shini.\nHe said that she has been feeling depressed\nlately but he has a plan to help her feel\nbetter. Shini has asked us to bring him some\nDried Antidotal Herb and Fluffy Rice Husk.",
> # //       "es": "",
> # //       "fr": "",
> # //       "it": "",
> # //       "ja": "アバの家に\u3000謝りにいくと\u3000アバは\n部屋に閉じこもっており\u3000応対したのは\nアバの孫のシンイだった。\nシンイは\u3000灰になったハツラツ豆の代わりに\nフカフカのもみガラと\u3000干しどくけし草を\n持ってきてほしい！\u3000と頼んできた。\nアバは\u3000最近\u3000ふさぎ込んでいるらしい。",
> # //       "ko": "아바의 집에 사과하러 갔지만 아바는\n방에 틀어박힌 상태였고, 대신 \n아바의 손자인 신이가 맞이해 주었다.\n신이는 잿더미가 된 활력의 콩 대신에\n말랑한 겉겨와 말린 해독초를\n가져와 달라고 부탁했다.\n아바는 요즘 몹시 울적해한다는 것 같다.",
> # //       "zh-Hans": "前往阿巴的家道歉，\n却发现阿巴闷在屋子里，\n只见到了阿巴的孙子辛依。\n受辛依委托将软软的谷壳和\n晒干的解毒草拿来，\n补偿变为灰烬的活力豆。\n阿巴最近似乎精神不太好。",
> # //       "zh-Hant": "前往阿巴的家道歉，\n卻發現阿巴悶在屋子裡，\n只見到了阿巴的孫子辛伊。\n受辛伊委託\n將鬆軟穀殼和曬乾的解毒草\n拿來，補償變為灰燼的活力豆。\n阿巴最近似乎精神不太好。"
> # //     }
> # //   }
> # // }
> ####################################################################################################
> # jq
> . as {$STT_CareerStoryVer1: {$key: $values}}
> | {STT_CareerStoryVer1: (
>     $STT_CareerStoryVer1
>     # // delete all languages—except the target—to not accidentally overwrite `Game.locres.json`'s other fields later
>     | del(.[].[
>         "comments",
>         "de",
>         #"en",
>         "es",
>         "fr",
>         "it",
>         "ja",
>         "ko",
>         "zh-Hans",
>         "zh-Hant"
>     ])
> )}
> ####################################################################################################
> # Expected Output:
> # // {
> # //   "STT_CareerStoryVer1": {
> # //     "SYSTXT_CAREER_STORY_ATH1_001": {
> # //       "en": "One day, {PC} woke up to find that\n{Brother_Name} had failed at an alchemy recipe\nand had turned the village supply of Pep Beans into ashes.\n{PC} was sent to Abba's house to apologize to\nher on behalf of {Zokugara}. It seems that\nAbba's house is on the hill beyond the bridge."
> # //     },
> # //     "SYSTXT_CAREER_STORY_ATH1_002": {
> # //       "en": "When {PC} arrived at Abba's house\nthey met with Abba's grandson, Shini.\nHe said that she has been feeling depressed\nlately but he has a plan to help her feel\nbetter. Shini has asked us to bring him some\nDried Antidotal Herb and Fluffy Rice Husk."
> # //     }
> # //   }
> # // }
> ####################################################################################################
> ```
>
> ---
>
> ## JQ Query
>
> ```js
> ####################################################################################################
> # Expected Input:
> # - `Game.locres.json`
> # - `StringTable.json`
> #   - single language
> # // ```json
> # // {
> # //   "<StringTable Name>": {
> # //     "key_01": {
> # //       "<LANGUAGE>": "value_01"
> # //     },
> # //     "key_02": {
> # //       "<LANGUAGE>": "value_02"
> # //     }
> # //     ...
> # //   }
> # // }
> # For Example:
> # // {
> # //   "STT_CareerStoryVer1": {
> # //     "SYSTXT_CAREER_STORY_ATH1_001": {
> # //       "en": "One day, {PC} woke up to find that\n{Brother_Name} had failed at an alchemy recipe\nand had turned the village supply of Pep Beans into ashes.\n{PC} was sent to Abba's house to apologize to\nher on behalf of {Zokugara}. It seems that\nAbba's house is on the hill beyond the bridge.",
> # //     },
> # //     "SYSTXT_CAREER_STORY_ATH1_002": {
> # //       "en": "When {PC} arrived at Abba's house\nthey met with Abba's grandson, Shini.\nHe said that she has been feeling depressed\nlately but he has a plan to help her feel\nbetter. Shini has asked us to bring him some\nDried Antidotal Herb and Fluffy Rice Husk.",
> # //     }
> # //   }
> # // }
> # // ```
> ####################################################################################################
> # jq -s
> reduce .[] as $object ({}; . * $object)
> ####################################################################################################
> # Expected Output:
> # // {
> # //   "<StringTable Name": {
> # //     "key_01": {
> # //       "<LANGUAGE>": "value_01"
> # //     },
> # //     "key_01": {
> # //       "<LANGUAGE>": "value_01"
> # //     },
> # //     ...
> # //   }
> # // }
> # For Example:
> # // {
> # //   "STT_CareerStoryVer1": {
> # //     "SYSTXT_CAREER_STORY_ATH1_001": {
> # //       "en": "One day, {PC} woke up to find that\n{Brother_Name} had failed at an alchemy recipe\nand had turned the village supply of Pep Beans into ashes.\n{PC} was sent to Abba's house to apologize to\nher on behalf of {Zokugara}. It seems that\nAbba's house is on the hill beyond the bridge."
> # //     },
> # //     "SYSTXT_CAREER_STORY_ATH1_002": {
> # //       "en": "When {PC} arrived at Abba's house\nthey met with Abba's grandson, Shini.\nHe said that she has been feeling depressed\nlately but he has a plan to help her feel\nbetter. Shini has asked us to bring him some\nDried Antidotal Herb and Fluffy Rice Husk."
> # //     }
> # //   }
> # // }
> ####################################################################################################
> ```
>
> ---
>
> </details>

> [!TIP]
>
> <details><summary><h1>`DRAGON QUEST III HD-2D Remake\**\Game-WindowsNoEditor.pak\**\DataTable\Text\**\*`</h1></summary>
>
> ## JQ
>
> - Get `.Text` of all files and languages
> ```cmd
> R:\Exports\Game\Content\Nicola\Data\DataTable\Text>FOR /F "usebackq delims=" %E IN (`dir /b .\en\`) DO mkdir "R:\Temp\%~nE\" && FOR %F IN (cn de en es es-419 fr it jp jp-hi ko tw) DO jq "{\"%~nE\": ( .[].Rows as $obj | reduce ($obj | keys_unsorted)[] as $k ( {}; .[$k] += { \"%F\": $obj[$k].Text} ) )}" "R:\Exports\Game\Content\Nicola\Data\DataTable\Text\%F\%~nE.json" > R:\Temp\%~nE\%~nE.json.%F
> ```
> 
> - Merge all files and languages
> ```cmd
> R:\Temp>FOR /F "usebackq delims=" %E IN (`dir /b`) DO FOR /F "usebackq tokens=1,2,3,4,5,6,7,8,9,10,11,12 delims= " %F IN (`@ECHO %E\%E.json cn de en es es-419 fr it jp jp-hi ko tw`) DO jq -s "reduce .[] as $item ({}; . * $item)" %F.%G %F.%H %F.%I %F.%J %F.%K %F.%L %F.%M %F.%N %F.%O %F.%P %F.%Q > "%E\! %E.json"
> ```
> 
> - Get `.Text` of all languages
> ```cmd
> FOR %F IN (cn de en es es-419 fr it jp jp-hi ko tw) DO jq "{\"GOP_Text_FieldMenu\": ( .[].Rows as $obj | reduce ($obj | keys_unsorted)[] as $k ( {}; .[$k] += { \"%F\": $obj[$k].Text} ) )}" GOP_Text_FieldMenu.json.%F > "JQ\GOP_Text_FieldMenu.json.%F"
> ```
> 
> - Merge all languages
> ```cmd
> FOR /F "usebackq tokens=1,2,3,4,5,6,7,8,9,10,11,12 delims= " %F IN (`@ECHO GOP_Text_FieldMenu.json cn de en es es-419 fr it jp jp-hi ko tw`) DO jq -s "reduce .[] as $item ({}; . * $item)" %F.%G %F.%H %F.%I %F.%J %F.%K %F.%L %F.%M %F.%N %F.%O %F.%P %F.%Q > "! %F"
> ```
> 
> ## Output
> 
> ```json
> {
>   "GOP_Text_FieldMenu": {
>     "Txt_FieldMenu_Common_YES": {
>       "cn": "是",
>       "de": "Ja",
>       "en": "Yes",
>       "es": "Sí",
>       "es-419": "Sí",
>       "fr": "Oui",
>       "it": "Sì",
>       "jp": "はい",
>       "jp-hi": "はい",
>       "ko": "예",
>       "tw": "是"
>     },
>     "Txt_FieldMenu_Common_NO": {
>       "cn": "否",
>       "de": "Nein",
>       "en": "No",
>       "es": "No",
>       "es-419": "No",
>       "fr": "Non",
>       "it": "No",
>       "jp": "いいえ",
>       "jp-hi": "いいえ",
>       "ko": "아니요",
>       "tw": "否"
>     },
>     // ...
>     "Txt_FieldMenu_Queen_Message_WARP": {
>       "cn": "女王陛下没有离开罗马利亚的需要。",
>       "de": "Für die Königin gibt es keinen Anlass, Romaria zu verlassen. Irgendwer muss schließlich den Thron warmhalten<nbsp>...",
>       "en": "There's no need for Her Majesty to leave Romaria. Who would be queen in her stead?",
>       "es": "Su majestad no tiene por qué marcharse de Romaria. ¿Quién ocuparía su cargo?",
>       "es-419": "No hay necesidad de que Su Majestad abandone Romaria. ¿Quién sería reina en su lugar?",
>       "fr": "Il n'est nul besoin que Sa Majesté quitte Romalie. Qui régnerait à sa place?",
>       "it": "Non occorre che Sua Maestà lasci Romaria. Chi regnerebbe al suo posto?",
>       "jp": "<RUBY>女王[じょおう]さまは　ロマリアから<RUBY>出[で]る<RUBY>必要[ひつよう]がない。",
>       "jp-hi": "じょおうさまは　ロマリアからでるひつようがない。",
>       "ko": "여왕은 로마리아에서 나갈 필요가 없다.",
>       "tw": "女王不必離開羅馬利亞。"
>     }
>   }
> }
> ```
> 
> </details>

> [!TIP]
>
> <details><summary><h1>Merge DQ3make DataTables & Game.locres.json by keys</h1></summary>
>
> ####################################################################################################
>
> # Input
>
> - {`DQ3make`: {`TEXT_NOUN_<ALL LANGUAGES>:TEXT_NOUN_Monster_Name_*`}}
> - `Game.locres.json`: `STT_BattleMonsterName`
>   ####################################################################################################
>
> # JQ Query
>
> ```js
> # jq -n -S
> [
>     inputs[]
>     | to_entries
>     | map(
>         .key as $k
>         | .value = (
>             .value
>             | .key = $k
>         )
>     )[]
> ]
> | group_by(
>     .value.en
> )
> | map(
> 	.[0].key = .[1].key
>     | .[0]
>     | select(.key != null)
>     | select(.value | has("de"))
>     | del(.value.["key","RubyText","Text"])
> )
> | from_entries
> | {STT_BattleMonsterName: .}
> ```
>
> ####################################################################################################
>
> # Output
>
> ```json
> {
>   "STT_BattleMonsterName": {
>     "ID_MONSTER_NAME_00100": {
>       "SelfId": "TEXT_NOUN_Monster_Name_Slime",
>       "de": "Schleim",
>       "en": "Slime",
>       "es": "Limo",
>       "fr": "Gluant",
>       "it": "Slime"
>     },
>     "ID_MONSTER_NAME_00101": {
>       "SelfId": "TEXT_NOUN_Monster_Name_Sheslime",
>       "de": "Schleimette",
>       "en": "She-Slime",
>       "es": "Lima",
>       "fr": "Gluante",
>       "it": "Slime arancione"
>     }
>     // ...
>   }
> }
> ```
>
> ####################################################################################################
>
> ---
>
> </details>

> [!TIP]
>
> <details><summary><h1>Import Names from DQXIS to `Game.locres.json`</h1></summary>
>
> ## JQ Query
>
> ```js
> ####################################################################################################
> # Expected Input:
> # - `Game.locres.json:<Namespace>`
> # - `DQXIS_Localize.db_ListNoun.json`
> # // ```json
> # // {
> # //     "key_01": {
> # //       "comments": "",
> # //       "de": "",
> # //       "en": "<en>",
> # //       "es": "",
> # //       "fr": "",
> # //       "it": "",
> # //       "ja": "<ja>",
> # //       "ko": "<ko>",
> # //       "zh-Hans": "<zh-Hans>",
> # //       "zh-Hant": "<zh-Hant>"
> # //     },
> # //     "key_02": {
> # //       "comments": "",
> # //       "de": "",
> # //       "en": "<en>",
> # //       "es": "",
> # //       "fr": "",
> # //       "it": "",
> # //       "ja": "<ja>",
> # //       "ko": "<ko>",
> # //       "zh-Hans": "<zh-Hans>",
> # //       "zh-Hant": "<zh-Hant>"
> # //     }
> # //     ...
> # //   }
> # For Example:
> # // {
> # //     "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_DOUNOTSURUGI": {
> # //       "comments": "",
> # //       "de": "",
> # //       "en": "Copper Sword",
> # //       "es": "",
> # //       "fr": "",
> # //       "it": "",
> # //       "ja": "どうのつるぎ",
> # //       "ko": "구리 검",
> # //       "zh-Hans": "铜剑",
> # //       "zh-Hant": "銅劍"
> # //     },
> # //     "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_ETENENOKEN": {
> # //       "comments": "",
> # //       "de": "Etheneschwert",
> # //       "en": "Ethene Sword",
> # //       "es": "Espada de Ethene",
> # //       "fr": "Épée de Ethene",
> # //       "it": "Spada di Ethene",
> # //       "ja": "エテーネの剣",
> # //       "ko": "에테네의 검",
> # //       "zh-Hans": "伊甸之剑",
> # //       "zh-Hant": "伊甸之劍"
> # //     }
> # //     ...
> # // }
> # // {
> # //   "TXT_ITEM_NAME_W_SWD_0002": {
> # //     "de": "Kupferschwert",
> # //     "en": "Copper Sword",
> # //     "es": "Espada de cobre",
> # //     "fr": "Épée de cuivre",
> # //     "it": "Spada di rame"
> # //   },
> # //   "TXT_ITEM_NAME_W_SWD_0003": {
> # //     "de": "Soldatenschwert",
> # //     "en": "Soldier's Sword",
> # //     "es": "Espada de soldado",
> # //     "fr": "Épée de soldat",
> # //     "it": "Spada del soldato"
> # //   },
> # //   "TXT_ITEM_NAME_W_SWD_0004": {
> # //     "de": "Bronzeschwert",
> # //     "en": "Bronze Sword",
> # //     "es": "Espada de bronce",
> # //     "fr": "Épée de bronze",
> # //     "it": "Spada di bronzo"
> # //   }
> # //   ...
> # // }
> # // ```
> ####################################################################################################
> # js -s
> [
>     [
>         .[]
>         | to_entries[]
>     ]
>     | group_by(.value.en)[]
>     | if (.[1] != null)
>       then
>         (
>             .[0].value.de = .[1].value.de
>             | .[0].value.es = .[1].value.es
>             | .[0].value.fr = .[1].value.fr
>             | .[0].value.it = .[1].value.it
>             | del(.[1])
>         )
>       else (.)
>       end
>     | select(.[].key | match("NAME_ID_.*"))
>     | from_entries
> ]
> ####################################################################################################
> # Expected Output:
> # // [
> # //   {
> # //     "key_01": {
> # //       "comments": "",
> # //       "de": "<de>",
> # //       "en": "<en>",
> # //       "es": "<es>",
> # //       "fr": "<fr>",
> # //       "it": "<it>",
> # //       "ja": "<ja>",
> # //       "ko": "<ko>",
> # //       "zh-Hans": "<zh-Hans>",
> # //       "zh-Hant": "<zh-Hant>"
> # //     },
> # //     "key_02": {
> # //       "comments": "",
> # //       "de": "<de>",
> # //       "en": "<en>",
> # //       "es": "<es>",
> # //       "fr": "<fr>",
> # //       "it": "<it>",
> # //       "ja": "<ja>",
> # //       "ko": "<ko>",
> # //       "zh-Hans": "<zh-Hans>",
> # //       "zh-Hant": "<zh-Hant>"
> # //     }
> # //     ...
> # //   }
> # // ]
> # For Example:
> # // [
> # //   {
> # //     "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_DOUNOTSURUGI": {
> # //       "comments": "",
> # //       "de": "Kupferschwert",
> # //       "en": "Copper Sword",
> # //       "es": "Espada de cobre",
> # //       "fr": "Épée de cuivre",
> # //       "it": "Spada di rame",
> # //       "ja": "どうのつるぎ",
> # //       "ko": "구리 검",
> # //       "zh-Hans": "铜剑",
> # //       "zh-Hant": "銅劍"
> # //     }
> # //   },
> # //   {
> # //     "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_ETENENOKEN": {
> # //       "comments": "",
> # //       "de": "Etheneschwert",
> # //       "en": "Ethene Sword",
> # //       "es": "Espada de Ethene",
> # //       "fr": "Épée de Ethene",
> # //       "it": "Spada di Ethene",
> # //       "ja": "エテーネの剣",
> # //       "ko": "에테네의 검",
> # //       "zh-Hans": "伊甸之剑",
> # //       "zh-Hant": "伊甸之劍"
> # //     }
> # //   }
> # // ]
> ####################################################################################################
> # Next Steps:
> # - Copy everything in the array to the appropriate `Game.locres.json` namespace
> # - Merge new `Game.locres.json` into Main
> ####################################################################################################
> ```
>
> ---
>
> </details>

<details><summary><h1>TBD</h1></summary>

<!--

<details><summary><h1>TEMPLATE</h1></summary>

# Input

```json

```

# JQ Query

```js

```

# Output

```json

```

</details>

-->

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

<details><summary><h1>group_by(JAPANESE) & Combine</h1></summary>

## Input

- `Game.locres.json`
- Combined `GOP_Text_Noun_<LANGUAGE>` DataTables

```json
{
    // ...
    "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_DORAGONKIRA": {
      "comments": "",
      "de": "",
      "en": "",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "ドラゴンキラー",
      "ko": "드래곤 킬러",
      "zh-Hans": "斩龙剑",
      "zh-Hant": "斬龍劍"
    },
    "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_DOUNOTSURUGI": {
      "comments": "",
      "de": "",
      "en": "",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "どうのつるぎ",
      "ko": "구리 검",
      "zh-Hans": "铜剑",
      "zh-Hant": "銅劍"
    },
    "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_ETENENOKEN": {
      "comments": "",
      "de": "",
      "en": "",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "エテーネの剣",
      "ko": "에테네의 검",
      "zh-Hans": "伊甸之剑",
      "zh-Hant": "伊甸之劍"
    }
    // ...
}
{
      // ...
      "TEXT_NOUN_JAPANESE_Item_Name_Copper_Sword": {
        "SelfId": "TEXT_NOUN_JAPANESE_Item_Name_Copper_Sword",
        "Text": "どうのつるぎ",
        "RubyText": "Copper Sword"
      },
      "TEXT_NOUN_JAPANESE_Item_Name_Steel_Broadsword": {
        "SelfId": "TEXT_NOUN_JAPANESE_Item_Name_Steel_Broadsword",
        "Text": "はがねのつるぎ",
        "RubyText": "はがねのつるぎ"
      },
      "TEXT_NOUN_JAPANESE_Item_Name_Slapstick": {
        "SelfId": "TEXT_NOUN_JAPANESE_Item_Name_Slapstick",
        "Text": "はがねのはりせん",
        "RubyText": "はがねのはりせん"
      },
      "EXAMPLE": {
        "Text": "エテーネの剣",
        "RubyText": "Ethenian Sword"
      }
      // ...
}
```

## JQ Query

<!-- V1
```bash
# jq -n
[input[],input[]]
| group_by(.["ja"] // .["Text"])
| map(
    if ( .[1] )
    then
        .[0].["en"] = .[1].["RubyText"]
    else .
    end
)
```
-->

<!-- V2
```js
# jq -n
[
  [
    input
    | (
      .
      | to_entries
      | map(.value.key = .key)
      | from_entries
      )[], input[]
  ]
  | group_by(.["ja"] // .["Text"])
  | map(
      if ( .[1] )
      then
          #.[0].["de"] = .[1].["de"]
          .[0].["en"] = .[1].["RubyText"]
      else .
      end
  )
  [][]
  | select(has("key"))
  | walk(
      if type == "object" and has("key")
      then ([. = {key, value: . } | del(.value.key) ]| from_entries)
      else .
      end
  )
]
```
-->

```json
[input
| (
.
| to_entries
| map(.value.key = .key)
| from_entries
)[]
,input[]]
| group_by(.["ja"] // .["Text"])
| map(
if ( .[1] )
then(
  .[0].["de"] = .[1].["de"]
| .[0].["en"] = .[1].["en"]
| .[0].["es"] = .[1].["es"]
| .[0].["fr"] = .[1].["fr"]
| .[0].["it"] = .[1].["it"]
)
else(.)
end
)
[][]
| select(has("key"))
| walk(
if(type == "object" and has("key"))
then ([. = {key, value: . } | del(.value.key) ]| from_entries)
else(.)
end
)

```

<!-- TEST
```js
[
[input
| (
.
| to_entries
| map(.value.key = .key)
| from_entries
) []
, input[]]
 | group_by(.["ja"])
 | map(
 if ( .[1] )
 then(
   .[0].["de"] = .[1].["de"]
 | .[0].["en"] = .[1].["en"]
 | .[0].["es"] = .[1].["es"]
 | .[0].["fr"] = .[1].["fr"]
 | .[0].["it"] = .[1].["it"]
 )
 else(.)
 end
 )
 [][]
 | select(has("comments"))
 | walk(
 if(type == "object" and has("key"))
 then ([. = {key, value: . } | del(.value.key) ]| from_entries)
 else(.)
 end
 )
| reduce . as $STT_WeaponItem (.STT_WeaponItem; .STT_WeaponItem = $STT_WeaponItem)
]

| reduce .[] as $o ({}; . * $o)
```
-->

## Output

```json
[
  // ...
  {
    "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_DOUNOTSURUGI": {
      "comments": "",
      "de": "",
      "en": "Copper Sword",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "どうのつるぎ",
      "ko": "구리 검",
      "zh-Hans": "铜剑",
      "zh-Hant": "銅劍"
    }
  },
  {
    "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_ETENENOKEN": {
      "comments": "",
      "de": "",
      "en": "Ethenian Sword",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "エテーネの剣",
      "ko": "에테네의 검",
      "zh-Hans": "伊甸之剑",
      "zh-Hant": "伊甸之劍"
    }
  },
  {
    "NAME_ID_ITEM_EQUIP_ONEHANDEDSWORD_DORAGONKIRA": {
      "comments": "",
      "de": "",
      "en": "",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "ドラゴンキラー",
      "ko": "드래곤 킬러",
      "zh-Hans": "斩龙剑",
      "zh-Hant": "斬龍劍"
    }
  }
  // ...
]
```

</details>

---

</details>

<!--
----------------------------------------------------------------------------------------------------
- 20250513_0225 | PowerShell 7.5.1
----------------------------------------------------------------------------------------------------
```PS
`
jq -s "`
{STT_BattleMonsterName: . `
    | map( .STT_BattleMonsterName | to_entries[] )`
    | group_by(.value.ja)`
    | map( from_entries )`
    | map (`
        if ( length == 1 )`
        then`
        (`
            to_entries`
            | select ( map( .value != has(`"etc`") ) )`
            | from_entries`
#           | if ( map( .value | has( `"etc`" ) ) )`
#           then`
#           (`
#               del(.)
#           )`
#           else (from_entries)`
#           end`
        )`
        elif ( length == 2 )`
        then`
        (`
            to_entries`
            | if`
            (`
                (.[0].value.fr == """") and `
                (.[1].value.fr != null)`
            )`
            then`
            (`
                ( .[0].value.fr = .[1].value.fr )`
                | .[0].value.[""`$comments""] =`
                (`
                    .[0].value.[""`$comments""]`
                    | sub(""🔴""; ""🟠"")`
                )`
            )`
            else (.)`
            end`
            | del(.[1])`
            | from_entries`
        )`
        elif (length == 3)`
        then`
        (`
            to_entries`
            | ( .[1].value.fr = .[2].value.fr | .[0].value.fr = .[1].value.fr )`
            | (`
                .[0].value.[""`$comments""] = `
                (`
                    .[0].value.[""`$comments""]`
                    | sub(""🔴""; ""🔵"")`
                )`
                | .[1].value.[""`$comments""] = `
                (`
                    .[1].value.[""`$comments""]`
                    | sub(""🔴""; ""🔵"")`
                )`
            )`
            | del(.[2])`
            | from_entries`
        )`
        else (.)`
        end`
    )`
    #| select( . != null )`
    #| {STT_BattleMonsterName: .}`
}`
"`
".\OLD.json"`
".\NEW.json"`
> ".\OUTPUT.json"
```
----------------------------------------------------------------------------------------------------
-->

<!-- 
----------------------------------------------------------------------------------------------------
- 20250516_0003 | PowerShell 7.5.1 - Game.locres.json:STT_MagicName & Dragon Quest V .\data\MENUSLIST\{LANGUAGE}\b1003000.mpt
----------------------------------------------------------------------------------------------------
`
jq -n `
"`
[`
    inputs[]`
    | to_entries[]`
    #| to_entries` # add .key for debugging
    #| map(`
    #    .key as `$k
    #    | .value = (`
    #        .value | .key = `$k
    #    )`
    #)[]`
]`
| group_by( .value.ja )`
| map( from_entries )`
| map (`
    if ( length == 1 )` # No match found
    then`
    (`
        to_entries`
        ## | map( .test = ( .value | has(`"ko`") ) )`
        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
        | from_entries
    )`
    elif ( length == 2 )` # Potential match found
    then`
    (`
        to_entries`
        | ( sort | reverse )`
        | if`
        (`
            (.[0].value.de == """") and (.[1].value.de != null)`
        )`
        then`
        (`
            ( .[0].value.de = .[1].value.de )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.en == """") and (.[1].value.en != null)`
        )`
        then`
        (`
            ( .[0].value.en = .[1].value.en )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.es == """") and (.[1].value.es != null)`
        )`
        then`
        (`
            ( .[0].value.es = .[1].value.es )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.fr == """") and (.[1].value.fr != null)`
        )`
        then`
        (`
            ( .[0].value.fr = .[1].value.fr )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.it == """") and (.[1].value.it != null)`
        )`
        then`
        (`
            ( .[0].value.it = .[1].value.it )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        ##### | if`
        ##### (`
        #####     (.[0].value.[`"pt-BR`"] == """") and (.[1].value.[`"pt-BR`"] != null)`
        ##### )`
        ##### then`
        ##### (`
        #####     ( .[0].value.[`"pt-BR`"] = .[1].value.[`"pt-BR`"] )`
        #####     | .[0].value.[""`$comments""] =`
        #####     (`
        #####         .[0].value.[""`$comments""]`
        #####         | sub(""🔴""; ""🟠"")`
        #####     )`
        ##### )`
        ##### else (.)`
        ##### end`
        # | del(.[1])`
        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
        | from_entries`
    )`
    elif ( length == 3 )` # Potential match found
    then`
    (`
        to_entries`
        | if`
        (`
            (.[0].value.de == """") and (.[1].value.de != null)`
            or (.[1].value.de == """") and (.[2].value.de != null)`
        )`
        then`
        (`
            ( .[1].value.de = .[2].value.de )`
            | ( .[0].value.de = .[1].value.de )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.en == """") and (.[1].value.en != null)`
            or (.[1].value.en == """") and (.[2].value.en != null)`
        )`
        then`
        (`
            ( .[1].value.en = .[2].value.en )`
            | ( .[0].value.en = .[1].value.en )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.es == """") and (.[1].value.es != null)`
            or (.[1].value.es == """") and (.[2].value.es != null)`
        )`
        then`
        (`
            ( .[1].value.es = .[2].value.es )`
            | ( .[0].value.es = .[1].value.es )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.fr == """") and (.[1].value.fr != null)`
            or (.[1].value.fr == """") and (.[2].value.fr != null)`
        )`
        then`
        (`
            ( .[1].value.fr = .[2].value.fr )`
            | ( .[0].value.fr = .[1].value.fr )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        | if`
        (`
            (.[0].value.it == """") and (.[1].value.it != null)`
            or (.[1].value.it == """") and (.[2].value.it != null)`
        )`
        then`
        (`
            ( .[1].value.it = .[2].value.it )`
            | ( .[0].value.it = .[1].value.it )`
            | .[0].value.[""`$comments""] =`
            (`
                .[0].value.[""`$comments""]`
                | sub(""🔴""; ""🟠"")`
            )`
        )`
        else (.)`
        end`
        ##### | if`
        ##### (`
        #####     (.[0].value.[`"pt-BR`"] == """") and (.[1].value.[`"pt-BR`"] != null)`
        #####     or (.[1].value.[`"pt-BR`"] == """") and (.[2].value.[`"pt-BR`"] != null)`
        ##### )`
        ##### then`
        ##### (`
        #####     ( .[1].value.[`"pt-BR`"] = .[2].value.[`"pt-BR`"] )`
        #####     | ( .[0].value.[`"pt-BR`"] = .[1].value.[`"pt-BR`"] )`
        #####     | .[0].value.[""`$comments""] =`
        #####     (`
        #####         .[0].value.[""`$comments""]`
        #####         | sub(""🔴""; ""🟠"")`
        #####     )`
        ##### )`
        ##### else (.)`
        ##### end`
        # | del(.[2])`
        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
        | from_entries`
    )`
    elif ( length == 4 )` # Potential match found
    then`
    (`
        to_entries`
        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
        | from_entries`
    )`
    elif ( length == 5 )` # Potential match found
    then`
    (`
        to_entries`
        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
        | from_entries`
    )`
    elif ( length == 6 )` # Potential match found
    then`
    (`
        to_entries`
        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
        | from_entries`
    )`
    else ( . )`
    end`
)`
| map(`
    select( . != {} )` # remove empty objects
)`
| sort
"`
".\OLD.json"`
".\NEW.json"`
> ".\OUTPUT.json"
----------------------------------------------------------------------------------------------------
-->

<!--
----------------------------------------------------------------------------------------------------
- 20250516_1440 | PowerShell 7.5.1 - https://play.jqlang.org/s/c8l3GYKMPMQDhdl - Game.locres.json:STT_WeaponItem & Dragon Quest V .\data\MENUSLIST\{LANGUAGE}\b1000000.mpt
----------------------------------------------------------------------------------------------------
`
jq -n`
"`
  [
      inputs
      | to_entries[]
  ]
  | group_by(
      if
          (
              ( .key | test("NAME_ID_") )
              and
              ( .value | has("ko") )
          )
      then
          ( .value.ja )
      else
          ( .value.ja.["@1"] )
      end
  )
  | map(
    if ( length == 1 ) # No match found
      then
      (
          to_entries
          ## | map( .test = ( .value | has("ko") ) )
          | map( select( .value | has("ko") ) ) # invalid objects become empty
          | from_entries
      )
    elif
        ( length == 2)
        then
            #( .[0].value.ja = .[1].value.ja.["@1"])
            if
                (.[0].value.de == "") and (.[1].value.de != null)
                then
                    (
                        .[0].value.de = .[1].value.de.["@4"]
                        | .[0].value.["$comments"] =
                        (
                            .[0].value.["$comments"]
                            | sub("🔴"; "🟠")
                        )
                    )
                else ( . )
            end
            | if
                (.[0].value.en == "") and (.[1].value.en != null)
                then
                    (
                        .[0].value.en = .[1].value.en.["@4"]
                        | .[0].value.["$comments"] =
                        (
                            .[0].value.["$comments"]
                            | sub("🔴"; "🟠")
                        )
                    )
                else ( . )
            end
            | if
                (.[0].value.es == "") and (.[1].value.es != null)
                then
                    (
                        .[0].value.es = .[1].value.es.["@4"]
                        | .[0].value.["$comments"] =
                        (
                            .[0].value.["$comments"]
                            | sub("🔴"; "🟠")
                        )
                    )
                else ( . )
            end
            | if
                (.[0].value.fr == "") and (.[1].value.fr != null)
                then
                    (
                        .[0].value.fr = .[1].value.fr.["@4"]
                        | .[0].value.["$comments"] =
                        (
                            .[0].value.["$comments"]
                            | sub("🔴"; "🟠")
                        )
                    )
                else ( . )
            end
            | if
                (.[0].value.it == "") and (.[1].value.it != null)
                then
                    (
                        .[0].value.it = .[1].value.it.["@4"]
                        | .[0].value.["$comments"] =
                        (
                            .[0].value.["$comments"]
                            | sub("🔴"; "🟠")
                        )
                    )
                else ( . )
            end
            #| if
            #    (.[0].value.["pt-BR"] == "") and (.[1].value.["pt-BR"] != null)
            #    then
            #        (
            #            .[0].value.["pt-BR"] = .[1].value.["pt-BR"].["@4"]
            #            | .[0].value.["$comments"] =
            #            (
            #                .[0].value.["$comments"]
            #                | sub("🔴"; "🟠")
            #            )
            #        )
            #   else ( . )
            #end

            | map( select( .value | has("ko") ) ) # invalid objects become empty
        else ( . )
    end

    | select( . != {} ) # remove empty objects
    | sort
    | from_entries
  )
  | { "STT_WeaponItem": .[] }
"`
----------------------------------------------------------------------------------------------------
-->

<!--
----------------------------------------------------------------------------------------------------
- 20250516_1840 | PowerShell 7.5.1 - Game.locres.json:STT_WeaponItem & Dragon Quest V .\data\MENUSLIST\{LANGUAGE}\b1000000.mpt
----------------------------------------------------------------------------------------------------
`
jq -n`
"`
[
    inputs[]
    | to_entries[]
]                                                       # Put { Game.locres.json:STT_WeaponItem } & b1000000.mpt.json into same array for grouping

| group_by(
    ##################################################  # group DQ10's NAME ( sometimes RUBY )'s .ja and DQ05's .ja.@1
        .value.ja
        | walk(
            if ( type == "string" )
                then
                (
                    .
                )
                else
                (
                    .["@1"]
                )
            end
        )
    ##################################################
    //
    ##################################################  # group DQ10's EXPLANATION, NAME, and RUBY only (yet?)
    (
        if
        ( .key | test("_ID_ITEM_EQUIP_") )
            then
            (
                .key = (
                    .key
                    | sub(
                        "(EXPLANATION|NAME|RUBY)_ID_ITEM_EQUIP_(?<a>.*)";
                        "\(.a)"
                    )
                )
            )
            else ( . )
        end
        | .key
    )
    ##################################################
)[]
"`
----------------------------------------------------------------------------------------------------
-->
<!--
----------------------------------------------------------------------------------------------------
- 20250516_2200 | PowerShell 7.5.1 - Game.locres.json:STT_WeaponItem (NAME_ID_EQUIP) & Dragon Quest V .\data\MENUSLIST\{LANGUAGE}\b1000000.mpt
----------------------------------------------------------------------------------------------------
`
jq -n`
"`
[
    inputs[]
    | to_entries[]
]
####################################################################################################
#| map
| group_by
(
    
    .value.ja
    | walk(
        if ( type == "string" )
            then
            (
                .
            )
            else
            (
                .["@1"]
            )
        end
    )
    
)[]
####################################################################################################
| (sort | reverse)
####################################################################################################
| if ( length == 1 and map(has("ja") | not) )
    then
    (
        null
    )
elif ( length == 2 and (.[1].value.ja | type != "object") )
    then
    (
        null
    )
elif ( length == 3 and (.[1].value.ja | type != "object") )
    then
    (
        null
    )
elif ( length == 4 and (.[1].value.ja | type != "object") )
    then
    (
        null
    )
elif ( length == 5 and (.[1].value.ja | type != "object") )
    then
    (
        null
    )
else (
      ( if ( .[0].value.de ==  "" ) then ( .[0].value.de = .[1].value.de.["@4"] ) else ( . ) end | if (.[0].value.["$comments"] != null ) then ( .[0].value.["$comments"] = ( .[0].value.["$comments"] | sub("🔴"; "🟠") ) ) else ( . ) end )
    | ( if ( .[0].value.en ==  "" ) then ( .[0].value.en = .[1].value.en.["@4"] ) else ( . ) end | if (.[0].value.["$comments"] != null ) then ( .[0].value.["$comments"] = ( .[0].value.["$comments"] | sub("🔴"; "🟠") ) ) else ( . ) end )
    | ( if ( .[0].value.es ==  "" ) then ( .[0].value.es = .[1].value.es.["@4"] ) else ( . ) end | if (.[0].value.["$comments"] != null ) then ( .[0].value.["$comments"] = ( .[0].value.["$comments"] | sub("🔴"; "🟠") ) ) else ( . ) end )
    | ( if ( .[0].value.fr ==  "" ) then ( .[0].value.fr = .[1].value.fr.["@4"] ) else ( . ) end | if (.[0].value.["$comments"] != null ) then ( .[0].value.["$comments"] = ( .[0].value.["$comments"] | sub("🔴"; "🟠") ) ) else ( . ) end )
    | ( if ( .[0].value.it ==  "" ) then ( .[0].value.it = .[1].value.it.["@4"] ) else ( . ) end | if (.[0].value.["$comments"] != null ) then ( .[0].value.["$comments"] = ( .[0].value.["$comments"] | sub("🔴"; "🟠") ) ) else ( . ) end )
    
)
end
| del( .[1] )
####################################################################################################
| select( . != null)
| from_entries
"`
----------------------------------------------------------------------------------------------------
-->
<!--
----------------------------------------------------------------------------------------------------
- 20250516_2200 | PowerShell 7.5.1 -  Dragon Quest V .\data\MESS5\{LANGUAGE}\b0801000.mpt ( battle dialog )
####################################################################################################
# Input
####################################################################################################

```json
{
  "00001": {
    "key": " ",
    "value": "%a000130が　あらわれた！<pipipi_off>"
  },
  "00002": {
    "key": " ",
    "value": "%a000130が　あらわれた！<pipipi_off>"
  },
  "00003": {
    "key": " ",
    "value": "%a000130たちが　あらわれた！<pipipi_off>"
  },
  // ...
  "00421": {
    "key": " ",
    "value": "%a000180は　ふたたび\nめが　くらんだ！<pipipi_off>"
  }
}

```
####################################################################################################
# JQ - https://play.jqlang.org/s/PgyFwMoJnawnHo6
####################################################################################################

jq -s
```js
[ "de", "en", "es", "fr", "it", "ja" ] as $LANGUAGE
| reduce . as $obj
(
    .;
    reduce ($obj[] | keys)[] as $k
    (
        {};
        . += {
            $k: (
                [$obj[].[$k]]
                | map(.key = $LANGUAGE[5])
                | from_entries
            )
        }
    )
)
```

####################################################################################################
# Output
####################################################################################################
```json
{
  "00001": {
    "ja": "%a000130が　あらわれた！<pipipi_off>"
  },
  "00002": {
    "ja": "%a000130が　あらわれた！<pipipi_off>"
  },
  "00003": {
    "ja": "%a000130たちが　あらわれた！<pipipi_off>"
  },
  // ...
  "00421": {
    "ja": "%a000180は　ふたたび\nめが　くらんだ！<pipipi_off>"
  }
}
```
----------------------------------------------------------------------------------------------------
-->
<!--
----------------------------------------------------------------------------------------------------
- 20250518_1800 | PowerShell 7.5.1 -  Dragon Quest V .\data\MESS5\{LANGUAGE}\b0801000.mpt ( battle dialog )
####################################################################################################
# Input
####################################################################################################

```json
{
  "00001": {
    "key": " ",
    "value": "%a000130が　あらわれた！<pipipi_off>"
  },
  "00002": {
    "key": " ",
    "value": "%a000130が　あらわれた！<pipipi_off>"
  },
  "00003": {
    "key": " ",
    "value": "%a000130たちが　あらわれた！<pipipi_off>"
  },
  // ...
  "00421": {
    "key": " ",
    "value": "%a000180は　ふたたび\nめが　くらんだ！<pipipi_off>"
  }
}

```
####################################################################################################
# JQ
####################################################################################################
 
 jq -n 
```js
[
    inputs[]
    | to_entries[]
]
| group_by( .. | .ja? )
| map(
    # length
    ##################################################
    sort
    | if ( length == 1 )
        then
        (
            #########################
            # DEBUG
            #map(.key)[] as $k
            #| {$k: length}
            #########################
            select (map( .value | has("ko") ) )[]
        )
    elif ( length == 2 )
        then
        (
            #########################
            # DEBUG
            # { "2": length }
            # map( .key )
            #########################
            if (
                    .[0].value.en != null
                    #and .[1].value.en == ""
                    and (.[1].key | test("(NAME_)") )
                )
                    then
                    (
                        ##########################################################################################################################################################################################################################################################
                         if( .[0].value.de        != null and .[1].value.de        ==  "" )then(     .[1].value.de        = .[0].value.de        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.en        != null and .[1].value.en        ==  "" )then(     .[1].value.en        = .[0].value.en        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.es        != null and .[1].value.es        ==  "" )then(     .[1].value.es        = .[0].value.es        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.fr        != null and .[1].value.fr        ==  "" )then(     .[1].value.fr        = .[0].value.fr        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.it        != null and .[1].value.it        ==  "" )then(     .[1].value.it        = .[0].value.it        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.["pt-BR"] != null and .[1].value.["pt-BR"] ==  "" )then(     .[1].value.["pt-BR"] = .[0].value.["pt-BR"] |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        ##########################################################################################################################################################################################################################################################
                        # remove invalid objects
                        ##################################################
                        | map( select( .value | ( has("ko") ) ) )[]
                    )
                else
                (
                    .
                )
                end
        )
    elif ( length == 3 )
        then
        (
            #########################
            # DEBUG
            # { "3": length }
            # map( .key )
            #########################
            if (
                    .[0].value.en != null
                    #and .[1].value.en == ""
                    and (.[1].key | test("(NAME_)") )
                )
                    then
                    (
                        ##########################################################################################################################################################################################################################################################
                         if( .[0].value.de        != null and .[1].value.de        ==  "" )then(     .[1].value.de        = .[0].value.de        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.en        != null and .[1].value.en        ==  "" )then(     .[1].value.en        = .[0].value.en        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.es        != null and .[1].value.es        ==  "" )then(     .[1].value.es        = .[0].value.es        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.fr        != null and .[1].value.fr        ==  "" )then(     .[1].value.fr        = .[0].value.fr        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.it        != null and .[1].value.it        ==  "" )then(     .[1].value.it        = .[0].value.it        |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        |if( .[0].value.["pt-BR"] != null and .[1].value.["pt-BR"] ==  "" )then(     .[1].value.["pt-BR"] = .[0].value.["pt-BR"] |.[1].value.["$comments"] = ( .[1].value.["$comments"] | sub("🔴"; "🟠")     ) )else(.)end 
                        ##########################################################################################################################################################################################################################################################
                        # remove invalid objects
                        ##################################################
                        | map( select( .value | ( has("ko") ) ) )[]
                    )
                else
                (
                    .
                )
                end
        )
    else ( . )
    end
)
| sort
| from_entries
| {"STT_": .}
```

####################################################################################################
# Output
####################################################################################################
```json
{
    "STT_": {
        {},
        {},
        {},
        // ...
        {}
    }
}
```
----------------------------------------------------------------------------------------------------
-->
<!--
----------------------------------------------------------------------------------------------------
- 20250518_1800 | PowerShell 7.5.1 -  Dragon Quest V .\data\MESS5\{LANGUAGE}\b0801000.mpt ( battle dialog )
####################################################################################################
# Input
####################################################################################################

```json
{
    "STT_BattleMonsterName": {
        "ID_MONSTER_NAME_00100": {
            "$comments": "🔴, DQ3make.GOP_TEXT_Noun_AllLanguages:TEXT_NOUN_Monster_Name_Slime",
            "de": "",
            "en": "",
            "es": "",
            "fr": "",
            "it": "",
            "ja": "スライム",
            "ko": "슬라임",
            "pt-BR": "",
            "zh-Hans": "史莱姆",
            "zh-Hant": "史萊姆"
        },
        // ...
    }
}
{
    "DQ05_b1002000.mpt": {
        // ...
        "00106": {
            "de": "Schleim",
            "en": "Slime",
            "es": "Limo",
            "fr": "Gluant",
            "it": "Slime",
            "ja": "スライム"
        },
        // ...
    }
}

```
####################################################################################################
# JQ
####################################################################################################
 `
  jq -n `
 "`
 [`
     inputs[]`
     | to_entries[]`
 ]`
 | group_by( .value.ja )`
 | map(`
 #    # length`
 #    ##################################################`
     sort`
     | if ( length == 1 )`
         then`
         (`
             #########################`
             # DEBUG`
             #map(.key)[] as `$k`
             #| {`$k: length}`
             #########################`
             map( select( .value | has(`"ko`") ) )` # invalid objects become empty
         )`
     elif ( length == 2 )`
         then`
         (`
             #########################`
             # DEBUG`
             # { `"2`": length }`
             # map( .key )`
             #########################`
             if (`
                     .[0].value.en != null`
                     #and .[1].value.en == `"`"`
                     and (.[1].key | test(`"(NAME_)`") )`
                 )`
                     then`
                     (`
                         ##########################################################################################################################################################################################################################################################`
                          if( .[0].value.de        != null and .[1].value.de        ==  `"`" )then(     .[1].value.de        = .[0].value.de |.[1].value.[`"`$comments`"]        = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end `
                         |if( .[0].value.en        != null and .[1].value.en        ==  `"`" )then(     .[1].value.en        = .[0].value.en |.[1].value.[`"`$comments`"]        = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end `
                         |if( .[0].value.es        != null and .[1].value.es        ==  `"`" )then(     .[1].value.es        = .[0].value.es |.[1].value.[`"`$comments`"]        = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end `
                         |if( .[0].value.fr        != null and .[1].value.fr        ==  `"`" )then(     .[1].value.fr        = .[0].value.fr |.[1].value.[`"`$comments`"]        = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end `
                         |if( .[0].value.it        != null and .[1].value.it        ==  `"`" )then(     .[1].value.it        = .[0].value.it |.[1].value.[`"`$comments`"]        = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end `
                         |if( .[0].value.[`"pt-BR`"] != null and .[1].value.[`"pt-BR`"] ==  `"`" )then(     .[1].value.[`"pt-BR`"] = .[0].value.[`"pt-BR`"] |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end `
                         ##########################################################################################################################################################################################################################################################`
                         # remove invalid objects`
                         ##################################################`
                         | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
                     )`
                 else`
                 (`
                     #.`
                     map( select( has(`"ko`") ) )` # invalid objects become empty
                 )`
                 end`
         )`
     elif ( length == 3 )`
         then`
         (`
             #########################`
             # DEBUG`
             # { `"3`": length }`
             # map( .key )`
             #########################`
             if (`
                     .[0].value.en != null`
                     #and .[1].value.en == `"`"`
                     and (.[1].key | test(`"(NAME_)`") )`
                 )`
                     then`
                     (`
                        ##########################################################################################################################################################################################################################################################`
                         if( .[0].value.de          != null and .[1].value.de          ==  `"`" )then(     .[1].value.de          = .[0].value.de          |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end`
                        |if( .[0].value.en          != null and .[1].value.en          ==  `"`" )then(     .[1].value.en          = .[0].value.en          |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end`
                        |if( .[0].value.es          != null and .[1].value.es          ==  `"`" )then(     .[1].value.es          = .[0].value.es          |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end`
                        |if( .[0].value.fr          != null and .[1].value.fr          ==  `"`" )then(     .[1].value.fr          = .[0].value.fr          |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end`
                        |if( .[0].value.it          != null and .[1].value.it          ==  `"`" )then(     .[1].value.it          = .[0].value.it          |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end`
                        |if( .[0].value.[`"pt-BR`"] != null and .[1].value.[`"pt-BR`"] ==  `"`" )then(     .[1].value.[`"pt-BR`"] = .[0].value.[`"pt-BR`"] |.[1].value.[`"`$comments`"] = ( .[1].value.[`"`$comments`"] | sub(`"[🔴🟡]`"; `"🟠`")     ) )else(.)end`
                        ##########################################################################################################################################################################################################################################################`
                        # remove invalid objects`
                        ##################################################`
                        | map( select( .value | has(`"ko`") ) )` # invalid objects become empty
                     )`
                 else`
                 (`
                     #.`
                     map( select( has(`"ko`") ) )` # invalid objects become empty
                 )`
                 end`
         )`
     #else ( . )`
     else (`
         map( select( has(`"ko`") ) )` # invalid objects become empty
         )`
     end`
     | from_entries`
 )`
 | map(`
     select( . != {} )` # remove empty objects
 )`
 | sort`
 #| from_entries`
 | {`"STT_BattleMonsterName`": .}`
 "`
 ".\OLD.json"`
 ".\NEW.json"`
 > ".\OUTPUTereeee.json"
```

####################################################################################################
# Output
####################################################################################################
```json
{
    "STT_BattleMonsterName": {
        "ID_MONSTER_NAME_00100": {
            "$comments": "🟠, DQ3make.GOP_TEXT_Noun_AllLanguages:TEXT_NOUN_Monster_Name_Slime",
            "de": "Schleim",
            "en": "Slime",
            "es": "Limo",
            "fr": "Gluant",
            "it": "Slime",
            "ja": "スライム",
            "ko": "슬라임",
            "pt-BR": "",
            "zh-Hans": "史莱姆",
            "zh-Hant": "史萊姆"
        },
        // ...
    }
}
```
----------------------------------------------------------------------------------------------------
-->
<!--
----------------------------------------------------------------------------------------------------
- 20250520_0330 | PowerShell 7.5.1 -  Dragon Quest V .\data\MESS5\{LANGUAGE}\b0835000.mpt ( item descriptions ) https://play.jqlang.org/s/Ay64Ula-khfTc_R
####################################################################################################
# Input
####################################################################################################

```json
{
"00001": {
	"key": " ",
	"value": "なかまひとりの　ＨＰを３０～かいふく<pipipi_off>"
},
"00002": {
	"key": " ",
	"value": "なかまひとりの　ＨＰを７５～かいふく<pipipi_off>"
},
"00003": {
	"key": " ",
	"value": "なかまひとりの　ＨＰをすべてかいふく<pipipi_off>"
},
// ...
}
```
####################################################################################################
# JQ
####################################################################################################
["de", "en", "es", "fr", "it", "ja", "ko", "zh-Hans", "zh-Hant"][5] as $LANGUAGE
| . as $obj
| reduce ($obj|keys[]) as $k
(
    {};
    ####################################################################################################
    # .[$k] += {"ja": ($obj[$k].value)}

    # .[$k] += {"ja": {"@1": ($obj[$k].value)}}
    ####################################################################################################
    # 03. K:V > $LANGUAGE
    .[$k] += {$LANGUAGE: ($obj[$k].value)}
    ####################################################################################################
    ## 04. $LANGUAGE: {K:V}
    #if
    #    ( $obj[$k].key == " " )
    #    then
    #        ( .[$k] += {$LANGUAGE: {"key": "","value": $obj[$k].value}} )
    #elif
    #    ( $obj[$k].key == "@aName@b" )
    #    then
    #        ( .[$k] += {$LANGUAGE: {"key": $obj[$k].value, "value": $obj[$k].value}} )
    #else
    #    ( .[$k] += {$LANGUAGE: {"key": $obj[$k].key, "value": $obj[$k].value}} )
    #end
    ####################################################################################################
    #.[$k] += {
    #    $LANGUAGE: {
    #        "key": $obj[$k].value,
    #        "value": $obj[$k].value
    #    }
    #}
    # .[$k] += {$LANGUAGE: [{"key":$LANGUAGE,"value": ($obj[$k].value)}] | from_entries}
    ####################################################################################################
    # .[$k] += {"ja": {"key": ($obj[$k].value),"value": ($obj[$k].value)}}
    ####################################################################################################
)
####################################################################################################
# 03. K:V > $LANGUAGE
| to_entries
| map(
    .value.[$LANGUAGE] = (
        .value.[$LANGUAGE]
        | gsub("@1?";"")
    )
)
| from_entries
####################################################################################################
## 04. $LANGUAGE: {K:V}
#| to_entries
#| map(
#    .value.[$LANGUAGE].key = (                   # .value from .key
#        .value.[$LANGUAGE].key
#        | gsub("@a(?<a>.*?)@b.*";"\(.a)")
#    )
#    | .value.[$LANGUAGE].value = (               # remove .key from .value
#        .value.[$LANGUAGE].value
#        | gsub("@a.*?@b(?<a>.*)";"\(.a)")
#    )
#    | .value.[$LANGUAGE] = (                     # simplify output
#        [.value.[$LANGUAGE] ]
#        | from_entries
#    )
#)
#| from_entries
```

####################################################################################################
# Output
####################################################################################################
```json
{
  "00001": {
    "ja": "なかまひとりの　ＨＰを３０～かいふく<pipipi_off>"
  },
  "00002": {
    "ja": "なかまひとりの　ＨＰを７５～かいふく<pipipi_off>"
  },
  "00003": {
    "ja": "なかまひとりの　ＨＰをすべてかいふく<pipipi_off>"
  },
  // ...
}
```
----------------------------------------------------------------------------------------------------
-->