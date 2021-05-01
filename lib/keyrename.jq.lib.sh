
#jq_function_keyrename='def keyrename($from;$to): .+([{"key": $to, "value": .[$from]}]|from_entries)|del(.[$from]);'
#jq_function_keyrename='def keyrename($from;$to): to_entries|map(.key |= if .==$from then ($to) else . end)|from_entries;'
#jq_function_keyrename='def keyrename($from;$to): with_entries(.key |= if .==$from then ($to) else . end);'
jq_function_keyrename='
def keyrename($o): with_entries(.key |= ($o[.] //.) );
def keyrename($from;$to): keyrename({($from):$to});
'
#deps:none
