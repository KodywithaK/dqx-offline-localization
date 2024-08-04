<!--
> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.
-->

> [!CAUTION]
> Double-quotes (`"`) must be escaped to be used in text (`\"`...`\"`), otherwise it will break the whole file and lead to possible softlocks.

<details><summary><h1>Game/Content/NonAssets/ETP*/*.etp</h1></summary>

## Useful Regex

The texts described in [Find](#find) show up multiple times across most of the `*.etp` files, so you can translate them quickly by using the parameters below to find and replace with new text.

For example:

-   Find: `(?<="UNTRANSLATED_TEXT": \n    ")(?=")`
-   Replace: `YOUR_TRANSLATED_TEXT`

### Find

`(?<="クエストを　依頼されました。\\nこのクエストを　受けますか？\\n<select>\\nうける\\nやめる\\n<select_end><close>": \n    ")(?=")`

-   You have been asked to do a quest. Do you accept?\n\<select\>\nAccept\nDecline\n\<select_end\>\<close\>

`(?<="クエスト『<%sEV_QUEST_NAME>』を\\n受けました。<me 74>": \n    ")(?=")`

-   Quest \\"\<%sEV_QUEST_NAME\>\\" received.\<me 74\>

`(?<="クエスト『<%sEV_QUEST_NAME>』を\\nクリアしました！\\n　<update_quedate><open_irai>": \n    ")(?=")`

-   Quest \\"\<%sEV_QUEST_NAME\>\\" cleared!

`(?<="扉には　カギが　かかっている。": \n    ")(?=")`

-   The door is locked.

`(?<="扉は　かたく　閉ざされている。": \n    ")(?=")`

-   The door is locked tight.

</details>
