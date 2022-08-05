def glob_to_re:
	[capture("(?<a>[^\\\\]*)(?<q>\\\\[*?])?";"g")] | map(to_entries[])
	| map(if .value==null or .value=="" then empty else . end)
	| map(if .key=="a" then .value|=(split("*")|map( split("?")|map(re_quote)|join(".") )|join(".*")) else . end)
	| map(.value)|join("")
;
