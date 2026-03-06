input[] as $old
| input[] as $new
| reduce ( $old.StringTable.KeysToEntries | keys_unsorted )[] as $k (
	$old;
	if ( .StringTable.KeysToEntries.[$k] != "" )
	then ( .StringTable.KeysToEntries.[$k] |= $new.StringTable.KeysToEntries[$k] )
	else ( del( .StringTable.KeysToEntries.[$k] ) )
	end
)
| [.]