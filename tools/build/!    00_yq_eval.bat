wt ^
--tabColor "#008100" ^
--title "yq eval --exit-status" ^
-d "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\Localization\Game" ^
cmd /k "echo cls ^&^& yq eval --exit-status "Game.locres.yaml" -o json --yaml-fix-merge-anchor-to-spec"; ^
split-pane -V ^
--tabColor "#008100" ^
--title "yq eval --exit-status" ^
-d "D:\Coding\github.com\repo\KodywithaK\dqx-offline-localization\tree\main\src\pakchunk0-PLATFORM.pak\Holiday\Content\NonAssets\ETP" ^
cmd /k "echo cls ^&^& yq eval --exit-status "ETP.yaml" -o json --yaml-fix-merge-anchor-to-spec"
