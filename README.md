# dqx-offline-localization

## Prerequisites
- ***romfs*** dump of [**ドラゴンクエストX　目覚めし五つの種族　オフライン**](https://store-jp.nintendo.com/list/software/70010000042357.html) (Title ID `0100E2E0152E4000`)
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
        - Right-click `Holiday` and choose `Export Folder's Packages Raw Data (.uasset)`.<br><br>After some time, the files will be exported to `<Output Directory>\Exports`