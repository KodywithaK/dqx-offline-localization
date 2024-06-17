<details><summary><h1>Translate Game.locmeta/Game.locres files via LocRes-Builder</h1></summary>

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

# Glossary
- ***`.ucas`*** is a Content Addressable Store, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to contain all the assets.
- ***`.utoc`*** is a Table Of Contents, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to describe the ***.ucas*** file, including chunk size and offset, compression format, and whether the chunks are encrypted.
- ***`.ufont`*** is a ***.ttf*** font file
- ***`global`*** file is an offline computed dependency graph for your assets.
- ***`.pak`*** When using this setup the file will store loose files such as fonts.
- The upside to using the io store is a noticeable improvement to loading times.
