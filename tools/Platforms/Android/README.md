# 00. Root Android Phone

# 01. Android Debug Platform

## Find `.apk`

- path matches Google Play url

```cmd
adb shell "su -c 'pm path com.square_enix.android_googleplay.dq10offline'"
```

## Elevate to superuser

```cmd
adb shell
su
```

## Extract `.apk`

- Copy to `internal storage/Download`
  - `cp SOURCE DESTINATION`

- Base

```cmd
cp ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/base.apk ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/
cp ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/split_config.arm64_v8a.apk ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/
cp ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/split_config.en.apk ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/
cp ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/split_config.ja.apk ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/
cp ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/split_config.xxhdpi.apk ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/
cp ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/split_obbassets.apk ~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/
```

- Base with update

```cmd
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/CachedBuildManifest.txt ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/LocalManifest.txt ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk2-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk3-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk4-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk5-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk6-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk7-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
```

- Super Large Expansion DLC

```cmd
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/CachedBuildManifest.txt ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/LocalManifest.txt ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk11-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk12-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
cp ~/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/pakchunk13-Android_ETC2.pak ~/storage/emulated/0/Download/storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/
```

# 03. Localization Assets

- `~/data/app/~~oHKdFqhqViYkQlvOjDIGaQ==/com.square_enix.android_googleplay.dq10offline-VGGK_8WmESJT1yG9y4re6Q==/split_obbassets.apk/assets/main.obb.png/Holiday/Content/Paks/pakchunk0-Android_ETC2.pak/Holiday/Content/Localization/Game/`
  - `Game.locmeta`
  - `/<LANGUAGE>/Game.locres`

---

# TEST

- `https://prd.offline.dqx.jp/HolidayCDN/HolidayKey/{APP_VER}/BuildManifest-{PLATFORM}.txt?ver={UTC}`
- https://prd.offline.dqx.jp/HolidayCDN/HolidayKey/1.0.0/BuildManifest-Android.txt
- https://prd.offline.dqx.jp/HolidayCDN/HolidayKey/1.0.0/BuildManifest-IOS.txt

<!--
```cmd
cls && adb shell "su -c ''"
```
-->

## Base Game Location

```cmd
cls && adb shell "su -c 'ls -R /mnt/pass_through/0/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/'"
```

## DLC/Update Location
```cmd
cls && adb shell "su -c 'ls -R /mnt/pass_through/0/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache'"
```

### Problem

<details>

> Just before the title screen, the game sends a GET request to 
> `https://prd.offline.dqx.jp/HolidayCDN/HolidayKey/1.1.1/BuildManifest-Android.txt`, which contains:
> ```txt
> $NUM_ENTRIES = 9 
> $BUILD_ID = HolidayKey
> pakchunk2-Android_ETC2.pak    1424691663    v682    2    /Android_ETC2/pakchunk2-Android_ETC2.pak
> pakchunk3-Android_ETC2.pak    1485849057    v682    3    /Android_ETC2/pakchunk3-Android_ETC2.pak
> pakchunk4-Android_ETC2.pak    1134432174    v682    4    /Android_ETC2/pakchunk4-Android_ETC2.pak
> pakchunk5-Android_ETC2.pak    1501038951    v682    5    /Android_ETC2/pakchunk5-Android_ETC2.pak
> pakchunk6-Android_ETC2.pak    1358313090    v682    6    /Android_ETC2/pakchunk6-Android_ETC2.pak
> pakchunk7-Android_ETC2.pak    1267608774    v682    7    /Android_ETC2/pakchunk7-Android_ETC2.pak
> pakchunk11-Android_ETC2.pak    1822031753    v682    11    /Android_ETC2/pakchunk11-Android_ETC2.pak
> pakchunk12-Android_ETC2.pak    1554125613    v682    12    /Android_ETC2/pakchunk12-Android_ETC2.pak
> pakchunk13-Android_ETC2.pak    1340775223    v682    13    /Android_ETC2/pakchunk13-Android_ETC2.pak
> ```
> aka the `CachedBuildManifest.txt` file
> - then `CachedBuildManifest.txt` & `LocalManifest.txt` are overwritten to their defaults
> - Unexpected files (e.g., `pakchunk0-Android_ETC2_{LANGUAGE}_Dialogue_Latest_P.pak` ) are renamed to not interfere with files
> 
> The GET request goes to the same URL listed in
> `/data/app/*/com.square_enix.android_googleplay.dq10offline-*==/split_obbassets.apk/assets/main.obb.png/Holiday/Content/Paks/pakchunk0-Android_ETC2.pak/Holiday/Config/DefaultGame.ini`
> ```ini
> [/Script/Plugins.ChunkDownloader HolidayLive]
> +CdnBaseUrls="https://prd.offline.dqx.jp/HolidayCDN/HolidayKey"
> DispDownload=True
> DispFileDelete=True
> DispDLCDownload=True
> PartialDownloadSizeGB=0.03
> RetryCnt=3
> NumDownloads=1
> DownloadLog=1
> FastChunkIds=1
> ChunkIds=2,3,4,5,6,7
> DLC2ndItemIdAndroid="com_square_enix_gp_dq10offline_dlc_001_afn"
> DLC2ndItemIdIOS="com_square_enix_dq10offline_dlc_001_afn"
> DLC2ndChunkIds=11,12,13
> ShuffleChunkId=True
> DebugPurchaceGet=False
> DebugPurchaseRestore=False
> DebugPurchaseBuy=False
> ```

</details>

### Solution?

<details>

> #### Apktool
> - Prerequisites
>   - Apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads
>   - Apktool.bat https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/windows/apktool.bat
> - Decode `/data/app/*/com.square_enix.android_googleplay.dq10offline-*==/split_obbassets.apk`
>   - `apktool decode --output "{OUTPUT_DIR}" "...\split_obbassets.apk"`
>   - `apktool decode --output "...\split_obbassets.apk.Apktool" "...\split_obbassets.apk"`
> - Modify `...\split_obbassets.apk.Apktool\assets\main.obb.png\Holiday\Content\Paks\` to pass verification & renaming/rewriting of modded files
>   - Add `pakchunk0-Android_ETC2_CdnBaseUrlsTest_P.pak`
>     - Containing: `../../../Holiday/Config/DefaultGame.ini`
>     ```ini
>     [/Script/Plugins.ChunkDownloader HolidayLive]
>     +CdnBaseUrls="http://localhost:3000/HolidayCDN/HolidayKey"
>     ```
> - Build `/data/app/*/com.square_enix.android_googleplay.dq10offline-*==/split_obbassets.apk`
>   - `apktool build --output "...\split_obbassets.apk" "{OUTPUT_DIR}"`
> 
> #### adb
> - Push new `split_obbassets.apk` to phone
>   - `adb push .../split_obbassets.apk /sdcard/Download/com.square_enix.android_googleplay.dq10offline/split_obbassets.apk`
> - Copy new `split_obbassets.apk` to `com.square_enix.android_googleplay.dq10offline`'s path
>   - Find filepaths
>     - `cls && adb shell "su -c 'pm path com.square_enix.android_googleplay.dq10offline'"`
>   - `adb shell "su -c 'cp /sdcard/Download/com.square_enix.android_googleplay.dq10offline/split_obbassets.apk /data/app/*/com.square_enix.android_googleplay.dq10offline-*==/'"`
>   - Verify `split_obbassets.apk` has been updated
>     - `adb shell "su -c 'ls -lR /data/app/*/com.square_enix.android_googleplay.dq10offline-*==/'"`
>     ```bash
>     /data/app/*/com.square_enix.android_googleplay.dq10offline-*==:
>     total 1756074
>     -rw-r----- 1 system system        143 2025-09-06 12:23 app.metadata
>     -rw-r--r-- 1 system system   13838421 2025-09-06 12:21 base.apk
>     -rw------- 1 system system         92 2025-09-06 12:23 base.digests
>     -rw-r--r-- 1 system system     115008 2025-09-06 12:21 base.dm
>     drwxr-xr-x 3 system system       3452 2025-09-06 12:23 lib
>     drwxr-x--x 3 system system       3452 2025-09-06 12:23 oat
>     -rw-r--r-- 1 system system  211161811 2025-09-06 12:22 split_config.arm64_v8a.apk
>     -rw-r--r-- 1 system system      29081 2025-09-06 12:21 split_config.en.apk
>     -rw-r--r-- 1 system system      16793 2025-09-06 12:21 split_config.ja.apk
>     -rw-r--r-- 1 system system      80779 2025-09-06 12:21 split_config.xxhdpi.apk
>     -rw-r--r-- 1 system system 1571176152 2025-09-24 18:37 split_obbassets.apk # Different filesize & date
>     ```
>
> - `cls && adb shell "su -c 'cp /sdcard/Download/com.square_enix.android_googleplay.dq10offline/copy/* storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/ && ls -lR storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/'"`
>   - CachedBuildManifest.txt
>   - LocalBuildManifest.txt
>   - pakchunk0-Android_ETC2_{LANGUAGE}_Dialogue_Latest_P.pak
>   ```bash
>   total 12639780
>   -rw------- 1 u0_a268 ext_data_rw        949 2025-09-24 23:28 CachedBuildManifest.txt # Different filesize & date
>   -rw-rw---- 1 root    ext_data_rw        569 2025-09-24 23:28 LocalBuildManifest.txt # Different filesize & date
>   -rw-rw---- 1 root    ext_data_rw   41512220 2025-09-24 23:28 pakchunk0-Android_ETC2_{LANGUAGE}_Dialogue_Latest_P.pak # Different filesize & date
>   -rw------- 1 u0_a268 ext_data_rw 1822031753 2025-09-08 17:19 pakchunk11-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1554125613 2025-09-08 17:21 pakchunk12-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1340775223 2025-09-08 17:23 pakchunk13-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1424691663 2025-09-08 16:34 pakchunk2-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1485849057 2025-09-08 16:36 pakchunk3-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1134432174 2025-09-08 16:38 pakchunk4-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1501038951 2025-09-08 16:40 pakchunk5-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1358313090 2025-09-08 16:41 pakchunk6-Android_ETC2.pak
>   -rw------- 1 u0_a268 ext_data_rw 1267608774 2025-09-08 16:43 pakchunk7-Android_ETC2.pak
>   ```
>
> - Combine `http://localhost:{PORT}` for PC and Smartphone
>   - `adb.exe reverse tcp:{PORT} tcp:{PORT}`
>   - `adb.exe reverse tcp:3000 tcp:3000`
>     - node.js
>       - `cls && node express-demo\index.js`
>
> #### Reqable
> - Prerequisites
> - `SSL Enabled`
> - `System Proxy Enabled`
> - `Rewrite Enabled`
>    |Name|URL|Action|
>    |:--|:--|:--|
>    |Redirect URL|https://prd.offline.dqx.jp/HolidayCDN/HolidayKey/\*|http://localhost:3000/HolidayCDN/HolidayKey/\*|
>
> <!-- - Modify `/data/app/*/com.square_enix.android_googleplay.dq10offline-*==/split_obbassets.apk/assets/main.obb.png/Holiday/Content/Paks/pakchunk0-Android_ETC2.pak/Holiday/Config/DefaultGame.ini` -->
> <!--   - To pass renaming/rewriting of modded files -->
>
> Redirect the GET request to
> ```ini
> [/Script/Plugins.ChunkDownloader HolidayLive]
> +CdnBaseUrls="http://localhost:3000/HolidayCDN/HolidayKey"
> ```
> OR
> ```ini
> [/Script/Plugins.ChunkDownloader HolidayLive]
> +CdnBaseUrls="https://{SOMEWHERE_ELSE}/HolidayCDN/HolidayKey"
> ```
> 
> - `adb shell "su -c 'cp /sdcard/Download/com.square_enix.android_googleplay.dq10offline/split_obbassets.apk /data/app/*/com.square_enix.android_googleplay.dq10offline-*==/split_obbassets.apk'"`
> 
> - `adb shell "su -c 'cp /sdcard/Download/com.square_enix.android_googleplay.dq10offline/CachedBuildManifest.txt storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/'"`
> 
> ```txt
> $NUM_ENTRIES = 10
> $BUILD_ID = HolidayKey
> pakchunk0-Android_ETC2_{LANGUAGE}_Dialogue_Latest_P.pak   {FILESIZE_IN_BYTES}      v682    0       /Android_ETC2/pakchunk0-Android_ETC2_{LANGUAGE}_Dialogue_Latest_P.pak
> pakchunk2-Android_ETC2.pak      1424691663      v682    2       /Android_ETC2/pakchunk2-Android_ETC2.pak
> pakchunk3-Android_ETC2.pak      1485849057      v682    3       /Android_ETC2/pakchunk3-Android_ETC2.pak
> pakchunk4-Android_ETC2.pak      1134432174      v682    4       /Android_ETC2/pakchunk4-Android_ETC2.pak
> pakchunk5-Android_ETC2.pak      1501038951      v682    5       /Android_ETC2/pakchunk5-Android_ETC2.pak
> pakchunk6-Android_ETC2.pak      1358313090      v682    6       /Android_ETC2/pakchunk6-Android_ETC2.pak
> pakchunk7-Android_ETC2.pak      1267608774      v682    7       /Android_ETC2/pakchunk7-Android_ETC2.pak
> pakchunk11-Android_ETC2.pak     1822031753      v682    11      /Android_ETC2/pakchunk11-Android_ETC2.pak
> pakchunk12-Android_ETC2.pak     1554125613      v682    12      /Android_ETC2/pakchunk12-Android_ETC2.pak
> pakchunk13-Android_ETC2.pak     1340775223      v682    13      /Android_ETC2/pakchunk13-Android_ETC2.pak
> ```
> 
> - `adb shell "su -c 'cp /sdcard/Download/com.square_enix.android_googleplay.dq10offline/LocalBuildManifest.txt storage/emulated/0/Android/data/com.square_enix.android_googleplay.dq10offline/files/PakCache/'"`
> 
> ```txt
> $NUM_ENTRIES = 10
> pakchunk0-Android_ETC2_{LANGUAGE}_Dialogue_Latest_P.pak   {FILESIZE_IN_BYTES}      v682    -1      /
> pakchunk2-Android_ETC2.pak      1424691663      v682    -1      /
> pakchunk3-Android_ETC2.pak      1485849057      v682    -1      /
> pakchunk4-Android_ETC2.pak      1134432174      v682    -1      /
> pakchunk5-Android_ETC2.pak      1501038951      v682    -1      /
> pakchunk6-Android_ETC2.pak      1358313090      v682    -1      /
> pakchunk7-Android_ETC2.pak      1267608774      v682    -1      /
> pakchunk11-Android_ETC2.pak     1822031753      v682    -1      /
> pakchunk12-Android_ETC2.pak     1554125613      v682    -1      /
> pakchunk13-Android_ETC2.pak     1340775223      v682    -1      /
> ```
> 

</details>

# IDEAS

<details>

> - Patch game via CDN verification
>   - Check `.cpp` files for `FChunkDownloader::GetChecked()`
>   - [Rafasloth - GitHub/YouTube Series](https://github.com/rafasloth/Chunks)
> 
> - Create response file of original `.../split_obbassets.apk/assets/main.obb.png/Holiday/Content/Paks/pakchunk0-Android_ETC2.pak`
>   - Takes hours
> ```cmd
> cls && FOR /F "usebackq delims=" %F IN (`dir /a-d /b /ogn /s`) DO @ECHO "%F" "../../../%F" >> "S:\Consoles\Google Android\ROMs\com.square_enix.android_googleplay.dq10offline\1.1.1\data\app\com.square_enix.android_googleplay.dq10offline-raJ9EQoF4SZnlRmJqMHmEg==\! KwK\responseFile_forloop.txt"
> ```

</details>
