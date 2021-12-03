
. ./lib/vobj.jq.lib.sh

jq -ncM "$jq_function_vobj"'
(
"foo" | vobj("bar")		== {"type":"bar","bar":"foo"}
),(
"foo" | vobj("bar") | vvalue	== "foo"
),(
null | vobj("null")		== {"type":"null","null":null}
),(
null | vobj("null") | vvalue	== null
)
'
