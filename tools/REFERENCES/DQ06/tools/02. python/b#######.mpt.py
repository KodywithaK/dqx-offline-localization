# USAGE - FOR %F IN (b1000000) DO FOR %L IN (de en es fr it ja) DO jq --arg LANGUAGE es --from-file "{github_directory}\tools\REFERENCES\DQ04\tools\03. jq\b#######.python.mpt.jq" "{github_directory}\tools\REFERENCES\DQ04\tools\01. ImHex\%L\%F.mpt.temp.json" > "{github_directory}\tools\REFERENCES\DQ04\tools\01. ImHex\%L\%F.mpt.json" & py "R:\tools\REFERENCES\DQ04\tools\02. python\b#######.mpt.py" & py b#######.mpt.py %F.%L.mpt.json %F.%L_urlescape.mpt.json

import json
import urllib.parse
import re
import sys

if len(sys.argv) > 1:
	# Read *.json file
	with open(sys.argv[1],'r',encoding="utf-8") as file:
		# Read file
		raw_data = file.read() # print(f"raw_data =\n{raw_data}")
		# URL escape file
		urllib_parse_unquote = urllib.parse.unquote(raw_data) # print(f"urllib_parse_unquote =\n{urllib_parse_unquote}")
		# Load as json; "strict=False" to prevent "json.decoder.JSONDecodeError: Invalid control character at:" errors for newlines and tabs
		data = json.loads(urllib_parse_unquote, strict=False) # print(f"data =\n{data}")
	with open(sys.argv[2],'w',encoding="utf-8") as file:
		json.dump(data, file, indent="\t")
else:
	print(f"arguments not provided\nUSAGE:\nFOR %F IN (b1000000) DO FOR %L IN (de en es fr it ja) DO (IF NOT EXIST \"%L\" (MKDIR \"%L\")) & py b#######.mpt.py \"<github_directory>\\tools\\REFERENCES\\DQ04\\tools\\01. ImHex\\%L\\%F.mpt.json\" \"<github_directory>\\tools\\REFERENCES\\DQ04\\tools\\02. python\\%L\\%F.mpt.json\"")
