# dqx-offline-localization

## Prerequisites
- ***romfs*** dump of [**ドラゴンクエストX　目覚めし五つの種族　オフライン**](https://store-jp.nintendo.com/list/software/70010000042357.html)<br>(Title ID `0100E2E0152E4000`)
- [FModel (Unreal Engine Archives Explorer)](https://github.com/4sval/FModel)
- ***Unreal Mappings Archive*** to use as FModel's [Local Mapping File](https://github.com/OutTheShade/Unreal-Mappings-Archive/blob/main/Dragon%20Quest%20X%20Offline/Demo/Mappings.usmap)

## Tutorial
- ### FModel
    - **`Settings`** > **`General`**
        - **`Output Directory`**<br>
            - Location where you want `Export Folder's Packages Raw Data (.uasset)` to go; explained further ahead.
        - **`Game's Archive Directory`**<br>
            - Location where your `romfs` folder is.
        - `Local Mapping File`: **Enabled**
        - `Mapping File Path`:<br>Location where your Unreal Mappings Archive (`Mappings.usmap`) is.
    - **`Archives`** tab
        - Double-click `pakchunk0-Switch.pak` to open it
    - **`Folders`** tab
        - Right-click `Holiday` and choose `Export Folder's Packages Raw Data (.uasset)`.<br><br>After some time, the files will be exported to "`<Output Directory>\Exports`".
- ### Powershell (run as admin)
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
- ### UE4localizationsTool
    - 

## Glossary
- ***`.ucas`*** is a Content Addressable Store, it holds all of your cooked assets.
- ***`.utoc`*** is a Table Of Contents that is used by the engine to quickly find an asset in the .ucas file.
- ***`.ufont`*** is a ***.ttf*** font file
- ***`global`*** file is an offline computed dependency graph for your assets.
- ***`.pak`*** When using this setup the file will store loose files such as fonts.
- The upside to using the io store is a noticeable improvement to loading times.