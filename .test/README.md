# pack_etp--KwK.py
- new argument added: `python pack_etp--KwK.py -L <language>`
  - Where `<language>` matches one from the new format (de, en, es, fr, it, ja, ko, zh-Hans, zh-Hant)
  - e.g.:
    - `python pack_etp--KwK.py -L en`, outputs english translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP\_en**
    - `python pack_etp--KwK.py -L es`, outputs spanish translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP\_es**
    - `python pack_etp--KwK.py -L ja`, outputs japanese translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP\_ja**
    - etc.
  - Like the original `pack_etp.py`, it defaults to japanese, whenever translations are missing for a specific language.

# response_file--pakchunk0-WindowsNoEditor_EN_Latest.pak.txt
```bash
./UnrealEngine-4.27.2-release/Engine/Binaries/Linux/UnrealPak \
"../../../../actions-runner/_work/dqx-offline-localization/dqx-offline-localization/test/staging/pakchunk0-WindowsNoEditor_EN_Latest_P.pak" \
-Create="../../../../actions-runner/_work/dqx-offline-localization/dqx-offline-localization/test/staging/response_file--pakchunk0-WindowsNoEditor_EN_Latest.pak.txt"
```
- UnrealPak will exclude any mismatched directories, e.g.:
  - ```txt
    "source" "../../../destination"
    "Localization/Game/en" "../../../Localization/Game/ko"
    ```
    - ```bash
      LogPakFile: Display: Added 11 entries to add to pak file.
      LogPakFile: Display: Collecting files to add to pak file...
      LogPakFile: Display: Collected 10 files in 0.00s.
      ```
  - But renaming, source's foldername to match destination will properly create `.pak`
    - ```txt
      "source" "../../../destination"
      "Localization/Game/ko" "../../../Localization/Game/ko"
      which is actually ^^^ -> Localization/Game/en
      ```
      - ```bash
        LogPakFile: Display: Added 11 entries to add to pak file.
        LogPakFile: Display: Collecting files to add to pak file...
        LogPakFile: Display: Collected 11 files in 0.00s.
        ```