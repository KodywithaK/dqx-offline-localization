<details><summary><h1>Game/Content/NonAssets/ETP*/*.etp</h1></summary>

## Recommended Character Counts
  - ~~Text in a standard dialog box fits perfectly at `42vw x 13vh`, usually:~~
  - Using `Garrick Bold` font:
    - ≤50 characters, 3 lines tall (2 `\n`)

## Glossary
|Term|Definition|
|:-:|:--|
|...`\n` |newline|
|...`\n<br>\n` |clears current dialog area for next block of text.|
|`<%sEV_QUEST_NAME>`|Quest Name|
|`<center>`...<br>or `<left>`...<br>or `<right>`...|justify-content: For text in dialog area.|
|`<color_x>`...|changes font-color for following text, e.g.:<br>"`<color_red>`<span style="color:#FF0000">red</span>`<color_white>`<span style="color:#FFFFFF">white</span>`<color_blue>`<span style="color:#0000FF">blue</span>"|
|`<cs_pchero>`|player character's name.|
|`<heart>`|heart emoji|
|`<icon_exc>`...|Displays exclamation mark and sound effect.|
|`<icon_que>`...|Displays question mark and sound effect.|
|`<if_woman>`...<br>`<else>`...<br>`<endif>`|Differentiates displayed dialog, depending on player character's gender, e.g.:<br>"`<if_woman>`Hey, miss!`<else>`Hey, mister!`<endif>`"|
|`<me #>`|play sound effect, e.g.:<br>"\<pc\> obtained the X (Key Item)!`<me 60>`"|
|`<open_irai>`|opens active quest info|
|`<se_nots #>`|play sound effect, e.g.:<br>"\<pc\> received a Mini Medal!`<se_nots System 18>`"|
|`<shake_camera #>`...|Shakes camera during cutscene|
|`<turn_pc>`...|Speaking NPC turns towards player character.|

---

</details>

<details><summary><h1>Game/Content/Localization/*/Game.locres</h1></summary>

## Recommended Character Counts
  - ~~Text in a standard dialog box fits perfectly at `80vw x 33vh`, usually:~~
  - Using `Garrick Bold` font:

|Namespace|Value Length|Comment(s)|
|:--|:--|:--|
|ASIA_DLC|TBD||
|Event_Common|TBD||
|lpWindowName|TBD||
|Sample|TBD||
|STT_AccessoryItem|TBD||
|STT_ActionAvgMsg_Simple*|TBD||
|STT_ActionMsg_Balloon*|TBD||
|STT_ActionMsg_Log*|TBD||
|STT_ActionMsg_Simple*|TBD||
|STT_ActionSumMsg_Simple*|TBD||
|STT_BarMonsterNpc|TBD||
|STT_BarMonsterSys|TBD||
|STT_Battle_Levelup|TBD||
|STT_Battle_Option|TBD||
|STT_Battle_UI|TBD||
|STT_BattleAbiMsg|TBD||
|STT_BattleActionItem|TBD||
|STT_BattleEquipItem|TBD||
|STT_BattleGuestName|TBD||
|STT_BattleMagicItem|TBD||
|STT_BattleMonsterName|TBD||
|STT_BattleOddAvgMsg_*_SYS|TBD||
|STT_BattleOddMsg_*_BALOON|TBD||
|STT_BattleOddMsg_*_LOG|TBD||
|STT_BattleOddMsg_*_SYS|TBD||
|STT_BattleroadSys|TBD||
|STT_BattleSkillItem|TBD||
|STT_BattleSlideAvgMsg_*_SYS|TBD||
|STT_BattleSlideMsg_*_LOG|TBD||
|STT_BattleSlideMsg_*_SYS|TBD||
|STT_BattleSlideSumMsg_*_SYS|TBD||
|STT_BattleSpecialSkillItem|TBD||
|STT_BattleSysMsg_LOG|TBD||
|STT_BattleSysMsg|TBD||
|STT_Boukennosho_DLC_Text|TBD||
|STT_BRReceptionNpc|TBD||
|STT_Career_StoryUISys|TBD||
|STT_CareerStoryVer*|TBD|Displayed on screen while looking at `The Story of {Place_Name}` in the `The Story So Far` section.<br>Same as `STT_LoadingArasujiVer*`.|
|STT_CasinoCoin|TBD||
|STT_Charamake_Female_NoLocalization|TBD||
|STT_Charamake_Female|TBD||
|STT_Charamake_Male_NoLocalization|TBD||
|STT_Charamake_Male|TBD||
|STT_CharamakeColors|TBD||
|STT_Colosseum_NPC|TBD||
|STT_Colosseum_SYS|TBD||
|STT_CommonItem|≤20 characters, 3 lines tall (2 `\n`)|Names and descriptions of `Items`.|
|STT_ConditionViewer|TBD||
|STT_ConvinientMainSys|TBD||
|STT_DaijinamonoItem|≤20 characters, 3 lines tall (2 `\n`)|Names and descriptions of `Key Items`.|
|STT_Dorubaord|≤50 characters, 3 lines tall (2 `\n`)|"You can't ride your Dolboard here!"|
|STT_DungeonKingdomSys|TBD||
|STT_DungeonMagicNPC|TBD||
|STT_Emote|TBD||
|STT_Equip_Coordinate|TBD||
|STT_Equip_OddStatus_Name|TBD||
|STT_EventMonsterName|TBD||
|STT_EventPalceName|TBD|Names of towns and story chapters in the `The Story So Far` section.|
|STT_FaciliityDolboardSys|TBD||
|STT_FacilityBankNpc|TBD||
|STT_FacilityBankSys|TBD||
|STT_FacilityBarNpc|TBD||
|STT_FacilityBarSys|TBD||
|STT_FacilityColoringNpc|TBD||
|STT_FacilityColoringSys|TBD||
|STT_FacilityConciergeNpc|TBD||
|STT_FacilityConciergeSys|TBD||
|STT_FacilityDolboardNpc|TBD||
|STT_FacilitySalonNpc|TBD||
|STT_FacilitySubjugationNpc|TBD||
|STT_FacilitySubjugationSys|TBD||
|STT_FacilitySynthesisNpc|TBD||
|STT_FacilitySynthesisSys|TBD||
|STT_FieldDoraky|TBD||
|STT_FieldLog|TBD||
|STT_FieldMapSys|TBD||
|STT_FieldMoveDragon|TBD||
|STT_FieldProcess|TBD||
|STT_Fishing|TBD||
|STT_FishingAction|TBD||
|STT_FishingExchangeNPC|TBD||
|STT_FishingMasterNPC|TBD||
|STT_FishingSys|TBD||
|STT_FullCureSys|TBD||
|STT_GameOption_Explanation|TBD||
|STT_GameOption|TBD||
|STT_Gesture|TBD||
|STT_IraisyoArasuji|TBD||
|STT_IraisyoMonsterType|TBD||
|STT_IraisyoNPCNameBase|TBD||
|STT_IraisyoNPCNameRuby|TBD||
|STT_ItemExplanation|TBD||
|STT_ItemList|TBD||
|STT_ItemName|TBD||
|STT_JobChangeNpc|TBD||
|STT_JobChangeSys|TBD||
|STT_KeyboardSetting|TBD||
|STT_KeyboardSettingKeyString|TBD||
|STT_LD_SerchFieldObject|TBD||
|STT_LoadingArasujiVer*|TBD|Displayed on screen during first loading screen after continuing adventure.<br>Same entries as `STT_CareerStoryVer*`.|
|STT_LoadingTips|TBD|Displayed on screen in a shuffled sorting during loading screens.|
|STT_MagicExplanation|TBD||
|STT_MagicName|TBD||
|STT_Main_UI|TBD||
|STT_MasteryItems|TBD||
|STT_Monster_Tips*_ver*|TBD||
|STT_Monster_Type|TBD||
|STT_MonsterColor|TBD||
|STT_MonsterMercenary|TBD||
|STT_MonsterTarotArcana|TBD||
|STT_MonsterTarotDeck|TBD||
|STT_MonsterTarotMonster|TBD||
|STT_NpcInfo|TBD||
|STT_OddStatusExplanation|TBD||
|STT_OddStatusName|TBD||
|STT_PartyMainSys|TBD||
|STT_Profile_Word|TBD||
|STT_PT_InOut|≤50 characters, 3 lines tall (2 `\n`), separated by `\n<br>\n`|Guest party member's dialog when leaving their quest areas.|
|STT_PT_Talk|≤50 characters, 3 lines tall (2 `\n`), separated by `\n<br>\n`|Party chat|
|STT_Quest_AfterBattle|TBD||
|STT_Quest_ItemGet|TBD||
|STT_Quest_PerticularReward|TBD||
|STT_QuestList|TBD||
|STT_QuestListCategory|TBD||
|STT_QuestListDetail|≤70 characters, 7 lines tall (6 `\n`)|Displayed on screen while looking at specific quests.|
|STT_QuestListName|TBD||
|STT_QuestListSeries|TBD||
|STT_Restricted_GamePlay|TBD||
|STT_ResurrectionTextList|TBD||
|STT_SenrekUIiSys|TBD||
|STT_ShopDouguNpc|TBD||
|STT_SkillExplanation|TBD||
|STT_SkillName|TBD||
|STT_SkillupExplanation|TBD||
|STT_SkillupName|TBD||
|STT_SpecialExplanation|TBD||
|STT_SpecialName|TBD||
|STT_Support_BrowseSys|TBD||
|STT_Syougou|TBD||
|STT_System_Book_Monster|TBD||
|STT_System_Casino|TBD||
|STT_System_Charamake|TBD||
|STT_System_CharamakeSys|TBD||
|STT_System_Common|TBD||
|STT_System_Craftsman|TBD||
|STT_System_Equip|TBD||
|STT_System_Facility_ChurchNpc|TBD||
|STT_System_Facility_ChurchSys|TBD||
|STT_System_ItabaeAlbum|TBD||
|STT_System_Location|TBD||
|STT_System_ProfileWord|TBD||
|STT_System_Shop_Dougu_Sys|TBD||
|STT_System_Shop_Dougu|TBD||
|STT_System_Shop_Other|TBD||
|STT_System_Skill|TBD||
|STT_System_Title|TBD||
|STT_System_UI|TBD||
|STT_System_WeaponTypes|TBD||
|STT_SystemDouguNpc|TBD||
|STT_SystemDragonNpc|TBD||
|STT_SystemDragonSys|TBD||
|STT_SystemFishingBook|TBD||
|STT_SystemFishingFish|TBD||
|STT_SystemMoveNpc|TBD||
|STT_SystemQuest|TBD||
|STT_SystemShipNpc|TBD||
|STT_SystemShipSys|TBD||
|STT_SystemShopInn|TBD||
|STT_SystemTrainNpc|TBD||
|STT_SystemTrainSys|TBD||
|STT_Sytem_UI_Status|TBD||
|STT_TestText|TBD||
|STT_TinyMedals|TBD||
|STT_TinyMedalsWindow|TBD||
|STT_Tips_Category|TBD||
|STT_Tips_Content|TBD||
|STT_ToolActionItem|TBD||
|STT_UIDouguSys|≤50 characters, 3 lines tall (2 `\n`), separated by `\n<br>\n`|Usage of `Key Items`.|
|STT_UIJumonSys|TBD||
|STT_WarpBraveStoneSys|TBD||
|STT_WarpRiremitoSys|TBD||
|STT_WarpRura|TBD||
|STT_WeaponItem|TBD||
|SYSTEM_LOACALIZATION|TBD||
|WeaponTypeForBugFix|TBD||

## Glossary
|Term|Definition|
|:-:|:--|
|`{pc}`|player character|

---

</details>
