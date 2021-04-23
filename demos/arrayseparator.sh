. ./lib/arrayseparator.jq.lib.sh

input='["a","b","c"]'
expected='["a","_","b","_","c"]'
result="$(
	echo "$input" |	
	jq -cM "$jq_function_arrayseparator"'
		arrayseparator("_")
	'
)"
[ "$result" = "$expected" ] && echo ok || echo KO


input='"aa,b b,cc"'
expected='"(aa),(b b),(cc)"'
result="$(
	echo "$input" |	
	jq -cM "$jq_function_arrayseparator"'
		split(",")
		| arrayseparator("),(")
		| "(\(join("")))"
	'
)"
[ "$result" = "$expected" ] && echo ok || echo KO
