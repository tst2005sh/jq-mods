
. ./lib/unique_no_sort_by.jq.lib.sh

echo '
"c"
"z"
"c"
"a"
' | jq -s "$jq_function_unique_no_sort_by"'
unique_no_sort_by(.) == ["c","z","a"]'

echo '
{"o":"c","x":1}
{"o":"z"}
{"o":"c"}
{"o":"a"}
' | jq -s -cM "$jq_function_unique_no_sort_by"'
	unique_no_sort_by(.o)==[{"o":"c","x":1},{"o":"z"},{"o":"a"}]
'

