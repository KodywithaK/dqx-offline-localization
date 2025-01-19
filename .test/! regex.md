# `*.json`

## Add `comments` sections

- Find:
  - `(?<!,\n\s+?)(?="de")`
- Replace:
  - `"comments": "",\n    `

## Add to similar sections

### `Character Profile:`

- Input:

```json
"SYSTXT_TIPS_TITLE_MURAOUKURIHUGEEN": {
      "comments": "",
      "de": "",
      "en": "",
      "es": "",
      "fr": "",
      "it": "",
      "ja": "人物紹介：村王クリフゲーン",
      "ko": "인물 소개: 촌왕 클리프겐",
      "zh-Hans": "人物介绍：村王克里夫肯",
      "zh-Hant": "人物介紹：村王克里夫耿"
    }
```

- Find:
  - For "de" > `(?=(",\n.*?){5}"ja": "人物紹介：(.*)(?=",))`
  - For "en" > `(?=(",\n.*?){4}"ja": "人物紹介：(.*)(?=",))`
  - For "es" > `(?=(",\n.*?){3}"ja": "人物紹介：(.*)(?=",))`
  - For "fr" > `(?=(",\n.*?){2}"ja": "人物紹介：(.*)(?=",))`
  - For "it" > `(?=(",\n.*?){1}"ja": "人物紹介：(.*)(?=",))`
  - For all the above > `(?=(",\n.*?){1,4}\s+"ja": "人物紹介：(.*)(?=",))`

- Replace:
  - For "de" > `Profil: $2`
  - For "en" > `Profile: $2`
  - For "es" > `Perfil: $2`
  - For "fr" > `Profil: $2`
  - For "it" > `Profilo: $2`
  - For all the above > `: $2`

- Output:

```json
"SYSTXT_TIPS_TITLE_MURAOUKURIHUGEEN": {
      "comments": "",
      "de": "Profil: 村王クリフゲーン",
      "en": "Profile: 村王クリフゲーン",
      "es": "Perfil: 村王クリフゲーン",
      "fr": "Profil: 村王クリフゲーン",
      "it": "Profilo: 村王クリフゲーン",
      "ja": "人物紹介：村王クリフゲーン",
      "ko": "인물 소개: 촌왕 클리프겐",
      "zh-Hans": "人物介绍：村王克里夫肯",
      "zh-Hant": "人物介紹：村王克里夫耿"
    }
```
