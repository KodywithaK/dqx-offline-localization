# Unreal Editor 4.27.2

## Unreal Project Browser

- `Blank Project`
  - `Blank`
    - `Choose whether to create a Blueprint or C++ project` > `C++`
      - `MyProject` = `Holiday`

### `{ PROJECT_DIR }/Holiday/Config/DefaultPakFileRules.ini`

> - Create or modify `DefaultPakFileRules.ini` with the following lines:
>   - Excludes bloat/game-crashing files
> 
> ```ini
> [bExcludeFromPaks_Engine]
> bExcludeFromPaks=true
> bOverrideChunkManifest=true
> +Files=".../*.upluginmanifest"
> +Files=".../*.uproject"
> +Files=".../AssetRegistry.bin"
> +Files=".../Config/..."
> +Files=".../Content/NewDataAsset.uasset"
> +Files=".../Content/Shader*"
> +Files=".../Engine/..."
> +Files=".../Platforms/..."
> +Files=".../Plugins/JsonAsAsset/JsonAsAsset.uplugin"
> ```

### Content Browser

#### C++ Classes/Holiday

> - https://dev.epicgames.com/documentation/en-us/unreal-engine/unreal-engine-4-27-documentation?application_version=4.27
> - https://dev.epicgames.com/documentation/en-us/unreal-engine/BlueprintAPI?application_version=4.27
> - `#include {dependency}` = `{ UE4Editor Directory }\Engine\Source\Runtime\`
>
> - Right-click > `New C++ Class` > 
>   - `None` > `Next`
>     - `Name` > `HOLITextRubyData_TableRow` > `Create Class`
>       - `Header File` & `Source File` will autofill based off name ( and path )
>
> - UE4Editor will compile the `New C++ Class` and open up your designated code editor ( Visual Studio, atom, etc. )
> - `HOLITextRubyData_TableRow.h`
>   - Tells UE4Editor what exists
> - `HOLITextRubyData_TableRow.cpp`
>   - Tells UE4Editor how it works
>