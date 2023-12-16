# Prerequisites
- [Python 3.11](https://www.python.org/downloads/release/python-3110/)
- [dqx-translation-project/dqx_dat_dump](https://github.com/dqx-translation-project/dqx_dat_dump)
- ドラゴンクエストX　目覚めし五つの種族　オフライン
  - [Dragon Quest X Online - Windows (free) Version](https://hiroba.dqx.jp/sc/public/playguide/wintrial_1/)
  - [Dragon Quest X Offline - Nintendo eShop](https://store-jp.nintendo.com/list/software/70010000042357.html)<br>(Title ID `0100E2E0152E4000`)
  - Dragon Quest X Offline's AES Key

- [Unreal Engine](https://www.unrealengine.com/en-US/download) (v5.1 used in this tutorial)
- [FModel (Unreal Engine Archives Explorer/Exporter)](https://github.com/4sval/FModel)
  - ***Unreal Mappings Archive*** to use as FModel's [Local Mapping File](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)

# Tutorial - pakchunk0-Switch.pak - ETP
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
UnrealPak.exe <Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\pakchunk0-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak -Create=<Working_Directory>\dqx-translation-project\dqx_dat_dump\tools\packing\responsefile.txt
```
to create a patch `_P.pak` with all your modified `.etp` files

### 8. Install the patch `_P.pak`
Copy the newly created `pakchunk0-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak` to your preferred platform:

>[!IMPORTANT]
> ### Switch
> `sd:/atmosphere/contents/0100E2E0152E4000/romfs/Holiday/Content/Paks/pakchunk0-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak`

> [!IMPORTANT]
> ### Yuzu
> `%YUZU_DIR%/load/0100E2E0152E4000/<YOUR_MOD_NAME>/romfs/Holiday/Content/Paks/pakchunk0-Switch_<YOUR_MOD_NAME>_<YOUR_MOD_VERSION>_P.pak`

### 9. Start the game to play with your modified text, congratulations!

*****
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
*****
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
*****

# Glossary
- ***`.ucas`*** is a Content Addressable Store, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to contain all the assets.
- ***`.utoc`*** is a Table Of Contents, used by [Zen Loader](https://docs.unrealengine.com/5.2/en-US/zen-loader-in-unreal-engine/) to describe the ***.ucas*** file, including chunk size and offset, compression format, and whether the chunks are encrypted.
- ***`.ufont`*** is a ***.ttf*** font file
- ***`global`*** file is an offline computed dependency graph for your assets.
- ***`.pak`*** When using this setup the file will store loose files such as fonts.
- The upside to using the io store is a noticeable improvement to loading times.
