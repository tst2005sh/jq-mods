
jq_deps_with_entries2='from_entries2'
jq_function_with_entries2='
def with_entries2(f):
	if (type=="array") then (
		to_entries | map(f) | from_entries2("array")
	) else (
		to_entries | map(f) | from_entries2("object")
	) end
;'
