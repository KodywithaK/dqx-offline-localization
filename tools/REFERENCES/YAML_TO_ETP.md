# YAML_TO_ETP

## 01. ETP\\`*.json` > ETP_new\\`*.json`

- Prepend "filename": "`filename`" to each file, for step 03

```ps
Get-ChildItem -Path "pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP" -File | ForEach-Object {`
  jq -n --arg filename "$($_.Name)" "input | {`"filename`": `$filename} + ."`
  "pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP\$($_.Name)"`
  > "pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP_new\$($_.Name)"
}
```

## 02. ETP_new\\`*.json` > `ETP.yaml`

- Append `---` to each file section, for step 03

```ps
Get-ChildItem -Path "pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP" -File | ForEach-Object {`
  yq -p json -o yaml ".,`"---`""`
  "pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP_new\$($_.Name)"`
  >> "pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP.yaml"
}
```

- Edit the single `ETP.yaml` file, instead 783 individual ETP\\`*.json` files

## 03. `ETP.yaml` > ETP\\`*.json`

- Splits into individual files every `---`
- Titles each file with "filename": "`filename`", then deletes it from the final file, for `dqx_dat_dump`'s `pack_etp--KwK_20250626.py -L ${lang}`

```ps
yq -s ".filename, del(.filename)" `
"pakchunk0-{PLATFORM}.pak\{Game|Holiday}\Content\NonAssets\ETP.yaml" `
-o json -I2
```

---
