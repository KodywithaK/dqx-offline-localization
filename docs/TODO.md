> [!TIP]
> 
> # 2026.01.03
> 
> <details><summary><h2>Game.locres.yaml > UE4Editor - JsonAsAsset > StringTables</h2></summary>
> 
> - Crashing JsonAsAsset
>   - `STT_BattleOddMsg_DAP_SYS.json`
>     - `\n        "": "",`
> 
> ### `UE4Editor/Holiday/KwK/StringTables_JsonAsAsset_20260102.bat`
> 
> - Fix `Game.locres.yaml` filepath
> - Add `CALL :RunUAT`
> 
> # 2026.01.02
> 
> ## 01
> 
> - Fmodel
>   - Export `StringTables` as json
>   - Delete `PAL_*.json`
>   - `FOR %L IN (de en es fr it pt-BR) DO xcopy /f /j /s /v /y /z "R:\Temp\Exports\Holiday\Content\StringTables\*" "R:\Temp\Exports\Holiday\Content\i18n\%L\StringTables\"`
>   - `FOR %L IN (de en es fr it pt-BR) DO xcopy /f /j /s /v /y /z "R:\Temp\Exports\Game\Content\StringTables\*" "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\"`
> 
> ## 02
> 
> - StringTables_02.jq
> ```js
> # FOR %L IN (de en es fr it pt-BR) DO FOR /F "usebackq delims= " %F IN (`yq "keys[]" "...\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec`) DO
> # yq ".%~F" "...\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec |
> # jq --arg LANGUAGE "%L" 
> . as $obj
> | reduce ( $obj | keys_unsorted )[] as $k (
> 	{};
> 	.StringTable.KeysToEntries.[$k] += (
> 		if ( $LANGUAGE != "la" )
> 		then (
> 			if   ( $obj[$k].[$LANGUAGE] != "" )
> 			then ( $obj[$k].[$LANGUAGE] )
> 			else ( $obj[$k].["ja"] )
> 			end
> 		)
> 		else ( $k | ascii_downcase )
> 		# else ( [ ( $k | ascii_downcase ), $obj[$k].["ja"] ] | join("\\n<br>\\n") )
> 		end
> 	)
> )
> | [.]
> # > "%~F.%L.json"
> ```
> 
> ```cmd
> :: regular json file
> cls && FOR %L IN (es) DO FOR /F "usebackq delims= " %F IN (`yq "keys[]" "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec`) DO yq ".%~F" "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec | jq --arg LANGUAGE "%L" ". as $obj | reduce ( $obj | keys_unsorted )[] as $k ( {}; .StringTable.KeysToEntries.[$k] += ( if   ( $obj[$k].[$LANGUAGE] != \"\" ) then ( $obj[$k].[$LANGUAGE] ) else ( $obj[$k].[\"ja\"] ) end ) )" > "%~F.%L.json"
> :: Match FModel's StringTable format
> cls && FOR %L IN (en) DO FOR /F "usebackq delims= " %F IN (`yq "keys[]" "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec`) DO yq ".%~F" "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec | jq --arg LANGUAGE "%L" ". as $obj | reduce ( $obj | keys_unsorted )[] as $k ( {}; .StringTable.KeysToEntries.[$k] += ( if ( $LANGUAGE != \"la\" ) then ( if   ( $obj[$k].[$LANGUAGE"] != \"\" ) then ( $obj[$k].[$LANGUAGE"] ) else ( $obj[$k].[\"ja\"] ) end ) else ( $k | ascii_downcase ) end ) ) | [.]" > "%~F.%L.json"
> ```
> 
> ## 03
> 
> ### {StringTables}.json : $obj.StringTable.KeysToEntries.[$k] = Game.locres.yaml : $obj[$ns][$k][$LANGUAGE]
> 
> ```js
> FOR %L IN (de en es fr it pt-BR) DO (
> 	FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (
> 		jq -n
> 		input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) | [.]
> 		"%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F"
> 	)
> )
> ```
>   - ```cmd
>     FOR %L IN (de en es fr it pt-BR) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] )" "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\System\System_CareerStory\STT_EventPalceName.json" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json")
>     FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game" /s /b /a-d /o:n`) DO (
>       jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; if ( .StringTable.KeysToEntries.[$k] != "" ) then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) else ( del( .StringTable.KeysToEntries.[$k] ) ) end )" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.json" > "%F.temp"
>     )
>     ```
> .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k]
>    - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) | [.]" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
> 
>    - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; if ( .StringTable.KeysToEntries.[$k] != \"\" ) then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) else ( del( .StringTable.KeysToEntries.[$k] ) ) end ) | [.]" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
>      - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\StringTables\Game\Battle\STT_BattleSysMsg_LOG.json" /s /b /a-d /o:n`) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; if ( .StringTable.KeysToEntries.[$k] != "" ) then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) else ( del( .StringTable.KeysToEntries.[$k] ) ) end ) | [.]" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
> 
>    - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (jq -n --from-file "StringTables_JsonAsAsset_03.jq" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
> 
> ## 04
> 
> - UE4Editor > JsonAsAsset > StringTables
>   - `Execute JsonAsAsset` 
>     - Inside `R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\`, search for `.json`
>     - Select all, open, then wait for everything to be created / updated 
> 
> ## 05
> 
> - `"C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!   pakchunk0-WindowsNoEditor_LocResBuilder_P.pak.20251221.bat"`
>   - `CALL :RunUAT ja`
> 
> ## NOTES
> 
> </details>

> [!NOTE]
> 
> <details><summary><h2>2026.01.01 - Game.locres.yaml > UE4Editor - JsonAsAsset > StringTables</h2></summary>
> 
> # 2026.01.01
> 
> ## 01
> 
> - Fmodel
>   - Export `StringTables` as json
>   - Delete `PAL_*.json`
>   - `FOR %L IN (de en es fr it pt-BR) DO xcopy /f /j /s /v /y /z "R:\Temp\Exports\Game\Content\StringTables\*" "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\"`
> 
> ## 02
> 
> - `StringTables_JsonAsAsset_02.jq`
>   ```js
>   [
>   . as $obj
>   | reduce ( $obj | keys_unsorted )[] as $ns (
>       {};
>       . += (
>           reduce ( $obj[$ns] | keys_unsorted )[] as $k (
>               {};
>               .[$k] += (
>                   if ( $LANGUAGE != "la" )
>                   then (
>                       if ( $obj[$ns][$k][$LANGUAGE] != "" )
>                       then ( $obj[$ns][$k][$LANGUAGE] )
>                       else ( $obj[$ns][$k]["ja"] )
>                       end
>                   )
>                   else ( $k | ascii_downcase )
>                   end
>               )
>           )
>       )
>   )
>   | { StringTable: { KeysToEntries: . } }
>   ]
>   ```
> 
>  ## 2.5 ( TODO ) Try splitting Game.locres.yaml by keys to prevent unwanted overwrites
> 
>  - TBD
>    - ( e.g., `{} takes {} damage!` being overwritten as `{} takes no damage!` )
> 
> `FOR %L IN (de en es fr it pt-BR) DO yq eval "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec | jq --arg LANGUAGE "%L" --from-file "StringTables_JsonAsAsset_02.jq" > StringTables.%L.json`
> 
> ## 03
> 
> - {StringTables}.json : $obj.StringTable.KeysToEntries.[$k] = Game.locres.yaml : $obj[$ns][$k][$LANGUAGE]
>   - ```cmd
>     FOR %L IN (de en es fr it pt-BR) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] )" "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\System\System_CareerStory\STT_EventPalceName.json" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json")
>     FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game" /s /b /a-d /o:n`) DO (
>       jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; if ( .StringTable.KeysToEntries.[$k] != "" ) then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) else ( del( .StringTable.KeysToEntries.[$k] ) ) end )" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.json" > "%F.temp"
>     )
>     ```
> .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k]
>    - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) | [.]" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
> 
>    - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; if ( .StringTable.KeysToEntries.[$k] != \"\" ) then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) else ( del( .StringTable.KeysToEntries.[$k] ) ) end ) | [.]" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
>      - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\StringTables\Game\Battle\STT_BattleSysMsg_LOG.json" /s /b /a-d /o:n`) DO (jq -n "input[] as $old | input[] as $new | reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k ( $old; if ( .StringTable.KeysToEntries.[$k] != "" ) then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] ) else ( del( .StringTable.KeysToEntries.[$k] ) ) end ) | [.]" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
> 
>    - FOR %L IN (de en es fr it pt-BR) DO ( FOR /F "usebackq delims=" %F IN (`dir "R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\" /s /b /a-d /o:n`) DO (jq -n --from-file "StringTables_JsonAsAsset_03.jq" "%F" "R:\Temp\Exports\Game\Content\i18n\StringTables.%L.json" > "%F.temp" && move /Y "%F.temp" "%F" ) )
> 
> ## 04
> 
> - UE4Editor > JsonAsAsset > StringTables
>   - `Execute JsonAsAsset` 
>     - Inside `R:\Temp\Exports\Game\Content\i18n\%L\StringTables\Game\`, search for `.json`
>     - Select all, open, then wait for everything to be created / updated 
> 
> ## 05
> 
> - `"C:\Users\Ryzen3\Desktop\pakchunk0-{PLATFORM}_LocResBuilder_P.pak\!   pakchunk0-WindowsNoEditor_LocResBuilder_P.pak.20251221.bat"`
>   - `CALL :RunUAT ja`
> 
> ## NOTES
> 
> - `STT_BattleAbiMsg`
>   - {0} / {1} are rendered literally
> 
> </details>

> [!NOTE]
>
> # 2025.12.29
> 
> <details><summary><h2>`/Game/i18n/{LANGUAGE}/StringTables/*` to `/Game/StringTables/*`</h2></summary>
> 
> - Automate: 
>   - importing output of `Game.locres.yaml_to_StringTables.csv.bat` to `UE4Editor/Holiday/Content/Game/i18n/{LANGUAGE}/StringTables/*`
>   - copying / drag'n'dropping files from `UE4Editor/Holiday/Content/Game/i18n/{LANGUAGE}/StringTables/*` to `UE4Editor/Holiday/Content/Game/StringTables/*`
>   - `UE4Editor/Holiday/Content/Game/StringTables/*` > responseFile.txt
> 
> - Copy new `NonAssets` to `UE4Editor\Content\NonAssets`
>   - a
>   - `cls && "%UE_4.27%\..\..\..\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -archive -archivedirectory="R:/DEBUG/releases/UE4Editor" -clean -clientconfig=Shipping -compressed -cook -ddc=InstalledDerivedDataBackendGraph -installed -iostore -manifests -nocompile -nocompileeditor -nodebuginfo -nop4 -package -pak -prereqs -project=F:/Test/Holiday/Holiday.uproject -skipbuildeditor -SkipCookingEditorContent -skipstage -target=Holiday -targetplatform=Win64 -ue4exe="%UE_4.27%\..\..\..\Engine\Binaries\Win64\UE4Editor.exe" -Cmd.exe -utf8output`
> 
> </details>

> [!NOTE]
>
> # 2025.12.20
> 
> <details><summary><h2>`--prettyPrint`</h2></summary>
> 
> - `--prettyPrint` , temp fix for emojis breaking yq's output file
> 
> ```cmd
> cls && yq "(.. | select(tag == \"!!str\")) |= ( sub(\"🔴\", \"__RED__\") | sub(\"🟡\", \"__YELLOW__\") | sub(\"🟢\", \"__GREEN__\") )" "Game.locres.yaml" -o json --prettyPrint --yaml-fix-merge-anchor-to-spec > "R:\Game.locres.prettyPrint.yaml"
> cls && yq "(.. | select(tag == \"!!str\")) |= ( sub(\"🔴\", \"__RED__\") | sub(\"🟡\", \"__YELLOW__\") | sub(\"🟢\", \"__GREEN__\") )" "ETP.yaml" -o json --prettyPrint --yaml-fix-merge-anchor-to-spec > "R:\ETP.prettyPrint.yaml"
> ```
> 
> ```regex
> :: FIND
> __RED__
> :: REPLACE
> 🔴
> ```
> 
> ```regex
> :: FIND
> __YELLOW__
> :: REPLACE
> 🟡
> ```
> 
> ```regex
> :: FIND
> __GREEN__
> :: REPLACE
> 🟢
> ```
> 
> ```regex
> :: FIND
> (?<=\$comments: )'(.*)'$
> :: REPLACE
> "$1"
> ```
> 
> </details>

> [!NOTE]
>
> # 2025.12.16
> 
> eventTextCsZ11s02:
> - re-add ko zh-Han

> [!NOTE]
>
> # 2025.12.15
>
> - `Switch`
>   - `FontFace'/Game/UI/Font/Garrick-Bold_RUBYx2.Garrick-Bold_RUBYx2'`
>   - `Loading Policy` = `Lazy Load`
>     - Font is saved to `pakchunk0-Switch__UE4Editor_P.pak`, for preservation purposes
>
> - `WindowsNoEditor`
>   - `FontFace'/Game/UI/Font/Garrick-Bold_RUBYx2.Garrick-Bold_RUBYx2'`
>   - `Loading Policy` = `Inline`
>     - OR ELSE FONTS ARE NOT LOADED IN-GAME
>
> <details><summary><h2>JAPAN - include StringTables</h2></summary>
>
> | Namespace                  | Reference Path                                                                                                       | comments                                                 |
> | :------------------------- | :------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------- |
> | STT_ActionMsg_Log1         | StringTable'/Game/StringTables/Game/Battle/ActionMsg/log/STT_ActionMsg_Log1.STT_ActionMsg_Log1'                      | - [x] Battle - {*ActionMsg.Simple.Used}! - ACTIVE        |
> | STT_ActionMsg_Log3         | StringTable'/Game/StringTables/Game/Battle/ActionMsg/log/STT_ActionMsg_Log3.STT_ActionMsg_Log3'                      | - [x] Battle - ACTIVE                                    |
> | STT_ActionMsg_Simple1      | StringTable'/Game/StringTables/Game/Battle/ActionMsg/Simple/STT_ActionMsg_Simple1.STT_ActionMsg_Simple1'             | - [x] Battle - {*ActionMsg.Simple.Used}! - LOG           |
> | STT_ActionMsg_Simple3      | StringTable'/Game/StringTables/Game/Battle/ActionMsg/Simple/STT_ActionMsg_Simple3.STT_ActionMsg_Simple3'             | - [x] Battle - LOG                                       |
> | STT_BattleSysMsg           | StringTable'/Game/StringTables/Game/Battle/STT_BattleSysMsg.STT_BattleSysMsg'                                        | - [x] Battle - Monster(s) {ACTION}! - ACTIVE             |
> | STT_BattleSysMsg_LOG       | StringTable'/Game/StringTables/Game/Battle/STT_BattleSysMsg_LOG.STT_BattleSysMsg_LOG'                                | - [x] Battle - Monster(s) {ACTION}! - LOG                |
> | STT_Boukennosho_DLC_Text   | StringTable'/Game/StringTables/Game/System/System_Title/STT_Boukennosho_DLC_Text.STT_Boukennosho_DLC_Text'           | - [x] DLC                                                |
> | STT_Career_StoryUISys      | StringTable'/Game/StringTables/Game/System/System_UI/STT_Career_StoryUISys.STT_Career_StoryUISys'                    | - [x] The Story So Far's Main Story menus in records     |
> | STT_CareerStoryVer1        | StringTable'/Game/StringTables/Game/System/System_CareerStory/STT_CareerStoryVer1.STT_CareerStoryVer1'               | - [x] The Story So Far's contents, Ver. 1                |
> | STT_CareerStoryVer2        | StringTable'/Game/StringTables/Game/System/System_CareerStory/STT_CareerStoryVer2.STT_CareerStoryVer2'               | - [x] The Story So Far's contents, Ver. 2                |
> | STT_CommonItem             | StringTable'/Game/StringTables/Game/Battle/STT_CommonItem.STT_CommonItem'                                            | - [x] Items, materials, etc.                             |
> | STT_EventPalceName         | StringTable'/Game/StringTables/Game/System/System_CareerStory/STT_EventPalceName.STT_EventPalceName'                 | - [x] The Story So Far's titles                          |
> | STT_Monster_Tips1_ver1     | StringTable'/Game/StringTables/Game/System/System_UI/MonsterTips/STT_Monster_Tips1_ver1.STT_Monster_Tips1_ver1'      | - [x] Monster trivia (1/2), Ver. 1                       |
> | STT_Monster_Tips1_ver2     | StringTable'/Game/StringTables/Game/System/System_UI/MonsterTips/STT_Monster_Tips1_ver2.STT_Monster_Tips1_ver2'      | - [x] Monster trivia (1/2), Ver. 2                       |
> | STT_Monster_Tips2_ver1     | StringTable'/Game/StringTables/Game/System/System_UI/MonsterTips/STT_Monster_Tips2_ver1.STT_Monster_Tips2_ver1'      | - [x] Monster trivia (2/2), Ver. 1                       |
> | STT_Monster_Tips2_Ver2     | StringTable'/Game/StringTables/Game/System/System_UI/MonsterTips/STT_Monster_Tips2_Ver2.STT_Monster_Tips2_Ver2'      | - [x] Monster trivia (2/2), Ver. 2                       |
> | STT_Quest_ItemGet          | StringTable'/Game/StringTables/Game/System/System_QuestList/STT_Quest_ItemGet.STT_Quest_ItemGet'                     | - [x] Quest-related items dialog                         |
> | STT_QuestListDetail        | StringTable'/Game/StringTables/Game/System/System_QuestList/STT_QuestListDetail.STT_QuestListDetail                  | - [x] Quest details                                      |
> | STT_QuestListName          | StringTable'/Game/StringTables/Game/System/System_QuestList/STT_QuestListName.STT_QuestListName                      | - [x] Quest names                                        |
> | STT_QuestListSeries        | StringTable'/Game/StringTables/Game/System/System_QuestList/STT_QuestListSeries.STT_QuestListSeries                  | - [x] Quest series names                                 |
> | STT_SkillName              | StringTable'/Game/StringTables/Game/System_Skill/STT_SkillName.STT_SkillName'                                        | - [x] Battle - {SPELL} - ACTIVE                          |
> | STT_System_Charamake       | StringTable'/Game/StringTables/Game/System/System_Charamake/STT_System_Charamake.STT_System_Charamake'               | - [x] Character Customization, rebirth job descriptions  |
> | STT_System_Common          | StringTable'/Game/StringTables/Game/System/System_Common/STT_System_Common.STT_System_Common'                        | - [x] In-game menu UI                                    |
> |                            |                                                                                                                      |                                                          |
> | STT_Battle_Levelup         | StringTable'/Game/StringTables/Game/System/System_Battle/STT_Battle_Levelup.STT_Battle_Levelup'                      | - [ ] Battle - Leveled Up!                               |
> | STT_BattleSkillItem        | StringTable'/Game/StringTables/Game/Battle/STT_BattleSkillItem.STT_BattleSkillItem'                                  | - [ ] Battle - {SPELL} - ACTIVE                          |
> | STT_Quest_PerticularReward |                                                                                                                      | - [ ] Quest completion rewards                           |
> | STT_QuestListCategory      |                                                                                                                      | - [ ] Quest categories (Main/Sub Story, Job Quest, etc.) |
> | STT_System_CharamakeSys    | StringTable'/Game/StringTables/Game/System/System_Charamake/STT_System_CharamakeSys.STT_System_CharamakeSys'         | - [ ] Character Customization, rebirth job descriptions? |
> |                            |                                                                                                                      | - [ ]                                                    |
>
> ## Game.locres.yaml > StringTables.csv ( JAPAN, UI not fixed by `Game.locres` )
>
> ### `StringTables_csv.jq`
>
> ```js
> .[$FILENAME] as $obj
> | reduce ( $obj | keys_unsorted )[] as $k (
>     { "Key":"SourceString" };
>     .[$k] += (
>         if ( $obj[$k].[$LANGUAGE] != "" )
>         then ( $obj[$k].[$LANGUAGE] )
>         else ( $obj[$k].["ja"] )
>         end
>     )
> )
> | to_entries[] | [.key, .value]
> | @csv
> ```
>
> ### `Game.locres.yaml_to_StringTables.csv.bat`
>
> ```bat
> @ECHO OFF
> 
> FOR %%L IN (de es en fr it pt-BR) DO (
> 	IF NOT EXIST "%~dp0jq\%%L\" (
> 		mkdir "%~dp0jq\%%L\"
> 	)
> 	FOR %%F IN (STT_Boukennosho_DLC_Text STT_Career_StoryUISys STT_CareerStoryVer1 STT_CareerStoryVer2 STT_CommonItem STT_EventPalceName STT_Monster_Tips1_ver1 STT_Monster_Tips2_ver1 STT_Monster_Tips1_ver2 STT_Monster_Tips2_Ver2 STT_Quest_ItemGet STT_QuestListDetail STT_QuestListName STT_QuestListSeries STT_System_Charamake STT_System_Common) DO (
> 		ECHO:
> 		ECHO creating " %~dp0jq\%%L\%%F.csv "
> 		ECHO:
> 		yq eval ^
> 		"D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\Steam\App_ID-1358750\Build_ID-14529657\pakchunk0-WindowsNoEditor.pak\Game\Content\Localization\Game\Game.locres.yaml" ^
> 		-o json ^
> 		--yaml-fix-merge-anchor-to-spec ^
> 		| jq ^
> 		--arg FILENAME "%%F" ^
> 		--arg LANGUAGE "%%L" ^
> 		--from-file StringTables_csv.jq ^
> 		--raw-output ^
> 		> "%~dp0jq\%%L\%%F.csv"
> 		type "%~dp0jq\%%L\%%F.csv"
> 		ECHO:
> 		ECHO ----------------------------------------------------------------------------------------------------
> 		ECHO:
> 	)
> )
> 
> PAUSE
> ```
> 
> ### ( MAYBE ) !ETP! > !newETP!, but for `/i18n/{LANGUAGE}/StringTables/` > `responseFile.txt`
> 
> - StringTables are not supported by `L10N`, but are by `i18n`
> 
> - `../../../{DESTINATION}/Content/i18n/{LANGUAGE}/StringTables/Game/**/{StringTable}.uasset`
> - `../../../{DESTINATION}/Content/StringTables/Game/**/{StringTable}.uasset`
> ```bat
> SETLOCAL EnableDelayedExpansion
> 
> FOR /F "usebackq delims=" %%A IN (`dir "{PROJECT_DIR}\Holiday\Content\StringTables\Game\" /a-d /b /o:n /s`) DO (
>   SET StringTable=%%A
>   SET newStringTable=!StringTable:i18n\%%L\=!
>   SET newerStringTable=!newStringTable:\=/!
> )
> 
> ENDLOCAL
> 
> PAUSE
> ```
> 
> ```cmd
> ECHO "{PROJECT_DIR}\Holiday\Content\i18n\%%L\StringTables\Game\**\{StringTable}.uasset" "../../../{DESTINATION}/Content/StringTables/Game/**/{StringTable}.uasset" > responseFile.txt
> ```
> 
> </details>

> [!WARNING]
>
> <details><summary><h1>.github/workflows/Create_Latest_Release.yml</h1></summary>
>
>   <details><summary><h3>`Game.locres.json` > `OUTPUT/StringTables/${LANGUAGE}/**/*.csv`</h3></summary>
>
> - JQ/YQ Filter Command aka `yq_filter-2.txt`
>
> ```js
> ####################################################################################################
> ##### YQ
> ####################################################################################################
> #strenv(LANGUAGE) as $LANGUAGE
> #| [
> #	to_entries
> #	| .[] as $obj
> #	| map($obj.key)[] as $ns ireduce (
> #		{};
> #		($obj.value | keys)[] as $k ireduce (
> #			{"Filename": $ns, "Key": "SourceString"};
> #			####################################################################################################
> #			##### If-Then-Else-End not implemented in YQ yet
> #			##### see https://github.com/mikefarah/yq/issues/2381#issuecomment-2965101058
> #			#.[$k] += (
> #			#
> #			#	if $obj.value[$k][$LANGUAGE] != ""
> #			#	then $obj.value[$k][$LANGUAGE]
> #			#	else $obj.value[$k]["ja"]
> #			#	end
> #			#)
> #			####################################################################################################
> #		)
> #	)
> #	| .
> #]
> ####################################################################################################
> ##### JQ
> ####################################################################################################
> [
> 	to_entries
> 	| .[] as $obj
> 	| reduce ( map($obj.key) )[] as $ns (
> 		{};
> 		reduce ($obj.value | keys_unsorted)[] as $k (
> 			{"Filename": $ns, "Key": "SourceString"};
> 			.[$k] += (
> 				if ($obj.value[$k][$LANGUAGE] != "")
> 				then ($obj.value[$k][$LANGUAGE])
> 				else ($obj.value[$k]["ja"])
> 				end
> 			)
> 		)
> 	)
> 	| .
> ]
> ####################################################################################################
> ```
>
> - Job `Create StringTable/**/*.csv`
> <details><summary><h4>Less Sort</h4></summary>
>
> ```bash
> clear && \
> cd ${github_workspace___TBD} && \
> for LANGUAGE in de en es fr it ja ko pt-BR zh-Hans zh-Hant; do \
> 	export LANGUAGE=${LANGUAGE} && \
> 	mkdir -p "${github_workspace___TBD}/StringTables/${LANGUAGE}/json" && \
> 	cd "${github_workspace___TBD}/StringTables/${LANGUAGE}/json" && \
> 	jq --arg LANGUAGE ${LANGUAGE} \
> 	-r \
> 	--from-file "${github_workspace___TBD}/yq_filter-2.txt" \
> 	"${github_workspace___TBD}/Game.locres.json" \
> 	| yq -r '.[]' \
> 	-s '.Filename, del(.Filename)' -o=json -I2
> 	cd "${github_workspace___TBD}/StringTables/" && \
> 	for FILE in $(ls "${github_workspace___TBD}/StringTables/${LANGUAGE}/json/"); do \
> 		#echo -e "$FILE"
> 		jq -r '(. | keys_unsorted)[] as $k | [$k,(.[$k] | gsub("(\r)?\n";"\\n") )] | @csv' \
> 		"${github_workspace___TBD}/StringTables/${LANGUAGE}/json/${FILE}" \
> 		> "${github_workspace___TBD}/StringTables/${LANGUAGE}/${FILE%.*}.csv"
> 		if [[ ${FILE%.*} == @(lpWindowName) ]]; then
> 			mkdir -p "${github_workspace___TBD}/StringTables/${LANGUAGE}/test_folder_001" && \
> 			mv "${github_workspace___TBD}/StringTables/${LANGUAGE}/${FILE%.*}.csv" \
> 			"${github_workspace___TBD}/StringTables/${LANGUAGE}/test_folder_001/${FILE%.*}.csv";
> 		elif [[ ${FILE%.*} == @(Test_NameSpace) ]]; then
> 			mkdir -p "${github_workspace___TBD}/StringTables/${LANGUAGE}/test_folder_002" && \
> 			mv "${github_workspace___TBD}/StringTables/${LANGUAGE}/${FILE%.*}.csv" \
> 			"${github_workspace___TBD}/StringTables/${LANGUAGE}/test_folder_002/${FILE%.*}.csv";
> 		fi
> 	done;
> 	rm -r "${github_workspace___TBD}/StringTables/${LANGUAGE}/json/"
> done;
> ```
>
>   </details>
>   
>   <details><summary><h4>More Sort</h4></summary>
>   
>   ```bash
>   clear && \
>   cd ${github_workspace} && \
>   for LANGUAGE in de en es fr it ja ko pt-BR zh-Hans zh-Hant; do \
>   	export LANGUAGE=${LANGUAGE} && \
>   	echo -e "Creating ${LANGUAGE}/**/*.json" && \
>   	mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_json" && \
>   	cd "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_json" && \
>   	jq --arg LANGUAGE ${LANGUAGE} \
>   	-r \
>   	--from-file "${github_workspace}/yq_filter-2.txt" \
>   	"${github_workspace}/Game.locres.json" \
>   	| yq -r '.[]' \
>   	-s '.Filename, del(.Filename)' -o=json -I2
>   	cd "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game" && \
>   	echo -e "Creating ${LANGUAGE}/**/*.csv" && \
>   	for FILE in $(ls "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_json/"); do \
>   		#echo -e "$FILE"
>   		jq -r '(. | keys_unsorted)[] as $k | [$k,(.[$k] | gsub("(\r)?\n";"\\n") )] | @csv' \
>   		"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_json/${FILE}" \
>   		> "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv"
>   		if [[ ${FILE%.*} == @(Test_NameSpace) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/test_folder_001" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/test_folder_001/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Battle_UI|STT_System_Location|STT_System_Title|STT_System_UI|STT_System_WeaponTypes|STT_Sytem_UI_Status) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(___) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/___" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/___/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(PAL_BattleMessage|STT_AccessoryItem|STT_BattleAbiMsg|STT_BattleActionItem|STT_BattleGuestName|STT_BattleMagicItem|STT_BattleMonsterName|STT_BattleOddMsg_MCE_BALOON|STT_BattleSkillItem|STT_BattleSpecialSkillItem|STT_BattleSysMsg|STT_BattleSysMsg_LOG|STT_CommonItem|STT_ConditionViewer|STT_DaijinamonoItem|STT_Equip_OddStatus_Name|STT_EquipItem|STT_EventMonsterName|STT_MonsterMercenary|STT_MonsterTarotArcana|STT_MonsterTarotDeck|STT_MonsterTarotMonster|STT_ToolActionItem|STT_WeaponItem) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_ActionMsg_Balloon1|STT_ActionMsg_Balloon2|STT_ActionMsg_Balloon3|STT_ActionMsg_Balloon4|STT_ActionMsg_Balloon5|STT_ActionMsg_Balloon6|STT_ActionMsg_Balloon7|STT_ActionMsg_Balloon8|STT_ActionMsg_Balloon9|STT_ActionMsg_Balloon10|STT_ActionMsg_Balloon11|STT_ActionMsg_Balloon12|STT_ActionMsg_Balloon13|STT_ActionMsg_Balloon14|STT_ActionMsg_Balloon15) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/ActionMsg/Balloon" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/ActionMsg/Balloon/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_ActionMsg_Log1|STT_ActionMsg_Log10|STT_ActionMsg_Log11|STT_ActionMsg_Log12|STT_ActionMsg_Log13|STT_ActionMsg_Log14|STT_ActionMsg_Log15|STT_ActionMsg_Log2|STT_ActionMsg_Log3|STT_ActionMsg_Log4|STT_ActionMsg_Log5|STT_ActionMsg_Log6|STT_ActionMsg_Log7|STT_ActionMsg_Log8|STT_ActionMsg_Log9) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/ActionMsg/log" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/ActionMsg/log/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_ActionAvgMsg_Simple1|STT_ActionAvgMsg_Simple10|STT_ActionAvgMsg_Simple11|STT_ActionAvgMsg_Simple12|STT_ActionAvgMsg_Simple13|STT_ActionAvgMsg_Simple14|STT_ActionAvgMsg_Simple15|STT_ActionAvgMsg_Simple2|STT_ActionAvgMsg_Simple3|STT_ActionAvgMsg_Simple4|STT_ActionAvgMsg_Simple5|STT_ActionAvgMsg_Simple6|STT_ActionAvgMsg_Simple7|STT_ActionAvgMsg_Simple8|STT_ActionAvgMsg_Simple9|STT_ActionMsg_Simple1|STT_ActionMsg_Simple10|STT_ActionMsg_Simple11|STT_ActionMsg_Simple12|STT_ActionMsg_Simple13|STT_ActionMsg_Simple14|STT_ActionMsg_Simple15|STT_ActionMsg_Simple2|STT_ActionMsg_Simple3|STT_ActionMsg_Simple4|STT_ActionMsg_Simple5|STT_ActionMsg_Simple6|STT_ActionMsg_Simple7|STT_ActionMsg_Simple8|STT_ActionMsg_Simple9|STT_ActionSumMsg_Simple1|STT_ActionSumMsg_Simple10|STT_ActionSumMsg_Simple11|STT_ActionSumMsg_Simple12|STT_ActionSumMsg_Simple13|STT_ActionSumMsg_Simple14|STT_ActionSumMsg_Simple15|STT_ActionSumMsg_Simple2|STT_ActionSumMsg_Simple3|STT_ActionSumMsg_Simple4|STT_ActionSumMsg_Simple5|STT_ActionSumMsg_Simple6|STT_ActionSumMsg_Simple7|STT_ActionSumMsg_Simple8|STT_ActionSumMsg_Simple9) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/ActionMsg/Simple" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/ActionMsg/Simple/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_BattleOddAvgMsg_AE_SYS|STT_BattleOddAvgMsg_AEE_SYS|STT_BattleOddAvgMsg_AEP_SYS|STT_BattleOddAvgMsg_AP_SYS|STT_BattleOddAvgMsg_AXE_SYS|STT_BattleOddAvgMsg_AXP_SYS|STT_BattleOddAvgMsg_DAE_SYS|STT_BattleOddAvgMsg_DAP_SYS|STT_BattleOddAvgMsg_DOE_SYS|STT_BattleOddAvgMsg_DOP_SYS|STT_BattleOddAvgMsg_MCEE_SYS|STT_BattleOddAvgMsg_MCEP_SYS|STT_BattleOddAvgMsg_RSE_SYS|STT_BattleOddAvgMsg_RSP_SYS|STT_BattleOddMsg_AE_BALOON|STT_BattleOddMsg_AE_LOG|STT_BattleOddMsg_AE_SYS|STT_BattleOddMsg_AEE_BALOON|STT_BattleOddMsg_AEE_LOG|STT_BattleOddMsg_AEE_SYS|STT_BattleOddMsg_AEP_BALOON|STT_BattleOddMsg_AEP_LOG|STT_BattleOddMsg_AEP_SYS|STT_BattleOddMsg_AFP_BALOON|STT_BattleOddMsg_AFP_SYS|STT_BattleOddMsg_AP_BALOON|STT_BattleOddMsg_AP_LOG|STT_BattleOddMsg_AP_Sys|STT_BattleOddMsg_AXE_BALOON|STT_BattleOddMsg_AXE_LOG|STT_BattleOddMsg_AXE_SYS|STT_BattleOddMsg_AXP_BALOON|STT_BattleOddMsg_AXP_LOG|STT_BattleOddMsg_AXP_SYS|STT_BattleOddMsg_DAE_BALOON|STT_BattleOddMsg_DAE_LOG|STT_BattleOddMsg_DAE_SYS|STT_BattleOddMsg_DAP_BALOON|STT_BattleOddMsg_DAP_LOG|STT_BattleOddMsg_DAP_SYS|STT_BattleOddMsg_DOE_BALOON|STT_BattleOddMsg_DOE_LOG|STT_BattleOddMsg_DOE_SYS|STT_BattleOddMsg_DOP_BALOON|STT_BattleOddMsg_DOP_LOG|STT_BattleOddMsg_DOP_SYS|STT_BattleOddMsg_MCE_SYS|STT_BattleOddMsg_MCEE_BALOON|STT_BattleOddMsg_MCEE_LOG|STT_BattleOddMsg_MCEE_SYS|STT_BattleOddMsg_MCEP_BALOON|STT_BattleOddMsg_MCEP_LOG|STT_BattleOddMsg_MCEP_SYS|STT_BattleOddMsg_RS_BALOON|STT_BattleOddMsg_RS_SYS|STT_BattleOddMsg_RSE_BALOON|STT_BattleOddMsg_RSE_LOG|STT_BattleOddMsg_RSE_SYS|STT_BattleOddMsg_RSP_BALOON|STT_BattleOddMsg_RSP_LOG|STT_BattleOddMsg_RSP_SYS|STT_BattleOddSumMsg_AE_SYS|STT_BattleOddSumMsg_AEE_SYS|STT_BattleOddSumMsg_AEP_SYS|STT_BattleOddSumMsg_AP_SYS|STT_BattleOddSumMsg_AXE_SYS|STT_BattleOddSumMsg_AXP_SYS|STT_BattleOddSumMsg_DAE_SYS|STT_BattleOddSumMsg_DAP_SYS|STT_BattleOddSumMsg_DOE_SYS|STT_BattleOddSumMsg_DOP_SYS|STT_BattleOddSumMsg_MCEE_SYS|STT_BattleOddSumMsg_MCEP_SYS|STT_BattleOddSumMsg_RSE_SYS|STT_BattleOddSumMsg_RSP_SYS|STT_OddFunc_PC_Simple|STT_OddStatus_NoAction_Simple|STT_OddStatus_PC_Cancel_Simple|STT_OddStatus_PC_Deactive_Simple|STT_OddStatus_PC_Error_Simple|STT_OddStatus_PC_Grant_Simple) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/OddStatusNormal" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/OddStatusNormal/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_BattleSlideAvgMsg_D1E_SYS|STT_BattleSlideAvgMsg_D1P_SYS|STT_BattleSlideAvgMsg_D2E_SYS|STT_BattleSlideAvgMsg_D2EEX_SYS|STT_BattleSlideAvgMsg_D2P_SYS|STT_BattleSlideAvgMsg_D2PEX_SYS|STT_BattleSlideAvgMsg_FE_SYS|STT_BattleSlideAvgMsg_FP_SYS|STT_BattleSlideAvgMsg_I1E_SYS|STT_BattleSlideAvgMsg_I1P_SYS|STT_BattleSlideAvgMsg_I2E_SYS|STT_BattleSlideAvgMsg_I2EEX_SYS|STT_BattleSlideAvgMsg_I2P_SYS|STT_BattleSlideAvgMsg_I2PEX_SYS|STT_BattleSlideAvgMsg_NEE_SYS|STT_BattleSlideAvgMsg_NEP_SYS|STT_BattleSlideAvgMsg_RSE_SYS|STT_BattleSlideAvgMsg_RSP_SYS|STT_BattleSlideMsg_D1E_BALOON|STT_BattleSlideMsg_D1E_LOG|STT_BattleSlideMsg_D1E_SYS|STT_BattleSlideMsg_D1P_BALOON|STT_BattleSlideMsg_D1P_LOG|STT_BattleSlideMsg_D1P_SYS|STT_BattleSlideMsg_D2E_BALOON|STT_BattleSlideMsg_D2E_LOG|STT_BattleSlideMsg_D2E_SYS|STT_BattleSlideMsg_D2EEX_BALOON|STT_BattleSlideMsg_D2EEX_LOG|STT_BattleSlideMsg_D2EEX_SYS|STT_BattleSlideMsg_D2P_BALOON|STT_BattleSlideMsg_D2P_LOG|STT_BattleSlideMsg_D2P_SYS|STT_BattleSlideMsg_D2PEX_BALOON|STT_BattleSlideMsg_D2PEX_LOG|STT_BattleSlideMsg_D2PEX_SYS|STT_BattleSlideMsg_FE_BALOON|STT_BattleSlideMsg_FE_LOG|STT_BattleSlideMsg_FE_SYS|STT_BattleSlideMsg_FP_BALOON|STT_BattleSlideMsg_FP_LOG|STT_BattleSlideMsg_FP_SYS|STT_BattleSlideMsg_I1E_BALOON|STT_BattleSlideMsg_I1E_LOG|STT_BattleSlideMsg_I1E_SYS|STT_BattleSlideMsg_I1P_BALOON|STT_BattleSlideMsg_I1P_LOG|STT_BattleSlideMsg_I1P_SYS|STT_BattleSlideMsg_I2E_BALOON|STT_BattleSlideMsg_I2E_LOG|STT_BattleSlideMsg_I2E_SYS|STT_BattleSlideMsg_I2EEX_BALOON|STT_BattleSlideMsg_I2EEX_LOG|STT_BattleSlideMsg_I2EEX_SYS|STT_BattleSlideMsg_I2P_BALOON|STT_BattleSlideMsg_I2P_LOG|STT_BattleSlideMsg_I2P_SYS|STT_BattleSlideMsg_I2PEX_BALOON|STT_BattleSlideMsg_I2PEX_LOG|STT_BattleSlideMsg_I2PEX_SYS|STT_BattleSlideMsg_NEE_BALOON|STT_BattleSlideMsg_NEE_LOG|STT_BattleSlideMsg_NEE_SYS|STT_BattleSlideMsg_NEP_BALOON|STT_BattleSlideMsg_NEP_LOG|STT_BattleSlideMsg_NEP_SYS|STT_BattleSlideMsg_RSE_BALOON|STT_BattleSlideMsg_RSE_LOG|STT_BattleSlideMsg_RSE_SYS|STT_BattleSlideMsg_RSP_BALOON|STT_BattleSlideMsg_RSP_LOG|STT_BattleSlideMsg_RSP_SYS|STT_BattleSlideSumMsg_D1E_SYS|STT_BattleSlideSumMsg_D1P_SYS|STT_BattleSlideSumMsg_D2E_SYS|STT_BattleSlideSumMsg_D2EEX_SYS|STT_BattleSlideSumMsg_D2P_SYS|STT_BattleSlideSumMsg_D2PEX_SYS|STT_BattleSlideSumMsg_FE_SYS|STT_BattleSlideSumMsg_FP_SYS|STT_BattleSlideSumMsg_I1E_SYS|STT_BattleSlideSumMsg_I1P_SYS|STT_BattleSlideSumMsg_I2E_SYS|STT_BattleSlideSumMsg_I2EEX_SYS|STT_BattleSlideSumMsg_I2P_SYS|STT_BattleSlideSumMsg_I2PEX_SYS|STT_BattleSlideSumMsg_NEE_SYS|STT_BattleSlideSumMsg_NEP_SYS|STT_BattleSlideSumMsg_RSE_SYS|STT_BattleSlideSumMsg_RSP_SYS|STT_DeactiveMsg_MON_Simple|STT_DeactiveMsg_PC_Simple|STT_GrantFailMsg_MON_Simple|STT_GrantFailMsg_PC_Simple|STT_SlideMsg_MON_Simple_Stage0|STT_SlideMsg_PC_Simple_Stage0|STT_SlideMsg_PC_TimeEx_Minus_Simple|STT_SlideMsg_PC_TimeEx_PLUS_Simple) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/SlideMsg" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Battle/SlideMsg/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(Event_Common) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Event/Event_Common" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Event/Event_Common/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(ASIA_DLC|lpWindowName|SYSTEM_LOACALIZATION|WeaponTypeForBugFix) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Localization" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Localization/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Charamake_Female_NoLocalization|STT_Charamake_Male_NoLocalization) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Localization/NoTranslation" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/Localization/NoTranslation/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Profile_Word|STT_Syougou) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Achievement" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Achievement/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Battle_Levelup) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Battle" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Battle/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_CareerStoryVer1|STT_CareerStoryVer2|STT_EventPalceName|STT_LoadingArasujiVer1|STT_LoadingArasujiVer2) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_CareerStory" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_CareerStory/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_Casino) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Casino" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Casino/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Charamake_Female|STT_Charamake_Male|STT_CharamakeColors|STT_System_Charamake|STT_System_CharamakeSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Charamake" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Charamake/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_Common) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Common" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Common/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Support_BrowseSys|STT_Tips_Category|STT_Tips_Content) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Content" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Content/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_Craftsman) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Craftsman" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Craftsman/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_DungeonMagicNPC) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Dungeon" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Dungeon/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Equip_Coordinate|STT_System_Equip) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Equip" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Equip/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilityBankNpc|STT_FacilityBankSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Bank" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Bank/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilityBarNpc|STT_FacilityBarSys|STT_IraisyoArasuji|STT_IraisyoMonsterType|STT_IraisyoNPCNameBase|STT_IraisyoNPCNameRuby|STT_ResurrectionTextList) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Bar" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Bar/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_BarMonsterSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_BarMonster" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_BarMonster/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_CasinoCoin) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_CasinoCoin" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_CasinoCoin/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_Facility_ChurchNpc|STT_System_Facility_ChurchSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Church" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Church/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilityColoringNpc|STT_FacilityColoringSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Coloring" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Coloring/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Colosseum_NPC|STT_Colosseum_SYS) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Colosseum" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Colosseum/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilityConciergeNpc|STT_FacilityConciergeSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Concierge" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Concierge/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FaciliityDolboardSys|STT_FacilityDolboardNpc) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Dolboard" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Dolboard/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_JobChangeNpc|STT_JobChangeSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_JobChange" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_JobChange/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilitySalonNpc) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Salon" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Salon/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilitySubjugationNpc|STT_FacilitySubjugationSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Subjugation" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Subjugation/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FacilitySynthesisNpc|STT_FacilitySynthesisSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Synthesis" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Facility/Facility_Synthesis/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_FieldDoraky|STT_FieldLog|STT_FieldMapSys|STT_FieldProcess) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Field" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Field/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Fishing|STT_FishingAction|STT_FishingExchangeNPC|STT_FishingMasterNPC|STT_FishingSys|STT_SystemFishingBook|STT_SystemFishingFish) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Fishing" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Fishing/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_GameOption|STT_KeyboardSetting|STT_KeyboardSettingKeyString) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_GameOption" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_GameOption/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Emote) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Gesture" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Gesture/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_ItabaeAlbum) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_ItabaeAlbum" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_ItabaeAlbum/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_LoadingTips) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Loading" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Loading/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_SystemDragonNpc|STT_SystemDragonSys|STT_SystemTrainNpc|STT_SystemTrainSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Move" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Move/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_NpcInfo|STT_PartyMainSys|STT_PT_InOut|STT_PT_Talk) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Party" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Party/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Quest_ItemGet|STT_Quest_PerticularReward|STT_QuestList|STT_QuestListDetail|STT_QuestListName|STT_QuestListSeries|STT_SystemQuest) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_QuestList" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_QuestList/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_Shop_Dougu_Sys|STT_System_Shop_DouguNpc|STT_System_Shop_InnNpc|STT_System_Shop_Other) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Shop" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Shop/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_ItemExplanation|STT_ItemName|STT_MagicExplanation|STT_MagicName|STT_MasteryItems|STT_OddStatusExplanation|STT_OddStatusName|STT_SkillExplanation|STT_SkillName|STT_SkillupExplanation|STT_SkillupName|STT_SpecialExplanation|STT_SpecialName|STT_System_Skill) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Skill" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Skill/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_TinyMedals|STT_TinyMedalsWindow) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_TinyMedals" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_TinyMedals/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Boukennosho_DLC_Text|STT_Restricted_GamePlay|STT_Title_Boukennosho) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Title" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Title/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Battle_Option|STT_Career_StoryUISys|STT_ConvinientMainSys|STT_FullCureSys|STT_ItemListSys|STT_MainUISys|STT_SenrekUIiSys|STT_System_ProfileWord|STT_UIDouguSys|STT_UIJumonSys|STT_UIShiraberuSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_UI" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_UI/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_Monster_Tips1_ver1|STT_Monster_Tips1_ver2|STT_Monster_Tips2_ver1|STT_Monster_Tips2_Ver2) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_UI/MonsterTips" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_UI/MonsterTips/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_WarpBraveStoneSys|STT_WarpRiremitoSys|STT_WarpRuraSys) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Warp" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System/System_Warp/${FILE%.*}.csv";
>   		elif [[ ${FILE%.*} == @(STT_System_Shop_Dougu) ]]; then
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System_Shop" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/System_Shop/${FILE%.*}.csv";
>   		else
>   			mkdir -p "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_TBD_" && \
>   			mv "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/${FILE%.*}.csv" \
>   			"${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_TBD_/${FILE%.*}.csv";
>   		fi
>   	done;
>   	rm -r "${github_workspace}/BUILD/staging/${LANGUAGE}/Game/Content/StringTables/Game/_json/"
>   done;
>   ```
>   
>   </details>
>   
>   - Takes ~3min per LANGUAGE
>   - `zip -uj StringTables`, compresses down to ~20% of original total filesize 
>     - To be uploaded with GitHub release, then UE4Editor for easier StringTable reimports
>
>   </details>
>
>   <details><summary><h3>PS4 `.pkg`</h3></summary>
>
> - Before `Creating responseFile--pakchunk0-${PLATFORM}_Latest.pak.txt`
>
> ```bash
> if [[ ${PLATFORM} == @(ps4|ps4_ZZZ) ]]; then
>   # filename patch priority fix
>   # Without renaming, your `ETP*/*.etp` will \*NOT\* show up in game with the current nexusmod's ps4 patch
>   PLATFORM="ps4_ZZZ"
> else
>   PLATFORM="${PLATFORM}"
> fi
> ```
>
> - Job `Build PS4.pkg`, output to `releases` directory with everything else being uploaded
>
> ```bash
> if [[ ${PLATFORM} == @(ps4|ps4_ZZZ) ]]; then
>   echo -e "::group::Creating \033[0;34m pakchunk0-${PLATFORM}_${LANGUAGE}_Dialogue_Latest_P.pak.pkg \033[0m"
>     echo -e \
>     "\
>     pakchunk0-${PLATFORM}_${LANGUAGE}_Dialogue_Latest_P.pak \
>     >>> ___TBD___ PS4 Patch Builder v1.3.3 \
>     "
>     echo -e \
>     "\
>     pakchunk0-${PLATFORM}_${LANGUAGE}_Dialogue_Latest_P.pak \
>     >>> ___TBD___ OpenOrbis/PS4-Toolchain/.../pkgTool.Core \
>     pkg_build \
>     INPUT/Project_${LANGUAGE}.gp4 \
>     OUTPUT/${LANGUAGE}/ \
>     "
>   echo "::endgroup::"
> fi
> ```
>
>   </details>
>
> </details>

# 20250513_1640:

## `Game.locres.json:STT_IraisyoArasuji.EVTXT_SYS_QUESTA_IRAISYO_ARASUJI_11_BASE`

- [x] test {NumCats}|plural(one=cat,other=cats) / `{MonsterNum}|plural(one={MonsterName},other={MonsterName}s)` usability
	- No intended text replacement occurred.

# 20250514_1540:

## `Game.locres.json:STT_IraisyoArasuji.EVTXT_SYS_QUESTA_IRAISYO_ARASUJI_11_BASE`

- https://unreal-garden.com/tutorials/localization-advanced-plurals/
- https://cldr.unicode.org/index/cldr-spec/plural-rules
	- https://www.unicode.org/cldr/charts/47/supplemental/language_plural_rules.html
- [x] test {NumCats}|plural(one=cat,other=cats) / `{MonsterNum}|{MonsterNum}(one={MonsterName},other={MonsterName}s)` usability

# 20250515_0015:

- REGEX - CLDR plurals (Dragon Quest 5 `.\data\MENULIST\b1000000.mpt`) - find `"?(@[0-9])(.*?)(?=@)|@"` - replace `\n\t\t\t\t"$1": "$2",` - Latin extended - find `(?<="value": ")([A-Œ])([A-Œ]+)(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?` - `œ` breaks the regex? - replace `\U$1\L$2$4\U$6\L$7$9\U$11\L$12$14\U$16\L$17$19\U$21\L$22`
<!--
- 20250620: new font
	- fontworks' 筑紫明朝 TsukuMin - https://lets.fontworks.co.jp/fonts/13 - FTT-筑紫明朝 H - horizontal scale: 90% - https://lets.fontworks.co.jp/services/apps-games - フォントワークス LETS license - ¥49,500／1 ライセンス／年 - アプリ・ゲーム組込 - ¥11,000／1 ライセンス
		-->

# 20250630_1800:

- ETP.yaml
	- find `  ja: \|-\n    (<center>)?『風の民　エルフ』\n    \1?自然を愛し　森と共に生きる\n    \1?背に小さな羽を持った　かれんな姿の者たち。\n    \1?<br>\n    \1?伝統と格式を重んじる彼らは\n    \1?世界の理を　深く学び\n    \1?多くの優れた呪文の使い手を　世に送りだした。\n`
		- (08/12) has all languages
		- anchor `&Common_5Tribes_{RACE}` and alias `*Common_5Tribes_{RACE}`
			- `<center>"People of {THING}, {RACE}"`
	- find `[\w\d\s,']{60,}(?!\\n(<br>\\n)?)`
		- newline & `<br>` anything that is too long
	- find `  ja: |-\n    <pc>は\n    岩に　刻まれている文字を　読んだ。`
		- anchor `&Common_examine_engraving` and alias `*Common_examine_engraving`
	- find `この世界で　平和に　暮らしていた`
		- anchor `&Common_examine_engraving_Reidametes` and alias `*Common_examine_engraving_Reidametes`

---

# pakchunk0-{PLATFORM}\_{LANGUAGE}\_Dialogue_Latest_P

## pakchunk0-{PLATFORM}.(pak|ucas|utoc)

- `{PLATFORM}/**/i18n` (Localization)
	- UI graphics for blacksmithing, casino, fishing, lottery, etc.

## pakchunk0-Android_ETC2.(pak|ucas|utoc)

- modify `(localmanifest|cachedbuildmanifest).txt` to load patch?

## pakchunk0-ios.(pak|ucas|utoc)

- modify `(localmanifest|cachedbuildmanifest).txt` to load patch?

## pakchunk0-ps4.(pak|ucas|utoc)

- Jailbreak
	- [@ MODDED WARFARE | PS4 Jailbreak Advice for firmware up to 12.50](https://www.youtube.com/watch?v=vxhXmPcFJ-4&ab_channel=MODDEDWARFARE)
	- [@ MODDED WARFARE | Run your PS4 disc games without the disc on 12.02 or lower](https://www.youtube.com/watch?v=uVJnamKxGsA&ab_channel=MODDEDWARFARE)
	- [@ MODDED WARFARE | PS4 Patch Builder Release/Tutorial](https://www.youtube.com/watch?v=C1EmHMgSfdM&ab_channel=MODDEDWARFARE)
- Create workflow for auto creating patch: `pakchunk0-ps4_{LANGUAGE}_Dialogue_Latest_P.pkg`
	- @ pearlxcore/PS4-PKG-Tool?
	- @ hippie68/ps4-pkg-manager?
	- @ OpenOrbis/LibOrbisPkg
		- [OpenOrbis PS4 Toolchain Part 1 - Overview + Installation](https://youtu.be/pqzsva6OjuE?feature=shared&t=885)
		- [OpenOrbis PS4 Toolchain Part 2 - Creating a Project + Project Structure Overview](https://youtu.be/zboWUuL-IbE?feature=shared&t=395)
		- [OpenOrbis PS4 Toolchain Part 5 - Building and Testing on the PS4](https://www.youtube.com/watch?v=SEfkgUQrzLo&ab_channel=SpecterDev)

<!--
# Dump Games
 <details><summary><h2>kmeps4/PKG-BackUP (No-Open Dumps, But Passcode Protected)</h2></summary>

>  ### PC
>  - 01. Copy `config.cfg` to root of USB
>  - 02. Edit & save `config.cfg` parameters, if applicable:
>  ```ini
>  ;
>  ; PS4-PKG-BACKUP configuration file. Copy it to your USB disk root.
>
>  ; to define a specific cusa/app to copy:
>  ; cusa=0 - Disabled.
>  ; if you want to copy a specific file after payload launched use following example where 12345 it's the ID number of a CUSA. Example:
>  ; cusa=12345 -- This will direct copy CUSA12345.
>  cusa=0
>
>  ; to define method:
>  ; 0 - Copy Game Base Only
>  ; 1 - Copy Game Update Only
>  ; 2 - Copy Game DLC Only
>  ; 3 - Copy Game Base, Update and DLC
>  method=3
>
>  ;If you want to copy a pkg from a emulator like ps1, ps2 psp just change cusa to:
>  ;slus=21978
>  ;rees=xxxx
>  ;ulus=xxxx
>  ;sces=xxxx
>
>  ;Method will behave same as CUSA ones.
>  ```
>  - 03. Safely eject USB, and put into PS4
>
>  ### PS4
>  - 01. Web Browser > Kameleon 900FW Exploit Host website
>    - Jailbreak with GoldHen.
>  - 02. PKG-BackUP v1.2
>    - Game specified in `cusa={TITLE_ID}` will begin to dump to:
>      - `/mnt/usb0/CUSA{TITLE_ID}-app/app.pkg`
>      - `/mnt/usb0/CUSA{TITLE_ID}.(inprogress|complete)`
>    - Displaying an pop-up notification every 5%
>
> </details>

 <details><summary><h2>Itemzflow (Firmware ≥ Required Firmware, But Bypasses Passcode)</h2></summary>

> ### PS4
>  00. Download from Homebrew Store
>  01. Go to game > `Dump All`
>      - Game will run, then dump base app, DLC(s), and update(s)
>
>
> </details>

# Build Patches
 <details><summary><h2>OpenOrbis-PS4-Tools</h2></summary>

> ### PC
>   00. Download the latest [OpenOrbis/OpenOrbis-PS4-Toolchain releases](https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain/releases/)
>   - Install dependencies (libssl)
>     ```bash
>     wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
>     sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
>     ```
>   01. OpenOrbis-PS4-Toolchain/bin/linux/PkgTool.Core
>   - View `PkgTool.Core` Usage
>     ```bash
>     export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 && ./PkgTool.Core
>     ```
>     - `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT` fixes the following issue:
>       <details>
>
>       ```
>       Process terminated. Couldn't find a valid ICU package installed on the system. Set the configuration flag System.Globalization.Invariant to true if you want to run with no globalization support.
>          at System.Environment.FailFast(System.String)
>          at System.Globalization.GlobalizationMode.GetGlobalizationInvariantMode()
>          at System.Globalization.GlobalizationMode..cctor()
>          at System.Globalization.CultureData.CreateCultureWithInvariantData()
>          at System.Globalization.CultureData.get_Invariant()
>          at System.Globalization.CultureInfo..cctor()
>          at System.Globalization.CultureInfo.GetCultureInfoHelper(Int32, System.String, System.String)
>          at System.Globalization.CultureInfo.GetCultureInfo(System.String)
>          at System.Reflection.RuntimeAssembly.GetLocale()
>          at System.Reflection.RuntimeAssembly.GetName(Boolean)
>          at System.Reflection.Assembly.GetName()
>          at System.AppDomain.get_FriendlyName()
>          at PkgTool.Program.Main(System.String[])
>       Aborted (core dumped)
>       ```
>
>       </details>
>
>   - Extract `.pkg` & create `.gp4`[^1]
>     ```bash
>     export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 && ./PkgTool.Core pkg_makegp4 \
>     --passcode 00000000000000000000000000000000 \
>     "./${{ INPUT.pkg }}" \
>     "./${{ OUTPUT DIR }}"
>     ```
>
>   - Edit Project.gp4
>     ```bash
>     ...
>     <volume_ts>🟢v$(date -u +%F )🟢 00:00:00</volume_ts>
>     ...
>     <package content_id="JP0082-CUSA29081_00-HOLIDAY000000000" ... c_date="🟢v$(date -u +%F )🟢" />
>     ...
>     <file targ_path="Holiday/Content/Paks/pakchunk0-ps4_en_Dialogue_Latest_P.pak" orig_path="Holiday/Content/Paks/pakchunk0-ps4_en_Dialogue_Latest_P.pak" />
>     ...
>     <dir targ_name="Holiday">
>       <dir targ_name="Content">
>         <dir targ_name="Paks" />
>     ...
>     ```
>
>   - Overwrite `pakchunk0-ps4_${LANGUAGE}_Dialogue_Latest_P.pak`
>     ```bash
>     cp \
>     ${{ github.workspace }}/BUILD/staging/${LANGUAGE}/pakchunk0-ps4_${LANGUAGE}_Dialogue_Latest_P.pak \
>     ${{ pkg_makegp4 OUTPUT DIR }}/pakchunk0-ps4_${LANGUAGE}_Dialogue_Latest_P.pak
>     ```
>
>   - Build `.pkg`
>     ```bash
>     export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 && ./PkgTool.Core pkg_build \
>     "${{ Project.gp4 }}" \
>     "${{ pkg_build OUTPUT DIR }}"
>     ```
>     - Outputs to `${{ pkg_makegp4 OUTPUT DIR }}/content_id.pkg`
>       - E.g., `JP0082-CUSA29081_00-HOLIDAY000000000.pkg`
>
>   - Zip `.pkg`
>     ```bash
>     if [[ ${PLATFORM} == @(ps4|🔴ps5🔴) ]]; then
>       zip -uj \
>       ${{ github.workspace }}/BUILD/staging/releases/pakchunk0-${PLATFORM}_${LANGUAGE}_Dialogue_Latest_P.pak.zip \
>       ${{ pkg_build OUTPUT DIR }}/JP0082-CUSA29081_00-HOLIDAY000000000.pkg
>     else
>       zip -uj \
>       ${{ github.workspace }}/BUILD/staging/releases/pakchunk0-${PLATFORM}_${LANGUAGE}_Dialogue_Latest_P.pak.zip \
>       ${{ github.workspace }}/BUILD/staging/${LANGUAGE}/pakchunk0-${PLATFORM}_${LANGUAGE}_Dialogue_Latest_P.pak
>     fi
>     ```
>
>   - Create_Latest_Release
>     ```bash
>     gh release create Latest \
>     ${{ github.workspace }}/BUILD/staging/releases/pakchunk0-ps4_*_Dialogue_Latest_P.pak.zip \
>     ${{ github.workspace }}/BUILD/staging/releases/pakchunk0-Switch_*_Dialogue_Latest_P.pak.zip \
>     ${{ github.workspace }}/BUILD/staging/releases/pakchunk0-WindowsNoEditor_*_Dialogue_Latest_P.pak.zip \
>     --notes-file ${{ github.workspace }}/BUILD/dqx-offline-localization/docs/CHANGELOG.md \
>     --title "$(echo -e v$(date -u +%F ))"
>
>     echo "Successfully uploaded new files to [Releases/Latest](https://github.com/KodywithaK/dqx-offline-localization/releases/tag/Latest)." >> $GITHUB_STEP_SUMMARY
>     echo -e "\n::notice:: \033[0;32m Successfully uploaded new files to Latest release. \033[0m"
>     ```
>
> ### PS4
>   - `Settings > Debug Settings > Game > Install Package`
>     - `JP0082-CUSA29081_00-HOLIDAY000000000.pkg`
>
> </details>

[^1]: `.gp4` = `G`ame `P`roject File - PlayStation `4`, custom `.XML` filetype
-->

	<!--
	## ps5?
	- tbd
	-->

## pakchunk0-Switch.(pak|ucas|utoc)

- `Game.locmeta` main language: dummy?
	- Changes priority level so that `{LANGUAGE}/Game.locres` is prefered over `StringTables`
		- Will make packaging & deploying for og version WAY easier
- `Game.locres` v2 packager

## pakchunk0-WindowsNoEditor.(pak|ucas|utoc)

- TBD

---

# LANGUAGE

## de

#### Modal particles

- e.g., "Listen`—this time—`to me", "Listen to me `this time`!"
	- "Hör `mal` zu!"

## es

#### Double object pronouns

- me, te, (la/lo/le|se), nos, vos, (las/los/les|se)
- Only after infinitive/gerund verb forms
- Double object pronouns always get diacritics on the first inflected vowel, whereas with singles it depends on the word
	- e.g, "Juan is going to buy a ring for her" > "Juan is going to buy her a ring" > "Juan is going to buy her it"
		- "Juan va a comprar un anillo a ella" > "Juan va a comprarla un anillo" > "Juan va a compr`á`rselo"
	- e.g., "They are explaining the rules to you" > "They are explaining you the rules" > "They are explaining you them"
		- "Ellos están explicando las reglas a ti" > "Ellos están explic`á`ndote las reglas" > "Ellos están explic`á`ndotelas"
	- "You can't `Le` `lo`" aka Le la/lo/las/los > `Se` la/lo/las/los
		- e.g., "Antonio loaned his phone to him/her/you (formal)" > "(Antonio )loaned him/her/you (formal) his phone" > "(Antonio )loaned him/her/you (formal) it"
			- "Antonio prestó su teléfono a ello/ella/usted" > "`Le` prestó su teléfono" > "`Se` `lo` prestó"

## it

#### Double / contracted pronouns

- Stressed (Tonic) Pronouns
	- me, te, lui/lei, noi, voi, loro
- Unstressed (Atonic) Pronouns
	| LANGUAGE | 1st, singular | 2nd, singular | 3rd, singular | 1st, plural | 2nd, plural | 3rd, plural |
	| :------- | :------------ | :------------ | :------------ | :---------- | :---------- | :---------- |
	| en | 1st, singular | 2nd, singular | 3rd, singular | 1st, plural | 2nd, plural | 3rd, plural |
	| it | 1st, singular | 2nd, singular | 3rd, singular | 1st, plural | 2nd, plural | 3rd, plural |
	- mi, ti, lo/la, ci, vi, li/le

#### Clitic Pronouns

- Proclitic
	- Negative + Stressed (Tonic) Pronouns (indirect object) + Unstressed (Atonic) Pronouns (direct object) + full verb
		- `Non te la prendere`
- Enclitic
	- Negative + verb (apocopic) + Stressed (Tonic) Pronouns (indirect object) + Unstressed (Atonic) Pronouns (direct object)
		- "Don't (you) take offense (with him)"
		- Non prender~~e~~ + te + la (offesa) (con lui).
		- `Non prendersela`

## pt-BR

#### Clitic Pronouns

- Proclitic
	- pt-BR, spoken/written for everything
		- e.g., "I `(will/am going to)` give you"
			- "Eu vou te dar." > "Vou te dar."
- Mesoclitic
	- pt-EU, \*rare\* formal, written for simple future indicative or conditional statements
		- e.g., "I `am going to give` you (this)" / `If I give` you (this)"
			- "Eu te darei." > "Te`¹` darei." > "Dar`-te-`ei."
				- `¹` Grammar conflict
		- for \*noble\* characters: Raguas, Gartlant paladins, etc.
	- [yomitan | Improve word lookup](https://github.com/yomidevs/yomitan/pull/2066/files)
	- [yomitan/\*\*/ext/data/recommended-settings.json](https://github.com/thrzl/yomitan/blob/0a85785984baa1528eda52308f1f1d4c295dc384/ext/data/recommended-settings.json)
		- find: `(-?(([mst][aeo])|(lh?[aeo]s?)|([nv]os?))-){1,2}`
			- see [Priberam Dictionario](https://dicionario.priberam.org/dar-no-lo-ia)
- Enclitic
	- pt-EU, spoken/written for everything
		- e.g., "I `(will/am going to)` give you"
			- "Eu vou te dar" > "Vou dar-te"

---

# Language Selection Menu

<details>

> ## Game/Content/Localization/Game/Game.locres.yaml
>
> - Add `.SYSTEM_LOACALIZATION.SYSTEM_LOCALIZATION_{LANGUAGE}`
>
> ```diff
>   SYSTEM_LOACALIZATION_004:
>     $comments: "🟢, ko"
>     de: 한국어
>     en: 한국어
>     es: 한국어
>     fr: 한국어
>     it: 한국어
>     ja: 韓国語
>     ko: 한국어
>     pt-BR: 한국어
>     zh-Hans: 韩文
>     zh-Hant: 韓文
> +  KWK_SYSTEM_LOCALIZATION_de:
> +    $comments: "🟡, "
> +    de: ""
> +    en: ""
> +    es: ""
> +    fr: ""
> +    it: ""
> +    ja: ドイツ語
> +    ko: ""
> +    pt-BR: ""
> +    zh-Hans: ""
> +    zh-Hant: ""
> +  KWK_SYSTEM_LOCALIZATION_en:
> +    $comments: "🟡, "
> +    de: ""
> +    en: ""
> +    es: ""
> +    fr: ""
> +    it: ""
> +    ja: 英語
> +    ko: ""
> +    pt-BR: ""
> +    zh-Hans: ""
> +    zh-Hant: ""
> +  KWK_SYSTEM_LOCALIZATION_es:
> +    $comments: "🟡, "
> +    de: ""
> +    en: ""
> +    es: ""
> +    fr: ""
> +    it: ""
> +    ja: スペイン語
> +    ko: ""
> +    pt-BR: ""
> +    zh-Hans: ""
> +    zh-Hant: ""
> +  KWK_SYSTEM_LOCALIZATION_fr:
> +    $comments: "🟡, "
> +    de: ""
> +    en: ""
> +    es: ""
> +    fr: ""
> +    it: ""
> +    ja: フランス語
> +    ko: ""
> +    pt-BR: ""
> +    zh-Hans: ""
> +    zh-Hant: ""
> +  KWK_SYSTEM_LOCALIZATION_it:
> +    $comments: "🟡, "
> +    de: ""
> +    en: ""
> +    es: ""
> +    fr: ""
> +    it: ""
> +    ja: イタリア語
> +    ko: ""
> +    pt-BR: ""
> +    zh-Hans: ""
> +    zh-Hant: ""
> +  KWK_SYSTEM_LOCALIZATION_pt-BR:
> +    $comments: "🟡, "
> +    de: ""
> +    en: ""
> +    es: ""
> +    fr: ""
> +    it: ""
> +    ja: ブラジルポルトガル語
> +    ko: ""
> +    pt-BR: ""
> +    zh-Hans: ""
> +    zh-Hant: ""
>   SYSTEM_LOACALIZATION_005:
>     $comments: "🟢, "
>     de: Sprache Ändern
>     en: Change Language
>     es: Cambiar Idioma
>     fr: Changer Langue
>     it: Cambia Lingua
>     ja: 言語の切替を行います
>     ko: 언어 설정을 바꿉니다
>     pt-BR: Mudar Idioma
>     zh-Hans: 切换语言
>     zh-Hant: 切換語言
> ```
>
> ## Game/Content/StringTables/Game/Localization/SYSTEM_LOACALIZATION.uasset
>
> - Add new language strings
>
> ```diff
>   "SYSTEM_LOACALIZATION_004": "韓国語",
> + "KWK_SYSTEM_LOCALIZATION_de","ドイツ語",
> + "KWK_SYSTEM_LOCALIZATION_en","英語",
> + "KWK_SYSTEM_LOCALIZATION_es","スペイン語",
> + "KWK_SYSTEM_LOCALIZATION_fr","フランス語",
> + "KWK_SYSTEM_LOCALIZATION_it","イタリア語",
> + "KWK_SYSTEM_LOCALIZATION_pt-BR","ブラジルポルトガル語",
>   "SYSTEM_LOACALIZATION_005": "言語の切替を行います",
> ```
>
> ## Game/Content/Blueprints/WidgetBP/SystemTitle/Boukennosho/WB_SelectLanguage.uasset
>
> - `MainMenuText`, Line 16641
>   - Add new language objects
>   ```diff
>   "MainMenuText": [
>       {
>         "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>         "Key": "SYSTEM_LOACALIZATION_002",
>         "SourceString": "繁体字",
>         "LocalizedString": "繁体字"
>       },
>       {
>         "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>         "Key": "SYSTEM_LOACALIZATION_003",
>         "SourceString": "簡体字",
>         "LocalizedString": "簡体字"
>       },
>       {
>         "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>         "Key": "SYSTEM_LOACALIZATION_004",
>         "SourceString": "韓国語",
>         "LocalizedString": "韓国語"
>       }
>   +   ,
>   +   {
>   +     "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>   +     "Key": "KWK_SYSTEM_LOCALIZATION_de",
>   +     "SourceString": "ドイツ語",
>   +     "LocalizedString": "ドイツ語"
>   +   },
>   +   {
>   +     "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>   +     "Key": "KWK_SYSTEM_LOCALIZATION_en",
>   +     "SourceString": "英語",
>   +     "LocalizedString": "英語"
>   +   },
>   +   {
>   +     "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>   +     "Key": "KWK_SYSTEM_LOCALIZATION_es",
>   +     "SourceString": "スペイン語",
>   +     "LocalizedString": "スペイン語"
>   +   },
>   +   {
>   +     "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>   +     "Key": "KWK_SYSTEM_LOCALIZATION_fr",
>   +     "SourceString": "フランス語",
>   +     "LocalizedString": "フランス語"
>   +   },
>   +   {
>   +     "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>   +     "Key": "KWK_SYSTEM_LOCALIZATION_it",
>   +     "SourceString": "イタリア語",
>   +     "LocalizedString": "イタリア語"
>   +   },
>   +   {
>   +     "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>   +     "Key": "KWK_SYSTEM_LOCALIZATION_pt-BR",
>   +     "SourceString": "ブラジルポルトガル語",
>   +     "LocalizedString": "ブラジルポルトガル語"
>   +   }
>   ],
>   "SlotName": "system_save2.sav",
>   "ExplanatrionArray": [
>     {
>       "Namespace": "",
>       "Key": "D25896164EE48D15342E4AADA8B3CA4F",
>       "SourceString": "ゲーム中の言語を中国語（繁体字）に切り替えます。",
>       "LocalizedString": "ゲーム中の言語を中国語（繁体字）に切り替えます。"
>     },
>     {
>       "Namespace": "",
>       "Key": "126EFAE043A5BCFA8F3D429276730245",
>       "SourceString": "ゲーム中の言語を中国語（簡体字）に切り替えます。",
>       "LocalizedString": "ゲーム中の言語を中国語（簡体字）に切り替えます。"
>     },
>     {
>       "Namespace": "",
>       "Key": "3E64C11E4C892B9DFEF273AC9590E2A8",
>       "SourceString": "ゲーム中の言語を韓国語に切り替えます。",
>       "LocalizedString": "ゲーム中の言語を韓国語に切り替えます。"
>     }
>   + "Switch the ingame language to {LANGUAGE}"
>   ],
>   "AskMessageText": [
>     {
>       "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>       "Key": "SYSTEM_LOACALIZATION_007",
>       "SourceString": "言語設定を繁体字にしますか？",
>       "LocalizedString": "言語設定を繁体字にしますか？"
>     },
>     {
>       "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>       "Key": "SYSTEM_LOACALIZATION_008",
>       "SourceString": "言語設定を簡体字にしますか？",
>       "LocalizedString": "言語設定を簡体字にしますか？"
>     },
>     {
>       "TableId": "/Game/StringTables/Game/Localization/SYSTEM_LOACALIZATION.SYSTEM_LOACALIZATION",
>       "Key": "SYSTEM_LOACALIZATION_009",
>       "SourceString": "言語設定を韓国語にしますか？",
>       "LocalizedString": "言語設定を韓国語にしますか？"
>     }
>   + "Are you sure you want to switch the ingame language to {LANGUAGE}?"
>   ],
>   ```

</details>

- https://docs.ue4ss.com/dev/feature-overview/dumpers.html#usmap-dumper

# "/\*\*/DRAGON QUEST X OFFLINE/Game/Binaries/Win64/UHTHeaderDump/Holiday/

## Public/

### HOLIStringLibrary.(cpp|h)"

- Disable `ConvertHalfToFullWidth`
	- `class HOLIDAY_API UHOLIStringLibrary : public UBlueprintFunctionLibrary`
		- See `CoreMinimal.h` > `BlueprintFunctionLibrary`
	- Maybe even cheating with `ConvertFullToHalfWidth`
	```diff
	 UFUNCTION(BlueprintCallable, BlueprintPure)
	-static FString ConvertHalfToFullWidth(const FString& inString);
	+// static FString ConvertHalfToFullWidth(const FString& inString);
	!or
	+static FString ConvertFullToHalfWidth(const FString& ConvertHalfToFullWidth(const FString& inString));
	```

## Content/Blueprints/WidgetBP/MessageWindow/WB_LineMessage

- https://modding.wiki/en/hogwartslegacy/developers/hlblueprint102

## Content/Blueprints/WidgetBP/MessageWindow/WB_MessageWindow

- Has some relation to `DT_RubyText` ?
- https://www.compart.com/en/unicode/category/Lm

## Content/Datatables/Text/DT_TextRuby.json

- https://www.compart.com/en/unicode/category/Lm
- https://www.compart.com/en/unicode/category/Sk
- `Garrick-Bold_RUBYx2.otf`
	- [x] U+00A8 `¨` = `K｛o：¨｝nigin` or `K｛o：\n¨｝nigin`
	- [x] U+00B8 `¸` = `Fran｛c：¸｝ais` or `Fran｛c：\n¸｝ais`
	- [x] U+02C6 `ˆ` = `S｛i：ˆ｝`
	- [ ] U+02CE `ˎ` = `S｛i：ˎ｝`
	- [ ] U+02CF `ˏ` = `S｛i：ˏ｝`
	- [x] U+02F7 `˷` = `Se｛ñ：˷｝ora`
	- [x] U+A788 `ꞈ` = `Portugu｛e：ꞈ｝s `

### Disable `ConvertHalfToFullWidth*` / `IsStringASCII` to fix non ascii, halfwidth characters

- https://www.nexusmods.com/stellarblade/articles/22

# UHTHeaderDump\Holiday\

- Contains source C++ Classes for JsonAsAsset imports
- DOES `#include { DQX dependency }` = `{ DQX Project }\Source\Holiday\`
- DOES NOT `#include { UE4 dependency }` = `{ UE_4.27 Directory }\Engine\Source\Runtime\`

	- Note: `-ModuleName` & `-ObjectName` / `-FallbackName` match UE_4.27's `{ UE4Editor Directory }\Engine\Source\Runtime\**\Engine\**\{ DataTable.h }:FTableRowBase`
	- So searching `{ UE_4.27 Directory }\Engine\Source\` ( or [Unreal Engine's Docs](https://dev.epicgames.com/community/search?query=FTableRowBase) ) for the missing dependencies ( `FTableRowBase` ) will show results for likely files

	```diff
	#pragma once
	#include "CoreMinimal.h"
	-//CROSS-MODULE INCLUDE V2: -ModuleName=Engine -ObjectName=TableRowBase -FallbackName=TableRowBase
	!---> TableRowBase is a ( F )unction, so search for FTableRowBase
	!---> Other objects would be like ( C )lass, ( E )numerator, etc.
	+#include "Engine/DataTable.h"
	#include "HOLITextRubyData_TableRow.generated.h"

	USTRUCT(BlueprintType)
	struct FHOLITextRubyData_TableRow : public FTableRowBase {
			GENERATED_BODY()
	public:
			UPROPERTY(BlueprintReadWrite, EditAnywhere, meta=(AllowPrivateAccess=true))
			FString Word;

			UPROPERTY(BlueprintReadWrite, EditAnywhere, meta=(AllowPrivateAccess=true))
			FString Ruby;

			UPROPERTY(BlueprintReadWrite, EditAnywhere, meta=(AllowPrivateAccess=true))
			int32 WordLength;

			UPROPERTY(BlueprintReadWrite, EditAnywhere, meta=(AllowPrivateAccess=true))
			int32 RubyLength;

			UPROPERTY(BlueprintReadWrite, EditAnywhere, meta=(AllowPrivateAccess=true))
			bool IsRubyTag;

			HOLIDAY_API FHOLITextRubyData_TableRow();
	};
	```

- Holiday.hpp

- HOLIMessageText.(cpp|h)
	```diff
	UPROPERTY(BlueprintReadWrite, EditAnywhere, meta=(AllowPrivateAccess=true))
	FString ParseText;
	...
	UFUNCTION(BlueprintCallable)
	FString ParseChar(bool& bRet);
	```
- WB_BoukennoshoSlot.hpp
	```diff
	-void ConvertHalfToFullText(FText InText, FText& OutText);
	+// void ConvertHalfToFullText(FText InText, FText& OutText);
	!or
	+void ConvertHalfToFullText(FText InText, FText& InText);
	```
- WB_TrialBoukennoshoSlot.hpp
	```diff
	-void ConvertHalfToFullText(FText InText, FText& OutText);
	+// void ConvertHalfToFullText(FText InText, FText& OutText);
	!or
	+void ConvertHalfToFullText(FText InText, FText& InText);
	```

# ./.github/workflows/Create_Latest_Release_DEBUG.yml

<details>

> - Steam/\*\*/pakchunk0-WindowsNoEditor.pak/Game/Content/StringTables/destinations.txt
>
> ## Move completed `.csv` to their respective folders
>
> - **\*\*Note the trailing newline\*\***
>
> - `destinations.txt`
>
>   ```sh
>   ./STT_Title_Boukennosho.csv    ./Holiday/Content/StringTables/Game/System/System_Title/
>   ./{ SOURCE }.csv    ./Holiday/Content/StringTables/Game/{ DESTINATION }/
>
>   ```
>
> - `organize.sh`
>
>   ```sh
>   #!/bin/bash
>
>   # Set IFS to define delimiters
>   IFS='    '
>
>   # read each line of destinations.txt
>   while read -r source destination; do
>       mkdir -p $destination
>       # echo "$source $destination"
>       mv $source $destination
>   done < "destinations.txt"
>
>   ```

</details>

# UE4Editor

> [!TIP]
>
> Game.locres.yaml > {NAMESPACE}.csv > StringTable ( import from CSV )
>
> <details>
>
> ```cmd
> cls && FOR /F "usebackq tokens=1,2,3delims= " %E IN (`echo {NAMESPACE aka %E} {LANGUAGE aka %F} {FALLBACK_LANGUAGE aka %G}`) DO yq ".%E" Game.locres.yaml -o=json | jq -r ". as $obj | reduce ($obj | keys_unsorted)[] as $k ( {\"Key\":\"SourceString\"}; .[$k] += if($obj[$k].%F != \"\") then($obj[$k].%F) else($obj[$k].%G) end      ) | ((. | keys_unsorted)[] as $k | [$k,(.[$k] | gsub(\"(\r)?\n\";\"\\n\"))]) | @csv" > "C:\Path\To\%E.csv"
> cls && FOR /F "usebackq tokens=1,2,3delims= " %E IN (`echo STT_System_Title es ja`) DO yq ".%E" Game.locres.yaml -o=json | jq -r ". as $obj | reduce ($obj | keys_unsorted)[] as $k ( {\"Key\":\"SourceString\"}; .[$k] += if($obj[$k].%F != \"\") then($obj[$k].%F) else($obj[$k].%G) end      ) | ((. | keys_unsorted)[] as $k | [$k,(.[$k] | gsub(\"(\r)?\n\";\"\\n\"))]) | @csv" > "C:\Path\To\%E.csv"
> ```
>
> </details>

> [!TIP]
> Game.locres.yaml > {NAMESPACE}.json > StringTable ( JsonAsAsset )
>
> <details><summary>Version 1</summary>
>
> ```cmd
> cls && FOR /F "usebackq tokens=1,2,3delims= " %E IN (`echo {NAMESPACE aka %E} {LANGUAGE aka %F} {FALLBACK_LANGUAGE aka %G}`) DO yq ".%E" Game.locres.yaml -o=json | jq -r ". as $obj | reduce ($obj | keys_unsorted)[] as $k ( [{}]; .[].StringTable.KeysToEntries.[$k] += if($obj[$k].%F != \"\") then($obj[$k].%F) else($obj[$k].%G) end      )" > "R:\Exports\Game\Content\StringTables\Game\%E.json.new"
> cls && FOR /F "usebackq tokens=1,2,3delims= " %E IN (`echo STT_System_Title es ja`) DO yq ".%E" Game.locres.yaml -o=json | jq -r ". as $obj | reduce ($obj | keys_unsorted)[] as $k ( [{}]; .[].StringTable.KeysToEntries.[$k] += if($obj[$k].%F != \"\") then($obj[$k].%F) else($obj[$k].%G) end      )" > "R:\Exports\Game\Content\StringTables\Game\%E.json.new"
> ```
>
> - Overwrite {NAMESPACE}.old with {NAMESPACE}.new > {NAMESPACE}.json
>
> ```cmd
> cls && FOR %F IN ({NAMESPACE aka %F}) DO jq -s ".[0][].StringTable.KeysToEntries = .[1][].StringTable.KeysToEntries | .[0]" "%F.json.old" "%F.json.new" > "%F.json"
> cls && FOR %F IN (STT_Career_StoryUISys) DO jq -s ".[0][].StringTable.KeysToEntries = .[1][].StringTable.KeysToEntries | .[0]" "%F.json.old" "%F.json.new" > "%F.json"
> ```
>
> </details>
>
> <details><summary>Version 2</summary>
>
> ```cmd
> cls && FOR /F "usebackq tokens=1,2,3delims= " %E IN (`echo STT_System_Title es ja`) DO yq ".%E" ..\Game.locres.yaml -o=json | jq -r ". as $obj | reduce ($obj | keys_unsorted)[] as $k ( [{\"Type\": \"StringTable\", \"Name\": \"%E\", \"Class\": \"UScriptClass^'StringTable^'\", \"Flags\": \"RF_Public ^| RF_Standalone ^| RF_Transactional ^| RF_WasLoaded ^| RF_LoadCompleted\", \"StringTable\":{\"TableNamespace\":\"%E\",\"KeysToMetaData\": {}}}]; .[].StringTable.KeysToEntries.[$k] += if($obj[$k].%F != \"\") then($obj[$k].%F) else($obj[$k].%G) end      )" > "R:\FModel\Exports\Game\Content\StringTables\Game\%E.json"
> ```
>
> - [ ] JQ `--from-file`, unescape & conditionals for StringTables with different namespace than its filename
>   - `if ( --arg == "STT_Title_Boukennosho", etc. ) then ( "TableNamespace": "STT_System_Title", etc. ) else ( . ) end`
>
> </details>

> [!IMPORTANT]
>
> ## .locres
>
> ### Optimized_CRC32
>
> - https://github.com/SwimmingTiger/UnrealLocres/blob/master/LocresLib/Crc.cs
> - https://github.com/EpicGames/UnrealEngine/blob/6978b63c8951e57d97048d8424a0bebd637dde1d/Engine/Source/Runtime/Core/Private/Misc/Crc.cpp#L208
> - https://web.mit.edu/freebsd/head/sys/libkern/crc32.c
>
> #### KodywithaK\LocResBuilder v0.1.3
>
> - [x] Optimized_CRC32 compatibility
> - [ ] `--output_verion` argument for `LocResVersion` ( aka 2: `Optimized_CRC32` or 3: `Optimized_CityHash64_UTF16` )
>
>   - `locmeta.json ( Optimized_CRC32 )` > `../../../Game/Content/Localization/Game/*`
>
>     ```cmd
>     main.py "R:\Temp\INPUT\Optimized_CRC32\locmeta.json" --format json --out_dir "R:\Temp\OUTPUT\Optimized_CRC32"
>     ```
>
>   - `locmeta.json ( Optimized_CityHash64_UTF16 )` > `../../../Game/Content/Localization/Game/*`
>
>     ```cmd
>     main.py "R:\Temp\INPUT\Optimized_CityHash64_UTF16\locmeta.json" --format json --out_dir "R:\Temp\OUTPUT\Optimized_CityHash64_UTF16"
>     ```
>
> #### UnrealPak
>
> - `responseFile.txt`
>
>   ```txt
>   "R:\Temp\OUTPUT\Optimized_CRC32\Game\Game.locmeta" "../../../Game/Content/Localization/Game/Game.locmeta"
>   "R:\Temp\OUTPUT\Optimized_CRC32\Game\en\Game.locres" "../../../Game/Content/Localization/Game/ja/Game.locres"
>   ```
>
> - `UnrealPak`
>
>   ```txt
>   "Desktop\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe" "R:\Temp\OUTPUT\Optimized_CRC32\pakchunk0-WindowsNoEditor_en_Optimized_CRC32_P.pak" -Create="R:\Temp\OUTPUT\Optimized_CRC32\responseFile.txt"
>   ```
>
> #### `"../../../Holiday/Content/Localization/Game/Game.locmeta"`
>
> - `"bIsUGC": false`
>   - https://www.unrealengine.com/en-US/blog/new-example-project-and-plugin-for-mod-support-released
>   - https://docs.mod.io/unreal/component-ui/enable-disable
>     - Disables UI mods? So switch to `true`

> [!TIP]
>
> ## UE4SS
>
> <details>
>
> ### Prerequisites
>
> - pakchunk0-WindowsNoEditor_LocResBuilder_v2_P.pak
> - [UE4SS - Download](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest)
> - [UE4SS - Docs](https://docs.ue4ss.com/dev/installation-guide.html)
>
> ### Installation
>
> - Copy the contents of `zDEV-UE4SS_v*.zip` to:
>   - `PathTo\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Binaries\Win64\ue4ss\`
>   - `PathTo\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Binaries\Win64\dwmapi.dll`
>     - or
>   - `PathTo\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Binaries\Win64\ue4ss\`
>   - `PathTo\SteamLibrary\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Binaries\Win64\dwmapi.dll`
>
> ### Usage
>
> - Start the game, and `ue4ss` will automatically boot up
>
> #### UE4SS Debugging Tools (OpenGL 3) - ExternalThread
>
> - `~` enables console commands to be input, such as:
>   - `culture={LANGUAGE}`:
>     - English `culture=en`
>     - Japanese `culture=ja`
>     - Portuguese (Brazil) `culture=pt-BR`
>     - Chinese (Simplified) `culture=zh-Hans`
>     - etc.
>   - Afterwards, all UI will instantly change to the language that you input ( loaded from `{LANGUAGE}\Game.locres` )
>     - Some dialogue & cutscene graphics will remain the same as originally launched language
>       - Game launched in `Korean`, `~` > `culture=ja`
>         - Title screen still shows korean logo, but all other fonts / text are japanese
> - **_PERSISTS EVEN AFTER REMOVING `ue4ss\` & `dwmapi.dll`_**
>   - [ ] Compare save files for changed cultures
>   - [ ] `../../../Game/Config/DefaultGame.ini:InternationalizationPreset=EFIGSCJK` to `All`, ( `pt-BR` doesn't load currently with `EFIGSCJK` )
>
> <details><summary>Optimized_CRC32 TESTING</summary>
>
> - responseFile.txt
>
>   - `la` is used for debugging ( shows names of keys )
>
>   ```txt
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/Game.locmeta" "../../../Game/Content/Localization/Game/Game.locmeta"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/de/Game.locres" "../../../Game/Content/Localization/Game/de/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/en/Game.locres" "../../../Game/Content/Localization/Game/en/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/es/Game.locres" "../../../Game/Content/Localization/Game/es/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/fr/Game.locres" "../../../Game/Content/Localization/Game/fr/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/it/Game.locres" "../../../Game/Content/Localization/Game/it/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/ja/Game.locres" "../../../Game/Content/Localization/Game/ja/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/ko/Game.locres" "../../../Game/Content/Localization/Game/ko/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/la/Game.locres" "../../../Game/Content/Localization/Game/la/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/pt-BR/Game.locres" "../../../Game/Content/Localization/Game/pt-BR/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/zh-Hans/Game.locres" "../../../Game/Content/Localization/Game/zh-Hans/Game.locres"
>   "${{ github.workspace }}/DEBUG/LocRes-Builder/OUTPUT/Optimized_CRC32/Game/zh-Hant/Game.locres" "../../../Game/Content/Localization/Game/zh-Hant/Game.locres"
>   ```
>
> - `Game/Content/i18n/${LANGUAGE}/NonAssets/ETP`
>
>   - `"Path\To\ETP\*" "../../../Game/Content/i18n/en/NonAssets/ETP_en/"`
>   - No affect, just loaded from `ETP`, as per usual
>
> - `BP_GameOption_C /Engine/Transient.GameEngine_2147482612:BP_HOLIGameInstance_C_2147482605.BP_GameOption_C_2147482513`
>   - `/Script/Holiday.HOLIGameOptionData:IsUseRuby`
>     - Modify function to always return `true` for non-ascii letter spacing fix
> - `Function /Game/Blueprints/System/GameOption/BP_GameOption.BP_GameOption_C:SetRubyMode`
>
> </details>
>
> </details>

> [!IMPORTANT]
>
> ## jq --arg LANGUAGE ${LANGUAGE} --from-file "Game.locres.json\_--from-file.txt"
>
> <details>
>
> - Easier than current `LocRes-Builder Inputs` step
>
> - `Game.locres.json_--from-file.txt`
>
>   ```js
>   . as $obj
>   | reduce ( $obj | keys_unsorted )[] as $ns (
>       {};
>       .[$ns] += (
>           reduce ( $obj[$ns] | keys_unsorted )[] as $k (
>               {};
>               .[$k] += (
>                   if ( $LANGUAGE != "la" ) # la ( latin ) will be used for debugging locres keys
>                   then (
>                       if ( $obj[$ns][$k][$LANGUAGE] != "" )
>                       then ( $obj[$ns][$k][$LANGUAGE] )
>                       else ( $obj[$ns][$k]["ja"] )
>                       end
>                   )
>                   else ( $k )
>                   end
>               )
>           )
>       )
>   )
>
>   ```
>
>   ```cmd
>   FOR %L IN (de en es fr it ja ko la pt-BR zh-Hans zh-Hant) DO ( yq "." "${{ github.workspace }}/BUILD/dqx-offline-localization/Steam/App_ID-1358750/Build_ID-14529657/pakchunk0-WindowsNoEditor.pak/Game/Content/Localization/Game/Game.locres.yaml" -o json -I2 | jq --arg LANGUAGE %L --from-file "Game.locres.json_--from-file.txt" > R:\LocRes-Builder\INPUT\%L.json )
>   ```
>
>   ```bash
>   for LANGUAGE in de en es fr it ja ko la pt-BR zh-Hans zh-Hant; do \
>     yq "." \
>     "${{ github.workspace }}/BUILD/dqx-offline-localization/Steam/App_ID-1358750/Build_ID-14529657/pakchunk0-WindowsNoEditor.pak/Game/Content/Localization/Game/Game.locres.yaml" \
>     -o json -I2 \
>     | jq --arg LANGUAGE $LANGUAGE \
>     --from-file "${{ github.workspace }}/BUILD/dqx-offline-localization/Steam/App_ID-1358750/Build_ID-14529657/pakchunk0-WindowsNoEditor.pak/Game/Content/Localization/Game/Game.locres.json_--from-file.txt" \
>     > "${{ github.workspace }}/BUILD/LocRes-Builder/INPUT/${LANGUAGE}.json"
>   done
>   ```
>
> </details>
