![GitHub Actions Workflows (Create_Latest_Release.yml status)](https://github.com/KodywithaK/dqx-offline-localization/actions/workflows/Create_Latest_Release.yml/badge.svg?branch=testing)
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/KodywithaK/dqx-offline-localization/total?logo=github&label=Downloads)

<!-- 
> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.
-->

<details><summary><h1>Translate StringTables via Unreal Editor (UE4Editor.exe)</h1></summary>

## 0.Prerequisites
> For Nintendo Switch:
> - [Dragon Quest X Offline from the Nintendo eShop](https://store-jp.nintendo.com/list/software/70010000042357.html)<br>(Title ID `0100E2E0152E4000`)
> - Nadrino's [SimpleModManager](https://github.com/nadrino/SimpleModManager)
>
> For Steam:
> - [DRAGON QUEST X OFFLINE (or Demo) from Steam](https://store.steampowered.com/app/1358750/XOFFLINE/)
- Unreal Editor from [Epic Games' Unreal Engine](https://www.unrealengine.com/en-US/download)<br>(UE4Editor.exe - `4.27.2` used in this tutorial)
<!--
  - FModel.exe from [4sval's github repo](https://github.com/4sval/FModel)
    - DRAGON QUEST X OFFLINE (or Demo)'s AES Key
    - DRAGON QUEST X OFFLINE (or Demo)'s [Mappings.usmap](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)
-->

## 1.UE4Editor.exe

### Create Project

- Open UE4Editor.exe and create a new project.

- Select Template Category `Blank Project` > Select Template `Blank` > Project Settings `Desktop/Console` & `No Starter Content`.

- Select a location for your project to be stored and its name.<br>e.g., Folder `C:\Downloads\UE_4.27\Projects`<br>Name `Holiday` for Nintendo Switch, `Game` for Steam.

- Once your project loads, go to the `Content Browser` on the bottom and click the `Show or hide the sources panel` button (left of the `Filters▼|Search Content`) to ensure you are working in the correct folders.

> [!IMPORTANT]
> Make sure to double-check your spelling and capitalization, to save you from having to troubleshoot later.

### Create Folder Structure and StringTables

01) In the `Content Browser`:
    - Right-click on the `Content` folder, select `New Folder`, and name it `StringTables`.
    - Right-click on the `StringTables` folder, select `New Folder`, and name it `Game`.
    - Right-click on the `Game` folder, select `New Folder`, and name it `System_Title`.

02) In the `Content > StringTables > Game > System > System_Title` folder:
    - Right-click, `Miscellaneous > String Table` and rename the new file `STT_Title_Boukennosho`.

03) Double-click the new `STT_Title_Boukennosho` file:
    - `Import from CSV`, then select the `STT_Title_Boukennosho.uasset.csv` to autofill the `Key` & `Source String` sections.

> [!NOTE]
> You can either edit the Source Strings in that window OR edit the `.csv` and reimport.

04) Repeat `steps 1-3` with other `StringTables`, as necessary.

05) `Save`, then close out the window.

### Create Data Asset and Packaging Rules

- Click the `Content` folder to be get taken back to the top folder.

- Right-click in the content browser area, select `Miscellaneous > Data Asset > PrimaryAssetLabel`, then double-click into it.

- Chunk ID `30`<br>Cook Rule `Always Cook`<br>Label Assets in My Directory [x], save and exit the window.

> [!NOTE]
> `Save All` for good measure.

### Package pakchunk30-WindowsNoEditor.pak

01) `Edit > Project Settings > Project > Packaging > Packaging`, enter the following settings:
    - Use Pak File [x]<br>Use Io Store [x]<br>Generate Chunks [x]

<!--
  > - Exit to `Content Browser` window, then right-click your `Content` folder, select `Show in Explorer` to open up the file explorer.

  02) File explorer:
  > - Go up 1 level to your `<PROJECT_NAME>` folder, enter `Config`, and make a new text document named `DefaultPakFileRules.ini`.

  03) Inside of `DefaultPakFileRules.ini`, enter the following:

	```ini
	[bExcludeFromPaks_Engine]
	bExcludeFromPaks=true
	bOverrideChunkManifest=true
	+Files=".../Engine/..."
	+Files="...Game.uproject"
	+Files="...Game/*"
	+Files="...Game/Config/..."
	+Files="...Game/Content/Shader*"
	+Files="...Game/Platforms/..."
	+Files=".../*.upluginmanifest"
	```
  > - With that, the packaged project will be slimmed down to only the imported fonts.
-->

02) `File > Package Project > Windows (64-bit)`
> [!NOTE]
> If you get the `Unsupported Platform` pop-up, you can ignore it. 

- Click continue, and choose a folder to package your project into.<br>e.g.,
  `"C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\pakchunk30-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak"`<br>or<br>`"C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\pakchunk30-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak/ucas/utoc)"`, etc.
  
- Your project will begin packaging, and alert when it's finished.

03) Rename the newly created `pakchunk`**30**`-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak/ucas/utoc)` to
> - For Nintendo Switch:<br>`pakchunk0-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak/ucas/utoc)"`
>
> - For Steam:<br>`pakchunk0-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak/ucas/utoc)"`

## 2.Move new pakchunk0-(Switch|WindowsNoEditor).(pak|ucas|utoc)

> - For Steam:<br>`"C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\`pakchunk0-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak|ucas|utoc)"<br>or similar, if you have a custom steam library location.
>
> - For Nintendo Switch:<br>`mods/Dragon Quest X Offline/<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>/contents/0100E2E0152E4000/romfs/Holiday/Content/Paks/`pakchunk0-Switch_P.(pak|ucas|utoc)

<!--

## 3.UEcastoc: fix file structure
<!-- ### Autogenerate `.(pak|ucas|utoc)`
```bash
C:\Users\Ryzen3\Desktop\UE_4.27\Engine\Build\BatchFiles>RunUAT.bat \
BuildCookRun \
-project="C:\Users\Ryzen3\Desktop\UE_4.27\!projects\DRAGON QUEST X OFFLINE\20241206\Game\Game.uproject" \
-platform=Win64 \
-cook \
-stage \
-package \
-build \
-iostore \
-pak
```

### UEcastoc: fix file structure
```bash
C:\Users\Ryzen3\Desktop\UE_5.1\Engine\Binaries\Win64>UnrealPak.exe "S:\Steam\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\pakchunk0-WindowsNoEditor_BadFileStructure_P.ucas" \
-list
LogPakFile: Display: Using command line for crypto configuration
LogIoStore: Display: Mount point ../../../Game/Content/ # Will NOT load ingame
LogIoStore: Display: "../../../StringTables/Game/System/System_Party/STT_PT_Talk.uasset" <...>
```
to
```bash
C:\Users\Ryzen3\Desktop\UE_5.1\Engine\Binaries\Win64>UnrealPak.exe "S:\Steam\steamapps\common\DRAGON QUEST X OFFLINE\Game\Content\Paks\pakchunk0-WindowsNoEditor_GoodFileStructure_P.ucas" \
-list
LogPakFile: Display: Using command line for crypto configuration
LogIoStore: Display: Mount point ../../../ # Will load ingame
LogIoStore: Display: "../../../StringTables/Game/System/System_Party/STT_PT_Talk.uasset" <...>
```
- UEcastoc

## 4.Start up the game
-->
## 3.Start up the game
- All of your edited `String Tables` will now be loaded ingame.
- Have fun!

<hr>

</details>

<details><summary><h1>Translate Game.locmeta/Game.locres files<br>via LocRes-Builder (Chinese/Korean versions only)</h1></summary>

## 0.Prerequisites
  - [DRAGON QUEST X OFFLINE (or Demo) from Steam](https://store.steampowered.com/app/1358750/XOFFLINE/)
  - FModel.exe from [4sval's github repo](https://github.com/4sval/FModel)
    - DRAGON QUEST X OFFLINE (or Demo)'s AES Key
    - DRAGON QUEST X OFFLINE (or Demo)'s [Mappings.usmap](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)
> [!NOTE]
> Check the commit history if it is missing
> 
  - LocRes-Builder-v0.1.2 from  [matyalatte's github repo](https://github.com/matyalatte/LocRes-Builder)
  - UnrealPak.exe (4.27.2 used in this tutorial) from [Epic Games' Unreal Engine](https://www.unrealengine.com/en-US/download)

## 1.FModel.exe
  - Download from [4sval's github repo](https://github.com/4sval/FModel), and extract all files.
  - At the `Directory Selector` window:
    - select `ADD UNDETECTED GAME`
    - Name it anything, e.g. DRAGON QUEST X OFFLINE
    - Choose where the game's paks are installed, e.g.:
      - `C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks`
    - Click the Add Game `+` button, then OK
  - Inside the main window:
    - `Settings` > `General` > `ADVANCED`
      - `Local Mapping File` [x] Enabled
      - `Mapping File Path` Choose where the DRAGON QUEST X OFFLINE Demo `Mappings.usmap` is installed.
    - `Directory` > `AES` > Input the game's `Main Static Key` (AES Key), and click OK

> [!Note]
> The pakchunks that were grayed out can now be opened.

  - Double-click `pakchunk0-WindowsNoEditor.pak` to open archive, from there:
    - Right-click `Game/Content/Localization/Game` and select `Export Folder's Packages Raw Data (.uasset)`

> [!Note]
> Console will log: Successfully exported `Game/Content/Localization/Game`
> 
> Click that highlighted part to open where it was exported for the following step.

## 2.LocRes-Builder-v0.1.2
  - Download from [matyalatte's github repo](https://github.com/matyalatte/LocRes-Builder), and extract all files.
  - Drag and drop `Game.locmeta` onto `convert.bat`
    - A command prompt will open and start saving out to: `./out/Game/*json`, for example:

    ```
    ./out/Game/locmeta.json
    ./out/Game/en.json
    ./out/Game/ja.json
    ./out/Game/ko.json
    ./out/Game/zh-Hans.json
    ./out/Game/zh-Hant.json
    ```

    - Edit the values in the `.json` file for your specified language
  - Drag and drop `locmeta.json` back onto the same `convert.bat` from previous step
    - A command prompt will open and start saving out to:

    ```
    ./out/Game/Game.locmeta
    ./out/Game/en/Game.locres
    ./out/Game/ja/Game.locres
    ./out/Game/ko/Game.locres
    ./out/Game/zh-Hans/Game.locres
    ./out/Game/zh-Hant/Game.locres
    ```

## 3.UnrealPak.exe
  - Make a response file (`responsefile.txt`), edit to include where your new `.locmeta`/`.locres` files were created and where in the `.pak` they need to go, e.g.:
    
    `"<LOCMETA/LOCRES_LOCATION>" "../../../<LOCATION_IN_PAK>"`

> [!IMPORTANT]
> The double-quotes, space, and `../../../` are required for the `.pak` to be created properly.

  ```
  "C:\Downloads\LocRes-Builder-v0.1.2\out\Game\Game.locmeta" "../../../Game/Content/Localization/Game/Game.locmeta"
  "C:\Downloads\LocRes-Builder-v0.1.2\out\Game\en\Game.locres" "../../../Game/Content/Localization/Game/en/Game.locres"
  "C:\Downloads\LocRes-Builder-v0.1.2\out\Game\ja\Game.locres" "../../../Game/Content/Localization/Game/ja/Game.locres"
  "C:\Downloads\LocRes-Builder-v0.1.2\out\Game\ko\Game.locres" "../../../Game/Content/Localization/Game/ko/Game.locres"
  "C:\Downloads\LocRes-Builder-v0.1.2\out\Game\zh-Hans\Game.locres" "../../../Game/Content/Localization/Game/zh-Hans/Game.locres"
  "C:\Downloads\LocRes-Builder-v0.1.2\out\Game\zh-Hant\Game.locres" "../../../Game/Content/Localization/Game/zh-Hant/Game.locres"
  ```

  - Open another command prompt, change to UnrealPak's directory, and input:
    ```
     UnrealPak <PakFilename> -Create=<ResponseFile>
    ```
    For example,
    ```
    UnrealPak "C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\pakchunk0-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak" -Create="C:\Downloads\responsefile.txt"
    ```
> [!IMPORTANT]
> The `_P` is required for the patch `_P.pak` to be work properly.

## 4. Start up the game
  - All of your edited translations from [Step 2](#2.LocRes-Builder-v0.1.2) will now be loaded ingame, as long as you have the corresponding langauge selected.
  - Have fun!

</details>


<details><summary><h1>Replace Fonts via UE4Editor</h1></summary>

## 0.Prerequisites
  - [DRAGON QUEST X OFFLINE (or Demo) from Steam](https://store.steampowered.com/app/1358750/XOFFLINE/)
  - UE4Editor.exe (4.27.2 used in this tutorial) from [Epic Games' Unreal Engine](https://www.unrealengine.com/en-US/download)

## 1.UE4Editor.exe
  - Open UE4Editor.exe and create a new project.
    - Select Template Category `Blank Project` > Select Template `Blank` > Project Settings `Desktop/Console` & `No Starter Content`
      - Select a location for your project to be stored and its name, e.g., Folder `C:\Downloads\UE_4.27\Projects`, Name `Game`
  - Once your project loads, go to the `Content Browser` on the bottom and click the `Show or hide the sources panel` to ensure you are working in the correct folders.
> [!IMPORTANT]
> Make sure to double-check your spelling and capitalization, to save you from having to troubleshoot later.
  - Right-click on the `Content` folder, select `New Folder`, and name it `UI`.
  - Right-click on the `UI` folder, select `New Folder`, and name it `Font`.
    - In the `Content > UI > Font` folder, you can drag and drop your preferred `.ttf` font file into the marked area to begin the font import process.
      - A window will pop-up asking if you would `like to create a new Font asset using the imported Font Face as its default font`; click yes. 
      - 2 files will appear—if you hover over them, they will display `(Font)` & `(Font Face)`—double-click the `(Font)` to set up the fonts you want to show up in game.
      - The `Default Font Family` will be filled in already because of the yes prompt earlier, but you can change it after importing another `(Font Face)` with the dropdown menu next to the font's name, if you prefer.
      - For the `Fallback Font Family`, I would recommend a font for whichever region of the game you are going to be playing on, so that if there is untranslated text, it will fallback to that instead of disappearing from the screen entirely.
      - Click `Add Sub-Font Family` and in the `Cultures:` box you can put the ISO-639 language code (`ja = Japan, ko = Korean, zh-Hans = Simplified Chinese, etc.`) of the region(s) you will be playing. Multiple regions can be joined by using semicolons (`;`, e.g., `ko; zh-Hans; zh-Hant`).
> [!NOTE]
> Later on—once you are playing the game—if the font looks too small, you can increase its size by using the `Scaling Factor:` number, and repackaging everything again, like in the following steps.

  - Exit the `Composite Font` editor window, right-click, and rename your `(Font)` to `IW4D3_Font`.
  - Double-click your `(Font Face)`, and the change its settings:
      - Hinting `None`, Loading Policy `Inline`, Show Advanced > Layout Method `Bounding Box`. Repeat the same step for each imported `(Font Face)`.
      - Exit the `Font Details` window, then `Save All`.
  - Click the `Content` folder to be get taken back to the top folder.
    - Right-click in the content browser area, select `Miscellaneous > Data Asset > PrimaryAssetLabel`, then double-click into it.
      - Chunk ID `30`, Cook Rule `Always Cook`, Label Assets in My Directory [x], save and exit the window.
  - `Edit > Project Settings > Project > Packaging > Packaging`, enter the following settings:
    - Use Pak File [x], Use Io Store [x], Generate Chunks [x]
  - Exit to `Content Browser` window, then right-click your `Content` folder, select `Show in Explorer` to open up the file explorer.
    - Go up 1 level to your `<PROJECT_NAME>` folder, enter `Config`, and make a new text document named `DefaultPakFileRules.ini`.
      - Inside of it, enter the following:

      ```ini
      [bExcludeFromPaks_Engine]
      bExcludeFromPaks=true
      bOverrideChunkManifest=true
      +Files=".../Engine/..."
      +Files="...Game.uproject"
      +Files="...Game/*"
      +Files="...Game/Config/..."
      +Files="...Game/Content/Shader*"
      +Files="...Game/Platforms/..."
      +Files=".../*.upluginmanifest"
      ```
      - With this, the packaged project will be slimmed down to only the imported fonts.

  - Go back to the `Content Browser` window, then click `File > Package Project > Windows (64-bit)`
> [!NOTE]
> If you get the `Unsupported Platform` pop-up, you can ignore it. 
> Click continue, and choose a folder to package your project into, e.g.,
  `"C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\pakchunk30-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak"`
  - Your project will begin packaging, and alert when it's finished.
  - Rename the newly created `pakchunk`**30**`-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak/ucas/utoc)` to
  `"C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\pakchunk`**0**`-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.(pak/ucas/utoc)"`

## 2.Start up the game
  - All of your edited fonts from Step 1 will now be loaded ingame, as long as you have the corresponding langauge selected.
  - Have fun!

</details>

<details><summary><h1>Edit Fonts via GlyphrStudio</h1></summary>

## 0.Prequisites
  - A font of your choice

## 1.GlyphrStudio.com/app/
  - Following the `Replace Fonts via UE4Editor` tutorial, if your fonts don't look correct ingame (too wide/narrow, line gaps cutting off text, etc.):
  - Go to [GlypherStudio](https://www.glyphrstudio.com/app/), and edit it to your liking, e.g.:
  - `Landing page` > `Load` > drag-and-drop your font file, then wait for it to import into the editor.
    - Text too wide/narrow:
      - `Page Overview` > `Page Global Actions` > `Move and resize`
        - `Horizontally scale all glyphs` > `Scale Value` > choose a value (narrower < 1 > wider) > `Scale All Glyphs`
    - Line Gaps cutting off/smashing into other text:
      - `Page Settings` > `Font` > `Font Metrics` > `Other Metrics` > `Line Gap:`
        - choose a value (smaller gaps < current > bigger gaps)
          - [!NOTE] You may have to increase by a `100 Em` at a time, to see any noticeable changes.
    - Finished editing:
      - `File` > `Export OTF File`
        - [!NOTE] With that, your edited font is ready to be put back into UE4Editor

## 2.UE4Editor.exe
  - Follow the steps outlined in the above tutorial, to test out your new font.
  - Have fun!
  
</details>

<details><summary><h1>Translate .ETP files via dqx_dat_dump</h1></summary>

## 0.Prerequisites
- [DRAGON QUEST X OFFLINE (or Demo) from Steam](https://store.steampowered.com/app/1358750/XOFFLINE/)
  - [Dragon Quest X Online - Windows (free) Version](https://hiroba.dqx.jp/sc/public/playguide/wintrial_1/)
  - [Dragon Quest X Offline - Nintendo eShop](https://store-jp.nintendo.com/list/software/70010000042357.html)
    - Title ID `0100E2E0152E4000`
- [Python 3.11](https://www.python.org/downloads/release/python-3110/)
- [dqx-translation-project/dqx_dat_dump](https://github.com/dqx-translation-project/dqx_dat_dump)
- FModel.exe from [4sval's github repo](https://github.com/4sval/FModel)
  - DRAGON QUEST X OFFLINE (or Demo)'s AES Key
  - DRAGON QUEST X OFFLINE (or Demo)'s [Mappings.usmap](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)
> [!NOTE]
> Check the commit history if it is missing
> 

- UnrealPak.exe (4.27.2 used in this tutorial) from [Epic Games' Unreal Engine](https://www.unrealengine.com/en-US/download)

## 1.FModel.exe
  - Download from [4sval's github repo](https://github.com/4sval/FModel), and extract all files.
  - At the `Directory Selector` window:
    - select `ADD UNDETECTED GAME`
    - Name it anything, e.g. DRAGON QUEST X OFFLINE
    - Choose where the game's paks are installed, e.g.:
      - `C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks`
    - Click the Add Game `+` button, then OK
  - Inside the main window:
    - `Settings` > `General` > `ADVANCED`
      - `Local Mapping File` [x] Enabled
      - `Mapping File Path` Choose where the DRAGON QUEST X OFFLINE Demo `Mappings.usmap` is installed.
    - `Directory` > `AES` > Input the game's `Main Static Key` (AES Key), and click OK

> [!Note]
> The pakchunks that were grayed out can now be opened.

  - Double-click `pakchunk0-WindowsNoEditor.pak` to open archive, from there:
    - Right-click `Game/Content/NonAssets/ETP` (or `ETP_ko`, `ETP_zh_hans`, etc.) and select `Export Folder's Packages Raw Data (.uasset)`

> [!Note]
> Console will log: Successfully exported `Game/Content/NonAssets/ETP` (or `ETP_ko`, `ETP_zh_hans`, etc.)
> 
> Click that highlighted part to open where it was exported for the following step.

## 2.dqx_dat_dump
  - Install Dragon Quest X Online - Windows (free) Version, if not installed already.
  - Open a command prompt and change directories to where dqx_dat_dump was installed, e.g.,<br>`C:\Downloads\dqx-translation-project\dqx_dat_dump\`, and enter the following:

  ```python
  >> python -m venv venv
  >> .\venv\Scripts\activate
  >> (venv) pip install -r requirements.txt
  ```

  - Leave the command prompt open, start and log into Dragon Quest X Online's main menu, then switch back to the command prompt:

  ```python
  >> (venv) cd .\tools\dump_etps\
  >> (venv) python .\dump_etps.py -u
  ```

> [!NOTE]
> Dumps .ETP's from Dragon Quest X Online to 
> `C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\dump_etps\etps`

> [!IMPORTANT]
> If you receive an error:
> Verify that `GAME_DATA_DIR` in `<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\`globals.py matches the install location you chose for Dragon Quest X Online, e.g.,
> `"C:/Program Files (x86)/SquareEnix/DRAGON QUEST X/Game/Content/Data"`

 - Leave the command prompt open, copy and paste the contents of the `ETP` (or `ETP_ko`, `ETP_zh_hans`, etc.) folder into the `...\dump_etps\etps`—overwriting existing files—then switch back to the command prompt.

  ```python
  >> (venv) cd ..\packing
  >> (venv) python .\unpack_etp.py -a
  ```

> [!NOTE]
> Unpacks .ETP's from `...\dump_etps\etps` to 
> `C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\packing\json\`

  - Leave the command prompt open, edit the `.json` files in `C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\packing\json\en`, save them to `C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\packing\new_json\en`, then switch back to the command prompt:

  ```python
  >> (venv) cd ..\packing
  >> (venv) python .\pack_etp.py -a
  ```

> [!NOTE]
> Packs .json's from `...\new_json\en` to 
> `C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\packing\new_etps\`

  - You may close out that command prompt.

## 3.UnrealPak.exe 
  - Make a response file (`responsefile.txt`), edit to include where your new `.etp` files were created and where in the `.pak` they need to go, e.g.:
  `"<NEW_ETPS_LOCATION>" "../../../<LOCATION_IN_PAK>"` or

  ```
  "C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\packing\new_etps\*" "../../../Game/Content/NonAssets/ETP/"
  ```

> [!IMPORTANT]
> The double-quotes, space, and `../../../` are required for the `.pak` to be created properly.

  - Open another command prompt, go to the directory where `UnrealPak.exe` is installed, e.g., `"C:\Downloads\UE_4.27\Engine\Binaries\Win64\"`, then input the following:

```cmd
UnrealPak.exe "<DRAGON_QUEST_X_OFFLINE_(or_Demo)_Install_Location>\pakchunk0-WindowsNoEditor_{ModName}_{ModVersion}_P.pak" -Create="<responsefile_location>"
```

or

```cmd
UnrealPak.exe "C:\Program Files (x86)\Steam\steamapps\common\DRAGON QUEST X OFFLINE Demo\Game\Content\Paks\pakchunk30-WindowsNoEditor_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak" -Create="C:\Downloads\dqx-translation-project\dqx_dat_dump\tools\packing\responsefile.txt"
```

## 4.Start up the game
  - All of your edited `.etp`'s from Step 1 will now be loaded ingame, as long as you have the corresponding langauge selected.
  - Have fun!

---

</details>

<details><summary><h1>Build UnrealEngine4.27.2-release for<br>GitHub Actions Linux self-hosted runner</h1></summary>

## 01.Create GitHub Actions Self-Hosted Runner (SHR)
  -  `github.com/{YourUsername}/{YourRepo}` > `Settings` > `Actions` > `Runners` > `New Self-Hosted Runner`
  - select `Linux`, then follow the instructions listed below the buttons.
    - See GitHub's Documentation[^1] for more details.

## 02.Setup Unreal Engine

0. Open a Linux bash under your new created `SHR` user's root directory (`cd ~`), for the following steps:

1.  `git clone --depth 1 -b 4.27.2-release --single-branch https://github.com/EpicGames/UnrealEngine.git`
    -   clones just the latest commit of UnrealEngine 4.27.2
    > [!NOTE] or download `Source Code` (`zip` or `tar.gz`) and `Commit.gitdeps.xml` from EpicGames' [GitHub repo](https://github.com/EpicGames/UnrealEngine/releases/tag/4.27.2-release)
2.  `cd ./UnrealEngine`[^2]

    1.  Replace "`./UnrealEngine/Engine/Build/`[Commit.gitdeps.xml](https://github.com/EpicGames/UnrealEngine/releases/download/4.27.2-release/Commit.gitdeps.xml)"[^3].
        -   fixes `Failed to download '...dependencies...'` error in next step
    2.  `sudo chmod +x` :

        > `./Engine/Build/BatchFiles/Linux/GitDependencies.sh`
        >
        > `./Engine/Binaries/ThirdParty/Mono/Linux/bin/mono`
        >
        > `./Engine/Build/BatchFiles/Linux/Setup.sh`
        >
        >
        > `./Engine/Build/BatchFiles/Linux/SetupToolchain.sh`
        >
        > -   Fixes `permission denied` errors.
    3. `sudo apt-get install xdg-utils`
        - fixes `/bin/bash: xdg-mime: No such file or directory` error.

    4.  `./setup.sh -exclude=Android -exclude=Dingo -exclude=Documentation -exclude=HTML5 -exclude=IOS -exclude=Mac -exclude=MacOS -exclude=MacOSX -exclude=osx -exclude=osx32 -exclude=osx64 -exclude=PS4 -exclude=Samples -exclude=Switch -exclude=Templates -exclude=TVOS -exclude=Win32 -exclude=Win64 -exclude=Windows -exclude=WinRT -exclude=XboxOne`
        > [!IMPORTANT] `DotNET` is required for `./GenerateProjectFiles.sh` step, **DO NOT ADD** `-exclude=DotNET`
        -   excludes unnecessary builds aka less space taken up.
        -   After successful run, `./Binaries/Linux/*` will be created
    <!-- 5.  ???`./setup.sh -exclude=Android -exclude=Dingo -exclude=Documentation -exclude=HTML5 -exclude=IOS -exclude=Mac -exclude=MacOS -exclude=MacOSX -exclude=osx -exclude=osx32 -exclude=osx64 -exclude=PS4 -exclude=Samples -exclude=Switch -exclude=Templates -exclude=ThirdParty -exclude=TVOS -exclude=Win32 -exclude=Win64 -exclude=Windows -exclude=WinRT -exclude=XboxOne` -->
    6.  `./GenerateProjectFiles.sh`
        -   generates makefiles and CMakelists.txt
    7.  `make UnrealPak`
        -   makes `Unrealpak` and its dependencies in ~210s
---

</details>

# Glossary
- ***`.ucas`*** is a Content Addressable Store, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to contain all the assets.
- ***`.utoc`*** is a Table Of Contents, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to describe the ***.ucas*** file, including chunk size and offset, compression format, and whether the chunks are encrypted.
- ***`.ufont`*** is a ***.ttf*** font file
- ***`global`*** file is an offline computed dependency graph for your assets.
- ***`.pak`*** When using this setup the file will store loose files such as fonts.
- The upside to using the io store is a noticeable improvement to loading times.

<details><summary>Template Literals</summary>

|Template Literal|Comment(s)|
|:-:|:-|
|`<%03dEV_LUA_NUM_1>`||
|`<%03dEV_LUA_NUM_2>`||
|`<%04nEV_LUA_NUM_1>`||
|`<%dEV_FEE_EXP>`||
|`<%dEV_FEE_FAME>`||
|`<%dEV_FEE_GOLD>`||
|`<%dEV_FEE_ITEM_N>`||
|`<%dEV_FEE_MEDAL>`||
|`<%dEV_FEE_TATUJIN>`||
|`<%dEV_FEE_TOKKUN>`||
|`<%dEV_LUA_NUM_1>`||
|`<%dEV_LUA_NUM_2>`||
|`<%dEV_LUA_NUM_3>`||
|`<%dEV_NUM>`||
|`<%dEV_QUE_N_NUM0>`||
|`<%dEV_QUE_N_NUM1>`||
|`<%dEV_QUE_R_NUM0>`||
|`<%dEV_QUE_R_NUM1>`||
|`<%dEV_QUE_S_NUM0>`||
|`<%dEV_QUE_S_NUM1>`||
|`<%dEV_QUE_T_NUM0>`||
|`<%dEV_QUE_T_NUM1>`||
|`<%dEV_TB_NOW_NUM>`||
|`<%dEV_TB_REM_NUM>`||
|`<%dEV_TB_TGT_NUM>`||
|`<%nEV_ANY_N_NUM0>`||
|`<%nEV_FEE_EXP>`||
|`<%nEV_FEE_ITEM_N>`||
|`<%nEV_FEE_TOKKUN>`||
|`<%nEV_LUA_NUM_1>`||
|`<%nEV_LUA_NUM_2>`||
|`<%nEV_LUA_NUM_3>`||
|`<%nEV_LUA_NUM_4>`||
|`<%nEV_QUE_LIMIT>`||
|`<%nEV_QUE_N_NUM0>`||
|`<%nEV_QUE_N_NUM1>`||
|`<%nEV_QUE_N_NUM2>`||
|`<%nEV_QUE_S_NUM0>`||
|`<%nEV_QUE_S_NUM1>`||
|`<%nEV_QUE_T_NUM0>`||
|`<%nEV_QUE_T_NUM1>`||
|`<%nEV_QUE_T_NUM2>`||
|`<%nEV_QUE_T_NUM3>`||
|`<%nEV_QUE_T_NUM4>`||
|`<%nEV_QUE_T_NUM5>`||
|`<%nEV_QUE_T_NUM6>`||
|`<%nEV_SLOT1>`||
|`<%nEV_SLOT2>`||
|`<%nEV_TB_NOW_NUM>`||
|`<%nEV_TB_TGT_NUM>`||
|`<%nL_GOLD>`||
|`<%nL_GOLD_A>`||
|`<%nM_Num>`||
|`<%nQUESP_LV>`||
|`<%nW_AD>`||
|`<%nW_AM>`||
|`<%nW_BD>`||
|`<%nW_BM>`||
|`<%nW_HOUR>`||
|`<%nW_MIN>`||
|`<%nW_RANK>`||
|`<%nW_SD>`||
|`<%nW_SEC>`||
|`<%nW_SM>`||
|`<%sB_TARGET>`||
|`<%sCAM_MYCLASS>`||
|`<%sCAM_MYKOIBITO>`||
|`<%sC_SENTAKU_TEXT>`||
|`<%sEV_AREA_NAME2>`||
|`<%sEV_AREA_NAME>`||
|`<%sEV_CAT_CATEGORY>`||
|`<%sEV_CAT_COLOR>`||
|`<%sEV_CAT_NAME>`||
|`<%sEV_CAT_SIZE>`||
|`<%sEV_DIRECTION>`||
|`<%sEV_FEE_ACTION>`||
|`<%sEV_FEE_EMOTE>`||
|`<%sEV_FEE_ITEM>`||
|`<%sEV_FEE_ITEM_A>`||
|`<%sEV_FEE_JOB>`||
|`<%sEV_FEE_TATIPOZU>`||
|`<%sEV_FLOWER_NAME>`||
|`<%sEV_ITEM2>`||
|`<%sEV_ITEM3>`||
|`<%sEV_ITEM>`||
|`<%sEV_JUMP_ROOM>`||
|`<%sEV_KESYOU>`||
|`<%sEV_KESYOU_CLR>`||
|`<%sEV_LUA_STRING1>`||
|`<%sEV_LUA_STRING2>`||
|`<%sEV_LUA_STRING3>`||
|`<%sEV_LUA_STRING4>`||
|`<%sEV_LUA_STRING5>`||
|`<%sEV_NPC>`||
|`<%sEV_NUIGURUMI>`||
|`<%sEV_ONSEN>`||
|`<%sEV_PERSONALITY>`||
|`<%sEV_QUEST_NAME>`||
|`<%sEV_QUE_ITEM>`||
|`<%sEV_QUE_NAME0>`||
|`<%sEV_QUE_NAME1>`||
|`<%sEV_QUE_NAME2>`||
|`<%sEV_QUE_NAME3>`||
|`<%sEV_QUE_NAME4>`||
|`<%sEV_QUE_NAME5>`||
|`<%sEV_QUE_NAME6>`||
|`<%sEV_QUE_NAME7>`||
|`<%sEV_QUE_NAME8>`||
|`<%sEV_QUE_NAME9>`||
|`<%sEV_RENTAL_NAME>`||
|`<%sEV_SELECT_MSG1>`||
|`<%sEV_SELECT_MSG2>`||
|`<%sEV_SELECT_MSG3>`||
|`<%sEV_SELECT_MSG4>`||
|`<%sEV_SHUSHIN_T>`||
|`<%sEV_SNPC>`||
|`<%sEV_SYOK_HOSI>`||
|`<%sEV_SYOK_ITEM>`||
|`<%sEV_SYSMSG_NPC>`||
|`<%sEV_TB_AREA_NM>`||
|`<%sEV_TB_CONT_NM>`||
|`<%sEV_TB_MON_NM>`||
|`<%sEV_WIN_BIYOUSI>`||
|`<%sEV_WIN_COLOR>`||
|`<%sL_CAT_TYPE_NAME>`||
|`<%sL_COLOR_A>`||
|`<%sL_COLOR_B>`||
|`<%sL_COLOR_C>`||
|`<%sL_COLOR_D>`||
|`<%sL_ITEM2>`||
|`<%sL_ITEM>`||
|`<%sL_RACE_AFTER>`||
|`<%sL_RECIPE>`||
|`<%sL_TIMEI>`||
|`<%sM_Card>`||
|`<%sM_Reward>`||
|`<%sM_item2>`||
|`<%sM_item>`||
|`<%sQUESP_EQUIPSET>`||
|`<%sQUESP_JOB>`||
|`<%sQUESP_SHIGUSA>`||
|`<%sQUESP_SURA>`||
|`<%sQUESP_SYOGOC>`||
|`<%sQUESP_SYOGOM>`||
|`<%sQUESP_SYOGOW>`||
|`<%sQUESP_SYOKU>`||
|`<%sQUE_IRAISYA>`||
|`<%sW_KOUZA>`||
|`<%sW_MIS>`||
|`<%sW_STAGE>`||
|`<>`||
|`<Center>`||
|`<LEFT>`||
|`<Left>`||
|`<attr>`||
|`<auto_br=5000>`||
|`<auto_bw=1000>`||
|`<auto_bw=3000>`||
|`<auto_bw=5000>`||
|`<autorun>`||
|`<big_shake>`||
|`<br>`||
|`<br_break>`||
|`<break>`||
|`<bw_break>`||
|`<bw_clear>`||
|`<bw_hide>`||
|`<case 1>`||
|`<case 2>`||
|`<case 3>`||
|`<case 4>`||
|`<case 5>`||
|`<case 6>`||
|`<case 7>`||
|`<case 8>`||
|`<case2>`||
|`<case_cancel>`||
|`<case_end>`||
|`<center>`||
|`<char_move_forward>`||
|`<chara_move>`||
|`<client_pcname>`||
|`<close>`||
|`<close_irai>`||
|`<color_white>`||
|`<color_yellow>`||
|`<communication>`||
|`<convenience>`||
|`<cp_end>`||
|`<cp_etc 7>`||
|`<cp_etc 8>`||
|`<cp_set 21>`||
|`<cp_set 39>`||
|`<cp_set 63>`||
|`<cp_set 67>`||
|`<cp_set 68>`||
|`<cp_start>`||
|`<cs_pchero>`||
|`<cs_pchero_race>`||
|`<e_turn_dir_s>`||
|`<e_turn_dir_w>`||
|`<else>`||
|`<emoji FaceButton_Left>`||
|`<emoji FaceButton_Right>`||
|`<emoji Fukidashi_Icon>`||
|`<emoji LeftStick>`||
|`<emoji LeftTrigger>`||
|`<emoji Question_Icon>`||
|`<emoji RightShoulder>`||
|`<emoji RightStick_UpDown>`||
|`<emoji RightTrigger>`||
|`<emoji SpecialRight>`||
|`<end>`||
|`<end_attr>`||
|`<endif>`||
|`<feel_Think_lv1>`||
|`<feel_angry_lv1>`||
|`<feel_angry_lv2>`||
|`<feel_angry_lv3>`||
|`<feel_angry_one>`||
|`<feel_angry_silent>`||
|`<feel_custom>`||
|`<feel_happy_lv1>`||
|`<feel_happy_lv2>`||
|`<feel_happy_lv3>`||
|`<feel_happy_one>`||
|`<feel_no_mt_normal>`||
|`<feel_normal_lv1>`||
|`<feel_normal_lv2>`||
|`<feel_normal_lv3>`||
|`<feel_normal_one>`||
|`<feel_normal_silent>`||
|`<feel_sad_lv1>`||
|`<feel_sad_lv2>`||
|`<feel_sad_lv3>`||
|`<feel_sad_one>`||
|`<feel_sad_silent>`||
|`<feel_think_lv1>`||
|`<feel_think_lv2>`||
|`<feel_think_lv3>`||
|`<feel_think_lv>`||
|`<feel_think_one>`||
|`<feel_think_silent>`||
|`<heart>`||
|`<icon_exc>`||
|`<icon_que>`||
|`<if_hum>`||
|`<if_kazi>`||
|`<if_mokkou>`||
|`<if_npc_man>`||
|`<if_tubo>`||
|`<if_woman>`||
|`<kyodai>`||
|`<kyodai_rel1>`||
|`<kyodai_rel2>`||
|`<kyodai_rel3>`||
|`<left>`||
|`<map>`||
|`<me 116>`||
|`<me 2401>`||
|`<me 57>`||
|`<me 60>`||
|`<me 61>`||
|`<me 64>`||
|`<me 69>`||
|`<me 70>`||
|`<me 71>`||
|`<me 72>`||
|`<me 74>`||
|`<me 78>`||
|`<me_60>`||
|`<me_71>`||
|`<me_nots 58>`||
|`<menu>`||
|`<monster_nakama>`||
|`<mount>`||
|`<name_off>`||
|`<open_irai>`||
|`<pc>`||
|`<pc_hiryu>`||
|`<pc_race>`||
|`<pc_rel1>`||
|`<pc_rel2>`||
|`<pc_syokugyo>`||
|`<pc_syokunin>`||
|`<pipipi_high>`||
|`<pipipi_low>`||
|`<pipipi_mid>`||
|`<pipipi_off>`||
|`<pipipi_on>`||
|`<pipipi_shigh>`||
|`<right>`||
|`<se FQ_136_1 0>`||
|`<se FQ_155_1 0>`||
|`<se FQ_182_1 0>`||
|`<se FQ_182_2 0>`||
|`<se FQ_182_2 1>`||
|`<se FQ_208_1 0>`||
|`<se FQ_208_1 1>`||
|`<se GS_009_1 0>`||
|`<se Joutyu_SE 117>`||
|`<se Joutyu_SE 137>`||
|`<se Joutyu_SE 35>`||
|`<se Joutyu_SE 46>`||
|`<se Joutyu_SE 49>`||
|`<se Joutyu_SE 58>`||
|`<se Joutyu_SE 60>`||
|`<se Joutyu_SE 85>`||
|`<se MQ_013_1 0>`||
|`<se S3_THR5_001 1>`||
|`<se S3_THR6_001 2>`||
|`<se S3_THR6_003 0>`||
|`<se S4_FOR1_001 0>`||
|`<se S4_FOR1_001 1>`||
|`<se System 18>`||
|`<se System 35>`||
|`<se System 7>`||
|`<se battle_cmn 189>`||
|`<se battle_magic 1>`||
|`<se joutyu Level_up>`||
|`<se joutyu sekihi>`||
|`<se map_common 2>`||
|`<se map_common 40 >`||
|`<se map_common 41 >`||
|`<se map_common 48 >`||
|`<se map_common 49 >`||
|`<se map_common map_jamp>`||
|`<se_nots  System 39>`||
|`<se_nots FQ_105_1 0>`||
|`<se_nots FQ_140_1 0>`||
|`<se_nots FQ_140_1 1>`||
|`<se_nots FQ_140_1 2>`||
|`<se_nots Joutyu_SE 10>`||
|`<se_nots Joutyu_SE 121>`||
|`<se_nots Joutyu_SE 131>`||
|`<se_nots Joutyu_SE 24>`||
|`<se_nots Joutyu_SE 38>`||
|`<se_nots Joutyu_SE 40>`||
|`<se_nots Joutyu_SE 42>`||
|`<se_nots Joutyu_SE 47>`||
|`<se_nots Joutyu_SE 57>`||
|`<se_nots Joutyu_SE 82>`||
|`<se_nots Joutyu_SE 83>`||
|`<se_nots Joutyu_SE 9>`||
|`<se_nots KQ_111_1 0>`||
|`<se_nots KQ_111_1 1>`||
|`<se_nots MQ_061_1 0>`||
|`<se_nots S3_DWF5_001 001>`||
|`<se_nots S3_DWF5_001 002>`||
|`<se_nots S3_THR6_001 2>`||
|`<se_nots S4_FOR7_001 0>`||
|`<se_nots S4_FOR8_001 2>`||
|`<se_nots SVC_001 0>`||
|`<se_nots System 18>`||
|`<se_nots System 39>`||
|`<se_nots System 7>`||
|`<se_nots System Guest_joinSE>`||
|`<se_nots System Item>`||
|`<se_nots battle_cmn 7>`||
|`<se_nots battle_magic 10>`||
|`<se_nots ev_FQ_104_1 1>`||
|`<se_nots joutyu SUCCESS>`||
|`<se_nots joutyu bravestone2>`||
|`<se_nots joutyu camera>`||
|`<se_nots joutyu hanko>`||
|`<se_nots joutyu kapoon>`||
|`<se_nots joutyu kusuri>`||
|`<se_nots joutyu map_close>`||
|`<se_nots joutyu mizuganagareru>`||
|`<se_nots joutyu nagarebosi>`||
|`<se_nots joutyu tag_AQ_016_1>`||
|`<se_nots joutyu tag_AQ_016_2>`||
|`<se_nots joutyu tag_AQ_019_1_Special_lunch>`||
|`<se_nots joutyu tag_Door_irS_s_cl>`||
|`<se_nots joutyu tag_Door_wdS_s_op>`||
|`<se_nots joutyu tag_FQ_105_11>`||
|`<se_nots joutyu tag_KQ_139_1_000_kagi_tsukuru>`||
|`<se_nots joutyu tag_MQ_013_10>`||
|`<se_nots joutyu tag_SIN9_YUKYU_OIL>`||
|`<se_nots joutyu tag_da_hit_l>`||
|`<se_nots joutyu tag_ev_FQ_101_1_chick>`||
|`<se_nots joutyu tag_ev_FQ_101_1_wing>`||
|`<se_nots joutyu tag_ev_FQ_104_1_cooking>`||
|`<se_nots joutyu tag_ev_FQ_107_1_gaya>`||
|`<se_nots joutyu tag_ev_FQ_107_1_reiteki>`||
|`<se_nots joutyu tag_kibako>`||
|`<se_nots joutyu tag_map_common_kagi_akeru>`||
|`<se_nots joutyu tag_nots_map_r2020_8>`||
|`<se_nots joutyu tag_warp>`||
|`<se_nots joutyu tag_warp_in>`||
|`<se_nots joutyu tarrot_rare>`||
|`<se_nots map_common 2>`||
|`<se_nots map_common 50>`||
|`<se_nots map_common 83>`||
|`<se_nots map_common 91 >`||
|`<se_nots map_common map_jamp>`||
|`<se_nots map_z4700 11>`||
|`<se_nots system Item>`||
|`<se_nots system medalget>`||
|`<select 1>`||
|`<select 2>`||
|`<select 3>`||
|`<select 6>`||
|`<select 7>`||
|`<select>`||
|`<select_end>`||
|`<select_mem>`||
|`<select_nc 2>`||
|`<select_nc>`||
|`<select_se_off>`||
|`<shake_big>`||
|`<shake_camera 1>`||
|`<shake_camera 28>`||
|`<shake_camera 29>`||
|`<shake_camera 2>`||
|`<shake_camera 30>`||
|`<shake_camera 31>`||
|`<shake_camera 32>`||
|`<shake_camera 33>`||
|`<shake_camera 34>`||
|`<shake_camera 35>`||
|`<shake_camera 37>`||
|`<shake_camera 38>`||
|`<shake_camera 40>`||
|`<shake_camera 41>`||
|`<shake_camera 42>`||
|`<shake_camera 43>`||
|`<shake_small>`||
|`<sort>`||
|`<speed=0>`||
|`<start_lip_sync al01 _normal m00001>`||
|`<start_lip_sync br01 _normal m00001>`||
|`<start_lip_sync c00552 _normal m00001>`||
|`<start_lip_sync nh0001 _normal m00001>`||
|`<stop_lip_animation al01 CLOSE_MOUTH>`||
|`<stop_lip_animation br01 CLOSE_MOUTH>`||
|`<stop_lip_animation c00552 CLOSE_MOUTH>`||
|`<stop_lip_animation nh0001 CLOSE_MOUTH>`||
|`<turn_pc>`||
|`<turn_rot 0.0>`||
|`<turn_rot 2.3>`||
|`<update_quedate>`||
|`<voice 00000_00008130>`||
|`<voice 9727_a>`||
|`<voice 9727_b>`||
|`<wait 4800>`||
|`<wait=1000>`||
|`<wait=3000>`||
|`<wait=50>`||
|`<yesno 2>`||
|`<yesno2>`||
|`<yesno>`||
|`<yesno_nc>`||

</details>

### External Links

> [^1]: [GitHub Docs - Hosting your own runners](https://docs.github.com/en/actions/hosting-your-own-runners).
>
> [^2]: This tutorial roughly follows the [Linux Native compilation guide](https://github.com/EpicGames/UnrealEngine/blob/4.27.2-release/Engine/Build/BatchFiles/Linux/README.md) from `github.com/EpicGames/UnrealEngine`.
>
> [^3]: Correct [Commit.gitdeps.xml](https://github.com/EpicGames/UnrealEngine/releases/download/4.27.2-release/Commit.gitdeps.xml) to prevent `(403) Forbidden` errors during `updating dependencies` step.
