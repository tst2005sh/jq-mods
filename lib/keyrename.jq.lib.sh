
#jq_function_keyrename='def keyrename($from;$to): .+([{"key": $to, "value": .[$from]}]|from_entries)|del(.[$from]);'
#jq_function_keyrename='def keyrename($from;$to): to_entries|map(.key |= if .==$from then ($to) else . end)|from_entries;'
jq_function_keyrename='def keyrename($from;$to): with_entries(.key |= if .==$from then ($to) else . end);'
#deps:none
