# 20250513_1640:
  ## `Game.locres.json:STT_IraisyoArasuji.EVTXT_SYS_QUESTA_IRAISYO_ARASUJI_11_BASE`
  - [x] test {NumCats}|plural(one=cat,other=cats) / `{MonsterNum}|plural(one={MonsterName},other={MonsterName}s)` usability
    - No intended text replacement occurred.
# 20250514_1540:
  ## `Game.locres.json:STT_IraisyoArasuji.EVTXT_SYS_QUESTA_IRAISYO_ARASUJI_11_BASE`
  - https://unreal-garden.com/tutorials/localization-advanced-plurals/
  - https://cldr.unicode.org/index/cldr-spec/plural-rules
    - https://www.unicode.org/cldr/charts/47/supplemental/language_plural_rules.html
  - [x] test {NumCats}|plural(one=cat,other=cats) / `{MonsterNum}|{MonsterNum}(one={MonsterName},other={MonsterName}s)` usability
# 20250515_0015:
  - REGEX
    - CLDR plurals (Dragon Quest 5 `.\data\MENULIST\b1000000.mpt`)
      - find `"?(@[0-9])(.*?)(?=@)|@"`
      - replace `\n\t\t\t\t"$1": "$2",`
    - Latin extended
      - find `(?<="value": ")([A-Œ])([A-Œ]+)(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?(([ -]([cdlCDL]'|[adl][eilu]{1,}[sx]? |[àacdinps][ aegilonru]{0,}[ ']){0,})?)?([A-Œ])?([A-Œ]+)?`
        - `œ` breaks the regex?
      - replace `\U$1\L$2$4\U$6\L$7$9\U$11\L$12$14\U$16\L$17$19\U$21\L$22`
<!--
- 20250620: new font 
  - fontworks' 筑紫明朝 TsukuMin
    - https://lets.fontworks.co.jp/fonts/13
      - FTT-筑紫明朝 H
        - horizontal scale: 90%
    - https://lets.fontworks.co.jp/services/apps-games
      - フォントワークス LETS license 
        - ¥49,500／1ライセンス／年
      - アプリ・ゲーム組込
        - ¥11,000／1ライセンス
-->
# 20250630_1800:
  - ETP.yaml
    - find `  ja: \|-\n    (<center>)?『風の民　エルフ』\n    \1?自然を愛し　森と共に生きる\n    \1?背に小さな羽を持った　かれんな姿の者たち。\n    \1?<br>\n    \1?伝統と格式を重んじる彼らは\n    \1?世界の理を　深く学び\n    \1?多くの優れた呪文の使い手を　世に送りだした。\n`
      - (08/12) has all languages
      - anchor `&Common_5Tribes_{RACE}` and alias `*Common_5Tribes_{RACE}`
        - `<center>"People of {THING}, {RACE}"`
    - find `[\w\d\s,']{60,}(?!\\n(<br>\\n)?)`
      - newline & `<br>` anything that is too long
    - find `  ja: |-\n    <pc>は\n    岩に　刻まれている文字を　読んだ。`
      - anchor `&Common_examine_engraving` and alias `*Common_examine_engraving`
    - find `この世界で　平和に　暮らしていた`
      - anchor `&Common_examine_engraving_Reidametes` and alias `*Common_examine_engraving_Reidametes`

---

# pakchunk0-{PLATFORM}_{LANGUAGE}_Dialogue_Latest_P

  ## pakchunk0-{PLATFORM}.(pak|ucas|utoc)
  - `{PLATFORM}/**/L10N` (Localization)
    - UI graphics for blacksmithing, casino, fishing, lottery, etc.

  ## pakchunk0-Android_ETC2.(pak|ucas|utoc)
  - modify `(localmanifest|cachedbuildmanifest).txt` to load patch?

  ## pakchunk0-ios.(pak|ucas|utoc)
  - modify `(localmanifest|cachedbuildmanifest).txt` to load patch?

  ## pakchunk0-ps4.(pak|ucas|utoc)
  - create workflow for auto creating patch: `pakchunk0-ps4_{LANGUAGE}_Dialogue_Latest_P.pkg`
    - @ pearlxcore/PS4-PKG-Tool?
    - @ hippie68/ps4-pkg-manager?
  <!--
  ## ps5?
  - tbd
  -->
  ## pakchunk0-Switch.(pak|ucas|utoc)
  - `Game.locmeta` main language: dummy?
    - Changes priority level so that `{LANGUAGE}/Game.locres` is prefered over `StringTables`
      - Will make packaging & deploying for og version WAY easier
  - `Game.locres` v2 packager

  ## pakchunk0-WindowsNoEditor.(pak|ucas|utoc)
  - TBD

---

# LANGUAGE
 ## de
   #### Modal particles
   - e.g., "Listen`—this time—`to me", "Listen to me `this time`!"
     - "Hör `mal` zu!"
 ## es
   #### Double object pronouns
   - me, te, (la/lo/le|se), nos, vos, (las/los/les|se)
   - Only after infinitive/gerund verb forms
   - Double object pronouns always get diacritics on the first inflected vowel, whereas with singles it depends on the word
     - e.g, "Juan is going to buy a ring for her" > "Juan is going to buy her a ring" > "Juan is going to buy her it"
       - "Juan va a comprar un anillo a ella" > "Juan va a comprarla un anillo" > "Juan va a compr`á`rselo"
     - e.g., "They are explaining the rules to you" > "They are explaining you the rules" > "They are explaining you them"
       -  "Ellos están explicando las reglas a ti" > "Ellos están explic`á`ndote las reglas" > "Ellos están explic`á`ndotelas"
     - "You can't `Le` `lo`" aka Le la/lo/las/los > `Se` la/lo/las/los
       - e.g., "Antonio loaned his phone to him/her/you (formal)" > "(Antonio )loaned him/her/you (formal) his phone" > "(Antonio )loaned him/her/you (formal) it"
         - "Antonio prestó su teléfono a ello/ella/usted" > "`Le` prestó su teléfono" > "`Se` `lo` prestó"
 ## it
   #### Double / contracted pronouns
   - Stressed (Tonic) Pronouns
     - me, te, lui/lei, noi, voi, loro
   - Unstressed (Atonic) Pronouns
     | LANGUAGE |1st, singular|2nd, singular|3rd, singular|1st, plural|2nd, plural|3rd, plural|
     | :-- |:--|:--|:--|:--|:--|:--|
     | en |1st, singular|2nd, singular|3rd, singular|1st, plural|2nd, plural|3rd, plural|
     | it |1st, singular|2nd, singular|3rd, singular|1st, plural|2nd, plural|3rd, plural|
     - mi, ti, lo/la, ci, vi, li/le
   #### Clitic Pronouns
   - Proclitic
     - Negative + Stressed (Tonic) Pronouns (indirect object) + Unstressed (Atonic) Pronouns (direct object) + full verb
       - `Non te la prendere`
   - Enclitic
     - Negative + verb (apocopic) + Stressed (Tonic) Pronouns (indirect object) + Unstressed (Atonic) Pronouns (direct object)
       - "Don't (you) take offense (with him)"
       - Non prender~~e~~ + te + la (offesa) (con lui).
       - `Non prendersela`
 ## pt-BR
   #### Clitic Pronouns
   - Proclitic
     - pt-BR, spoken/written for everything
       - e.g., "I `(will/am going to)` give you"
         - "Eu vou te dar." > "Vou te dar."
   - Mesoclitic
     - pt-EU, \*rare\* formal, written for simple future indicative or conditional statements
       - e.g., "I `am going to give` you (this)" / `If I give` you (this)"
         - "Eu te darei."		> "Te`¹` darei."	> "Dar`-te-`ei."
           - `¹` Grammar conflict
       - for \*noble\* characters: Raguas, Gartlant paladins, etc.
     - [yomitan | Improve word lookup](https://github.com/yomidevs/yomitan/pull/2066/files)
     - [yomitan/**/ext/data/recommended-settings.json](https://github.com/thrzl/yomitan/blob/0a85785984baa1528eda52308f1f1d4c295dc384/ext/data/recommended-settings.json)
       - find: `(-?(([mst][aeo])|(lh?[aeo]s?)|([nv]os?))-){1,2}`
         - see [Priberam Dictionario](https://dicionario.priberam.org/dar-no-lo-ia)
   - Enclitic
     - pt-EU, spoken/written for everything
       - e.g., "I `(will/am going to)` give you"
         - "Eu vou te dar" > "Vou dar-te"
