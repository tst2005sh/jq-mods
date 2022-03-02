
. ./lib/maybe.jq.lib.sh

echo '
"123"
"abc"
' | jq -s "$jq_function_maybe"'
map( maybe(tonumber) ) == [123,"abc"]
'
