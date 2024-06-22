<details><summary><h1>Game/Content/NonAssets/ETP*/*.etp</h1></summary>

## Recommended Character Counts
  - Text in a standard dialog box fits perfectly at `42vw x 13vh`, usually:
    - ≤50 characters long, 3 lines tall (2 `\n`)

## Glossary
|Term|Definition|
|:-:|:--|
|`<center>`|justify-content: center for text in dialog area.|
|`<color_x>`|changes font-color for following text, e.g.:<br>`<color_red>`<span style="color:#FF0000">red</span>`<color_white>`<span style="color:#FFFFFF">white</span>`<color_blue>`<span style="color:#0000FF">blue</span>|
|`<cs_pchero>`|player character's name.|
|`<%sEV_QUEST_NAME>`|Quest Name|
|`<heart>`|heart emoji|
|`<icon_exc>`|Displays exclamation mark and sound effect.|
|`<icon_que>`|Displays question mark and sound effect.|
|`<if_woman>`...<br>`<else>`...<br>`<endif>`|Differentiates displayed dialog, depending on player character's gender|
|`<left>`|justify-content: start for text in dialog area.|
|`<me #>`|play sound effect, e.g.:<br>`<pc> obtained X (Key Item)!<me 60>`|
|`\n` |newline|
|`\n<br>\n` |clears current dialog area for next block of text.|
|`<open_irai>`|opens active quest info|
|`<right>`|justify-content: end for text in dialog area.|
|`<se_nots #>`|play sound effect, e.g.:<br>`<pc> received a Mini Medal!<se_nots System 18>`|
|`<shake_camera #>`|Shakes camera during cutscene|
|`<turn_pc>`|Speaking NPC turns towards player character.|

---

</details>

<details><summary><h1>Game/Content/Localization/*/Game.locres</h1></summary>

## Recommended Character Counts
  - `STT_CareerStoryVer1`
    - ≤70 
  - `STT_LoadingArasujiVer1`
    - ≤70
  - `STT_LoadingTips`
    - Text in a standard dialog box fits perfectly at `80vw x 33vh`, usually:
      - ≤70 characters long, 7 lines tall (6 `\n`)

## Glossary
|Term|Definition|
|:-:|:--|
|`{pc}`|player character|

---

</details>