// see https://docs.werwolv.net/pattern-language/

#pragma name .mpt
#pragma author KodywithaK
#pragma description Dragon Quest 04 ( nds & mobile)\nDragon Quest 05 ( nds & mobile)\nDragon Quest 06 (mobile)\n./data/MESS*/{$LANGUAGE}/*.mpt
#pragma magic [ 4D 50 54 ] @ 0x00

////////////////////////////////////////// Import Modules //////////////////////////////////////////

// import hex.provider; // [^1] Unsupported by commandline, "error: This library is only available in the ImHex Hex editor"
import std.core;
import std.string;
import type.base;

///////////////////////////////////////////// Function /////////////////////////////////////////////

fn format_utf8_string(ref auto string)
{
	// - USAGE: char String[StringLength] [[format("format_utf8_string")]];
	//	 string = std::string::replace(string, "\x00", ""); // null-terminated string
	string = std::string::replace(string, "\x20\x3B", " ");
	return string;
};

fn get_parent_folder()
{
	str parent_folder = (
		std::string::substr(
			hex::prv::get_information("file_path"),
			std::string::length( hex::prv::get_information("file_path") ) - 15,
			2
		)
	);
	return parent_folder;
};

//////////////////////////////////////////// Structures ////////////////////////////////////////////

struct Header {
	char file_extension[3];
	type::Hex<u8> file_version;
	type::Hex<u32> file_size;
	u32 key_0;// key₀ == first
	u32 key_n;// keyₙ == last
	u32 numberOfStrings;
	type::Hex<u32> header_start_address;
	type::Hex<u32> header_size;
	type::Hex<u32> stringTable_size;
};

struct Keys {
	type::Hex<u16> index;
	type::Hex<u16> stringLength;
	type::Hex<u16> idk_yet;
	if ( std::core::array_index() + 1 == parent.header.numberOfStrings ) {
		padding[while($[$]==0xFE)]; // 4-byte alignment
	}
} [[ single_color ]];

struct Values {
	// char object[parent.keys[std::core::array_index()].stringLength] [[ format("format_utf8_string"), name( parent.parent.keys[std::core::array_index()].index ) ]];
	// [^1] try {
	// [^1] 	// Unsupported by commandline, "error: This library is only available in the ImHex Hex editor"
	// [^1] 	char string[parent.keys[std::core::array_index()].stringLength] [[ format("format_utf8_string"), name( get_parent_folder() ) ]];
	// [^1] } catch {
		// Supported by commandline, but ImHex's try-catch is slow to switch over ( try -> ~1 second per file VS. catch -> ~10 seconds per file )
		str LANGUAGE = "en";
		char string[parent.keys[std::core::array_index()].stringLength] [[ format("format_utf8_string"), name( LANGUAGE ) ]];
	// [^1] }
	padding[while($[$]==0xFE)]; // 4-byte alignment
};

struct MPT<Header, Keys, Values> {
	Header header;
	Keys keys[header.numberOfStrings];
	Values values[header.numberOfStrings];
};

/////////////////////////////////////////// Pattern Data ///////////////////////////////////////////

MPT<Header, Keys, Values> mpt @ $;

/////////////////////////////////////////////// Note ///////////////////////////////////////////////

/*

FOOTNOTES:

[^1]: Unsupported by commandline, "error: This library is only available in the ImHex Hex editor". ImHex's try-catch is slow to switch over ( try -> ~1 second per file VS. catch -> ~10 seconds per file )

USAGE:

// DQ04

```cmd
"%ProgramFiles%\ImHex\imhex-gui.exe" --open "<NTR-YIVx-xxx_directory>\data\MESS\LANGUAGE\b#######.mpt" --pattern "DQ04\tools\ImHex\imHex-DQ04-06.hexpat"
```
- export as "<output_directory>\b#######.mpt.json" ( |-> )

OR

```bat
FOR %%F IN (b0000000 ...) DO (
	FOR %%L IN (de en es fr it ja) DO (
		(IF NOT EXIST "%L" (MKDIR "%L")) ^
		& "%ProgramFiles%\ImHex\imhex.exe" ^
		--pl format ^
		--formatter json ^
		--input "<NTR-YIVx-xxx_directory>\data\MESS\%%L\%%F.mpt" ^
		--output "<output_directory>\%%L\%%F.mpt.json" ^
		--pattern "DQ04\tools\ImHex\imHex-DQ04-06.hexpat"
	)
)
```

// DQ05

```cmd
"%ProgramFiles%\ImHex\imhex-gui.exe" --open "<NTR-YV5x-xxx_directory>\data\MESS5\LANGUAGE\b#######.mpt" --pattern "DQ05\tools\ImHex\imHex-DQ04-06.hexpat"
```
- export as "<output_directory>\b#######.mpt.json" ( |-> )

OR

```bat
FOR %%F IN (b0000000 ...) DO (
	FOR %%L IN (de en es fr it ja) DO (
		(IF NOT EXIST "%L" (MKDIR "%L")) ^
		& "%ProgramFiles%\ImHex\imhex.exe" ^
		--pl format ^
		--formatter json ^
		--input "<NTR-YV5x-xxx_directory>\data\MESS5\%%L\%%F.mpt" ^
		--output "<output_directory>\%%L\%%F.mpt.json" ^
		--pattern "DQ05\tools\ImHex\imHex-DQ04-06.hexpat"
	)
)
```

// DQ06

```cmd
"%ProgramFiles%\ImHex\imhex-gui.exe" --open "<NTR-YVIx-xxx_directory>\DQ6.app\Data\Raw\msg\LANGUAGE\b#######.mpt" --pattern "DQ06\tools\ImHex\imHex-DQ04-06.hexpat"
```
- export as "<output_directory>\b#######.mpt.json" ( |-> )

OR

```bat
FOR %%F IN (b0000000 ...) DO (
	FOR %%L IN (en ja ko sl tl) DO (
		(IF NOT EXIST "%L" (MKDIR "%L")) ^
		& "%ProgramFiles%\ImHex\imhex.exe" ^
		--pl format ^
		--formatter json ^
		--input "<NTR-YVIx-xxx_directory>\DQ6.app\Data\Raw\msg\%%L\%%F.mpt" ^
		--output "<output_directory>\%%L\%%F.mpt.json" ^
		--pattern "DQ06\tools\ImHex\imHex-DQ04-06.hexpat"
	)
)
```

*/
