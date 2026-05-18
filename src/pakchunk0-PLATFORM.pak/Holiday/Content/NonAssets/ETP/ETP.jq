#!/usr/bin/env jq -f

. as $obj
| reduce ( $obj | keys_unsorted )[] as $file (
	{};
	.[$file] += (
		reduce ( $obj[$file] | keys_unsorted )[] as $namespace (
			{};
			.[$namespace] += (
				reduce ( $obj[$file][$namespace] | keys_unsorted )[] as $key (
					{};
					#.[$key] += ( $obj[$file][$namespace][$key] )
					if ( $key == "$comments" )
					then .[$key] += ( $obj[$file][$namespace][$key] )
					elif ( $key | test("de|en|es|fr|it|ja|ko|pt-BR|zh-Hans|zh-Hant") )
					then .[$key] += (
						if $obj[$file][$namespace][$key] != ""
						then $obj[$file][$namespace]["$voice_I"] + $obj[$file][$namespace][$key] + $obj[$file][$namespace]["$voice_O"]
						#else $obj[$file][$namespace]["$voice_I"] + $obj[$file][$namespace]["ja"] + $obj[$file][$namespace]["$voice_O"]
						else ""
						end
					)
					else .
					end
				)
			)
		)
	)
)
