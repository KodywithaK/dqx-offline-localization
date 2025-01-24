# 00. Root Android Phone

# 01. Android Debug Platform

## Find `.apk`

- path matches Google Play url

```cmd
adb shell pm path com.square_enix.android_googleplay.dq10offline
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
