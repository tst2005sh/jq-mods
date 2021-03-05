
jq_function_with_entries2='
def with_entries2(_stmt):
	if (type=="array") then (
		to_entries | map(_stmt) | from_entries2("array")
	) else (
		to_entries | map(_stmt) | from_entries2("object")
	) end
;'
