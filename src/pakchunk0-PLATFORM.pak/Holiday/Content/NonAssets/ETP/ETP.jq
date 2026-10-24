#!/usr/bin/env yq eval ./ETP.yaml -o json --yaml-fix-merge-anchor-to-spec | jq --from-file ./ETP.jq | yq ".[]" --split-exp-file ./ETP.yq -o json

. as $main_file
| reduce ( $main_file | keys_unsorted )[] as $sub_file (
	{};
	.[$sub_file] += (
		reduce ( $main_file[$sub_file] | keys_unsorted )[] as $namespace (
			{};
			.[$namespace] += (
				reduce ( $main_file[$sub_file][$namespace] | keys_unsorted )[] as $key (
					{};
					if   (
						$key == "$comments"
						or
						$key == "$conditional"
					)
					then (
						.[$key] += ( $main_file[$sub_file][$namespace][$key] )
					)
					elif (
						$key | test("de|en|es|fr|it|ja|ko|pt-BR|zh-Hans|zh-Hant")
					)
					then (
						.[$key] += (
							if   (
								$key != "$conditional"
								and
								$main_file[$sub_file][$namespace][$key] != ""
							)
							then (
								############## <if_{conditional}> S ##############
								if   (
									$main_file[$sub_file][$namespace]["$conditional"] != null
									and
									$main_file[$sub_file][$namespace]["$conditional"] != ""
									and
									( $main_file[$sub_file][$namespace][$key] | type ) == "array"
								)
								then (
									# $main_file[$sub_file][$namespace]["$præfixa"]
									$main_file[$sub_file][$namespace]["$voice_I"]
									+ $main_file[$sub_file][$namespace][$key][0]
									+ $main_file[$sub_file][$namespace]["$voice_O"]
									# + $main_file[$sub_file][$namespace]["$suffixa"]
									| $main_file[$sub_file][$namespace]["$conditional"]
									+ ( . | sub( "\\{\\$conditional\\}"; $main_file[$sub_file][$namespace][$key][1] ) )
									+ "<else>"
									+ ( . | sub( "\\{\\$conditional\\}"; $main_file[$sub_file][$namespace][$key][2] ) )
									+ "<endif>"
								)
								elif (
									$main_file[$sub_file][$namespace]["$conditional"] != null
									and
									$main_file[$sub_file][$namespace]["$conditional"] != ""
									and
									( $main_file[$sub_file][$namespace][$key] | type ) != "array"
								)
								then (
									$main_file[$sub_file][$namespace][$key]
								)
								############## <if_{conditional}> E ##############
								else (
									# $main_file[$sub_file][$namespace]["$præfixa"]
									$main_file[$sub_file][$namespace]["$voice_I"]
									+ $main_file[$sub_file][$namespace][$key]
									+ $main_file[$sub_file][$namespace]["$voice_O"]
									# + $main_file[$sub_file][$namespace]["$suffixa"]
								)
								end
							)
							else (
								""
							)
							end
						)
					)
					else (
						.
					)
					end
				)
			)
		)
	)
)
