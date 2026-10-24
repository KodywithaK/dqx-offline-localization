#!/usr/bin/env jq --arg LANGUAGE $LANGUAGE --from-file ./Game.locres.jq > "${{ github.workspace }}/BUILD/LocRes-Builder/INPUT/${LANGUAGE}.json"

. as $main_file
| reduce ( $main_file | keys_unsorted )[] as $namespace (
	{};
	.[$namespace] += (
		reduce ( $main_file[$namespace] | keys_unsorted )[] as $key (
			{};
			.[$key] += (
				if   ( $LANGUAGE != "la" )
				then (
					if   ( $main_file[$namespace][$key][$LANGUAGE] != "" )
					then ( $main_file[$namespace][$key][$LANGUAGE] )
					else ( $main_file[$namespace][$key]["ja"] )
					end
				)
				else ( $key | ascii_downcase )
				end
			)
		)
	)
)
