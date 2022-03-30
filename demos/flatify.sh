
. ./lib/flatify.jq.lib.sh

echo '
{"id":1,"foo":"foo",                "custom_fields":{"x":"x1","foo":"FOO1"}}
{"id":2,"foo":"foo2", "bar":"bar2" ,"custom_fields":{"x":"x2","foo":"FOO2"}}
{"id":3,"foo":"foo3", "bar":"bar3" ,"custom_fields":null}
{"id":4,"foo":"foo4", "bar":"bar4"}
' |
jq -cM "$jq_function_flatify"'
if .custom_fields? then flatify(.custom_fields;"CF_\(.)") else del(.custom_fields) end
'
