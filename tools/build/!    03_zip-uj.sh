#!/usr/bin/env bash

# wsl -e "/mnt/c/Users/Ryzen3/Desktop/pakchunk0-{PLATFORM}_LocResBuilder_P.pak/^!    03_zip-uj.sh"

for PLATFORM in ps4 Switch WindowsNoEditor; do \
  echo
  # echo ${PLATFORM}
  echo -e "\x1b[32m${PLATFORM}\x1b[00m"
  for LANGUAGE in de en es fr it pt-BR; do \
    # echo ${LANGUAGE}
    echo -e "    \x1b[35m${LANGUAGE}\x1b[00m"
    zip -ujv \
    ~/actions-runner/_work/dqx-offline-localization/dqx-offline-localization/BUILD/releases/pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest_P.pak.zip \
    /mnt/r/DEBUG/releases/pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest__RunUAT_P.pak \
    /mnt/r/DEBUG/releases/pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest__RunUAT_P.ucas \
    /mnt/r/DEBUG/releases/pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest__RunUAT_P.utoc \
    /mnt/r/DEBUG/releases/pakchunk0-${PLATFORM}_JAPAN_${LANGUAGE}_Dialogue_Latest_P.pak
  done;
done;
