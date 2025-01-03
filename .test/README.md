# pack_etp--KwK.py
- new argument added: `python pack_etp--KwK.py -L <language>`
  - Where `<language>` matches one from the new format (de, en, es, fr, it, ja, ko, zh-hans, zh-hant)
  - e.g.:
    - `python pack_etp--KwK.py -L en`, outputs english translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP\_en**
    - `python pack_etp--KwK.py -L es`, outputs spanish translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP\_es**
    - `python pack_etp--KwK.py -L ja`, outputs japanese translations to `dqx_dat_dump/tools/packing/new_etp/`**ETP\_ja**
    - etc.
  - Like the original `pack_etp.py`, it defaults to japanese, whenever translations are missing for a specific language.