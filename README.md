# Tutorial - Patch `.pak` Files ( `_P.pak` )

## Prerequisites
- [Python 3.11](https://www.python.org/downloads/release/python-3110/)
- [dqx-translation-project/dqx_dat_dump](https://github.com/dqx-translation-project/dqx_dat_dump)
- ドラゴンクエストX　目覚めし五つの種族　オフライン
  - [Dragon Quest X Online - Windows (free) Version](https://hiroba.dqx.jp/sc/public/playguide/wintrial_1/)
  - [Dragon Quest X Offline - Nintendo eShop](https://store-jp.nintendo.com/list/software/70010000042357.html)<br>(Title ID `0100E2E0152E4000`)
  - Dragon Quest X Offline's AES Key

- [Unreal Engine](https://www.unrealengine.com/en-US/download) (v5.1 used in this tutorial)
- [FModel (Unreal Engine Archives Explorer/Exporter)](https://github.com/4sval/FModel)
  - ***Unreal Mappings Archive*** to use as FModel's [Local Mapping File](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)

## pakchunk0-Switch.pak (.etp > .json > .etp > _P.pak)
### 1. Install Dragon Quest X Online
Install Dragon Quest X Online - Windows (free) Version, if not installed already.

### 2. Prepping .etp files
Make a new directory (***etps***) at
  > `<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\dump_etps\`etps\

- copy all your `.etp` files here 

### 3. Prepping dump tools
> `<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\`globals.py 
- Verify that `GAME_DATA_DIR` matches the install location you chose for DQX.
> [!TIP]
> Default location:
> 
> `"C:/Program Files (x86)/SquareEnix/DRAGON QUEST X/Game/Content/Data"`

### 4. Dump tools usage: .etp files into .json
Open up a terminal (cmd, powershell, etc.) in
  > `<Working_Directory>\dqx-translation-project\dqx_dat_dump\`
  
  then input the following:
  > [!TIP]
  > `>>` denotes the start of a new line
> >
  > `<Working_Directory>` is where you have `dqx-translation-project\dqx_dat_dump` installed
  ```python
  >> python -m venv venv
  >> .\venv\Scripts\activate
  >> (venv) pip install -r requirements.txt
  >> (venv) cd .\tools\packing\
  >> (venv) <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing> python .\unpack_etp.py -a
  ```
  This will unpack your `.etp` files into `.json` files at
  > <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\json\en
  > <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\json\ja
  
  From where you can edit the `.json` files in `json\en`

### 5. Dump tools usage: .json files into .etp
After you are finished editing your localized `.json` files, copy the modified files into
  > <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\new_json\en
  - then you can repack them into their original `.etp` format with
  ```python
  >> (venv) <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing> python .\pack_etp.py -a
  ```
  > [!NOTE]
  > The finished files will output to `<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\`new_etp

### 6. Prepping unrealpak.exe, `-create=<ResponseFile>`
- Create a new text document named `responsefile.txt` to use as the `<ResponseFile>` for unrealpak.exe
> [!TIP]
> `responsefile.txt` a file that tells unrealpak.exe how to properly create your patch `_P.pak`
- then input the following and save the file:
    ```
    "<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\new_etp\*" "../../../Holiday/Content/NonAssets/ETP/"
    ```

## Unrealpak.exe (Unreal Engine v5.1)
### 7. Create a patch (`_P.pak`)
Open a terminal in
> <Unreal_Engine_Install_Directory>\Engine\Binaries\Win64

then run
```cmd
UnrealPak.exe <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\pakchunk0-Switch_{ModName}_{ModVersion}_P.pak -Create=<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\responsefile.txt
```
to create a patch `_P.pak` with all your modified `.etp` files

### 8. Install the patch `_P.pak`
Copy the newly created `pakchunk0-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak` to your preferred platform:

>[!IMPORTANT]
> ### Steam
> `"<SteamDir>/steamapps/common/DRAGON QUEST X OFFLINE/Game/Content/Paks/pakchunk0-WindowsNoEditor_{ModName}_{ModVersion}_P.pak"`
>
> ### Switch
> `sd:/atmosphere/contents/0100E2E0152E4000/romfs/Holiday/Content/Paks/pakchunk0-Switch_{ModName}_{ModVersion}_P.pak`
>
> ### Yuzu
> `%YUZU_DIR%/load/0100E2E0152E4000/<YOUR_MOD_NAME>/romfs/Holiday/Content/Paks/pakchunk0-Switch_{ModName}_{ModVersion}_P.pak`

### 9. Start the game to play with your modified text, congratulations!

<hr>

# pakchunk0-Switch.utoc - StringTables
### FModel
- **`Settings`** > **`General`**
  - **`Output Directory`**<br>
    - Location where you want `Export Folder's Packages Raw Data (.uasset)` to go; explained further ahead.
  - **`Game's Archive Directory`**<br>
    - Location where your `romfs` folder is.
  - `Local Mapping File`: **Enabled**
  - `Mapping File Path`:
    - Location where your Unreal Mappings Archive (`Mappings.usmap`) is.
- **`Archives`** tab
  - Double-click `pakchunk0-Switch.pak` to open it
- **`Folders`** tab
  - Right-click `Holiday` and choose `Export Folder's Packages Raw Data (.uasset)`.<br><br>After some time, the files will be exported to "`<Output_Directory>\Exports`".

<hr>

### Powershell (run as admin)
  - "<span style="color: yellow">Set-ExecutionPolicy</span>` RemoteSigned`"
      - to allow `dump_tables.ps1` to work properly.
          - <span style="color: yellow">cd</span>` "Output Directory\pakchunk0-Switch.utoc\Exports\Holiday\Content\"`
              - copy `UE4localizationsTool.exe` & `dump_tables.ps1` into the same directory.
          - "<span style="color: yellow">.\dump_tables.ps1</span>` export`"
              - to export all ***.uassets*** in "`\StringTables`" as ***.txt*** in "`\StringTables_modified`".
              - Modify the text in the ***.txt*** files, taking care not to modify the filenames and tags left of the `=` sign.
          - "<span style="color: yellow">.\dump_tables.ps1</span>` import`"
              - to import all ***.txt*** in "`\StringTables_modified`" as ***.uassets*** in "`\StringTables_final`".
  - "<span style="color: yellow">Set-ExecutionPolicy</span>` Restricted`"
      - to reset to safety settings to their default value.

<hr>

# Tutorial - Patch `.ucas` & `.utoc` Files ( `_P.ucas` & `_P.utoc` )

## Prerequisites
- Unreal Editor 4.27.2 (`UE4Editor.exe`), bundled with [Unreal Engine 4.27.2](https://www.unrealengine.com/en-US/download)

- [190nm's fork of UEcastoc (`UEcastoc-master`)](https://github.com/190nm/UEcastoc)

- `%localappdata%\Temp\go-oodle\oo2core_9_win64.dll`
	- If you get Error:<br>`Failed to load %localappdata%\Temp\go-oodle\oo2core_9_win64.dll: %1 is not a valid Win32 application.`<br>redownload `oo2core_9_win64.dll`

## UE4Editor.exe
- `New Blank Project` > `Blank` > `No Starter Content` > Name your project > `Create Project`

- `Edit` > `Project Settings` > `Project - Packaging`
	- Use `Io Store`, `Generate Chunks` = Enabled

- `Content Browser`
	1. Rightclick > `New Folder` (ctrl+n)
	2. name as folder to be overwritten (e.g., `StringTables`), repeat as necessary.
	3. Rightclick > `Miscellaneous` > `Data Asset` > `PrimaryAssetLabel`
		- Doubleclick `NewDataAsset` > Rules
		- `Chunk ID` = anything between 20-99 to properly overwrite game's original pakchunk# files
		- `Cook Rule` = Always Cook
		- `Label Assets in My Directory` = enabled
		- `Save` and close out of `NewDataAsset`
	4. Repeat steps 1 & 2, (e.g., `StringTables\GAME\`)
	5. Rightclick > `Miscellaneous` > `StringTable`
		- name as file to be overwritten (e.g., `STT_System_Location`), repeat as necessary.
		- Doubleclick new file
		- `Import from CSV` > select corresponding file (e.g., `STT_System_Location.csv`) from your Repo > Keys & Source Strings will autofill
		- `Save` and close out of file.
	6. Repeat Step 5 as necessary.

- `File` > `Package Project` > `Windows (64-Bit)` > choose your `outputDir`
	- If you get Error: `Unsupported Platform`, Continue anyways
	- `Packaging project for Windows (64-bit)...` will show in corner & sound may play, as it packages your project.
	- `Packaging Complete!` > Files output to `outputDir\WindowsNoEditor\{ProjectName}\Content\Paks\pak{Chunk ID}-WindowsNoEditor.(pak|ucas|utoc)`

## UEcastoc
1. `installDir\UEcastoc-master\cpp\` > type `cmd` in filepath bar to open a `command prompt`
2. `main.exe manifest [utocPath, ucasPath, outputManifest, *AES key]`
	- (e.g., `main.exe manifest pakchunk30-WindowsNoEditor.utoc pakchunk30-WindowsNoEditor.ucas manifest.json`)
	- Creates `manifest.json` file of the `.utoc`/`.ucas` files, to be used later.
	- Edit manifest.json `Path` object values:
		- (Steam: `"Path": "/XXX.uasset"` > `"Path": "/Game/Content/StringTables/GAME/XXX.uasset"`)
			- (e.g., `"Path": "/Holiday/Content/StringTables/GAME/STT_System_Location.uasset"`)
		- (Switch: `"Path": "/XXX.uasset"` > `"Path": "/Holiday/Content/StringTables/GAME/XXX.uasset"`)
			- (e.g., `"Path": "/Game/Content/StringTables/GAME/STT_System_Location.uasset"`)
3. `main.exe unpackAll [utocPath, ucasPath, outputDir, *AES key]`
	- (e.g., `main.exe unpackAll pakchunk30-WindowsNoEditor.utoc pakchunk30-WindowsNoEditor.ucas _`) > `_{ProjectName}\`
	- Unpacks entirety of .utoc/.ucas files
4. `main.exe pack [packDir, manifestPath, outputFile, compressionMethod, *AES key]`
	- (e.g., `main.exe pack "_{ProjectName}" manifest.json "pakchunk0-{Platform}_{ModName}_{ModVersion}_P" None`)
 	- Packs directory into `outputFile.(pak|ucas|utoc)` files
		- (e.g., `pakchunk0-Switch_English_Dialogue_v0.1.2_P.pak`)

> [!IMPORTANT]
> `{Platform}` = `WindowsNoEditor`, `Switch`
> 
> Put `_P` at end of `outputFile` to create patch paks ( `_P.(pak|ucas|utoc)` )
>
> If you get Error:<br>`open Engine: The system cannot find the file specified.`<br>ensure there's no `\` at end of `packDir`

> [!TIP]
> You can doublecheck the files' folder structures with `FModel`, to make sure they are packed correctly.

## Install The Patches `_P.(pak|ucas|utoc)`
Copy the newly created `pakchunk0-{Platform}_{ModName}_{ModVersion}_P.pak` to your preferred platform:

>[!IMPORTANT]
> ### Steam
> `"<SteamDir>/steamapps/common/DRAGON QUEST X OFFLINE/Game/Content/Paks/pakchunk0-WindowsNoEditor_{ModName}_{ModVersion}_P.(pak|ucas|utoc)"`
>
> ### Switch
> `sd:/atmosphere/contents/0100E2E0152E4000/romfs/Holiday/Content/Paks/pakchunk0-Switch_{ModName}_{ModVersion}_P.(pak|ucas|utoc)`
>
> ### Yuzu
> `%YUZU_DIR%/load/0100E2E0152E4000/<YOUR_MOD_NAME>/romfs/Holiday/Content/Paks/pakchunk0-Switch_{ModName}_{ModVersion}_P.(pak|ucas|utoc)`

---
<details><summary><h1>Translate via Game.locmeta/Game.locres files</h1></summary>

## 0.Prerequisites
  - [DRAGON QUEST X OFFLINE (or Demo) from Steam](https://store.steampowered.com/app/1358750/XOFFLINE/)
  - FModel.exe from [4sval's github repo](https://github.com/4sval/FModel)
    - DRAGON QUEST X OFFLINE (or Demo)'s [Mappings.usmap](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)
    - DRAGON QUEST X OFFLINE (or Demo)'s AES Key
  - LocRes-Builder-v0.1.2.exe from  [matyalatte's github repo](https://github.com/matyalatte/LocRes-Builder)
  - UnrealPak.exe (4.27.2 used in this tutorial) from [Epic Games' Unreal Engine](https://www.unrealengine.com/en-US/download)

> [!NOTE]
> Check the commit history if it is missing

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

## 2.LocRes-Builder-v0.1.2.exe
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

---

# Glossary
- ***`.ucas`*** is a Content Addressable Store, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to contain all the assets.
- ***`.utoc`*** is a Table Of Contents, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to describe the ***.ucas*** file, including chunk size and offset, compression format, and whether the chunks are encrypted.
- ***`.ufont`*** is a ***.ttf*** font file
- ***`global`*** file is an offline computed dependency graph for your assets.
- ***`.pak`*** When using this setup the file will store loose files such as fonts.
- The upside to using the io store is a noticeable improvement to loading times.
