<details><summary><h1>`.etp` - Old to New Format</h1></summary>

> # JQ Query
>
> ````js
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
> ````
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

---

</details>

<details><summary><h1>`StringTable.csv` to `StringTable.json`</h1></summary>

> # JQ Query
>
> ````js
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
> ````
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
> > ````js
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
> > ````
>
> ---
>
> </details>

<details><summary><h1>`StringTable.json` to `StringTable.csv`</h1></summary>

> - For translating via `pakchunk#-<PLATFORM>.ucas/<PROJECT_NAME>/Content/StringTables/Game/**/<StringTable>.uasset` in Unreal Engine's UE4Editor
>
> # JQ Query
>
> ````js
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
> ````
>
> ---
>
> </details>

<details><summary><h1>`StringTable.json` to `Game.locres.json`</h1></summary>

> - For translating via `pakchunk0-<PLATFORM>.pak/<PROJECT_NAME>/Content/Localization/Game/<LANGUAGE>/Game.locres` with LocRes-Builder
>
> ## JQ Query
>
> ````js
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
> ````
>
> ---
>
> </details>

<details><summary><h1>Merge DQ3make DataTables & Game.locres.json by keys</h1></summary>

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
