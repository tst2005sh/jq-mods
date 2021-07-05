
# syntax:
# 'object_to_array' will produce a content with all object keys as column
# '_object_to_array(["key1","key2"])' will produce a content with only specified object keys (key1 and key2)
# 'object_to_array(["key1","key2"]) will produce a content with all object keys as column but in specified order : key1 then key2 then all others (in not specified order)

. ./lib/object_to_array.jq.lib.sh
#. ./lib/tocsv.jq.lib.sh

sample1() {
echo '[
{	"FOO":"foo1",
	"BUZ":"zzz1",
	"BAR":"bar1"
},
{	"FOO":"foo2",
	"BAR":"bar2"
}
]';
}

####
result="$(
	sample1 |
	jq -cM "$jq_function_object_to_array"'map(with_entries(select(.key=="BAR")))|object_to_array(["BAR"])'
)"
expected='[["BAR"],["bar1"],["bar2"]]'
[ "$result" = "$expected" ] && echo ok || echo ko

####

result="$( sample1 | jq -cM "$jq_function_object_to_array"'object_to_array' )"
expected='[["BAR","BUZ","FOO"],["bar1","zzz1","foo1"],["bar2",null,"foo2"]]'
[ "$result" = "$expected" ] && echo ok || echo ko

####
#result="$(
#	sample1 |
#	jq -r "$jq_function_object_to_array$jq_function_array_to_csv"'object_to_array|array_to_csv'
#)"
#
#expected='"BAR","BUZ","FOO"
#"bar1","zzz1","foo1"
#"bar2",,"foo2"'
#[ "$result" = "$expected" ] && echo ok || echo ko


####
result="$(
	sample1 |	
	jq -cM "$jq_function_object_to_array"'object_to_array(["BUZ"])'
)"
expected='[["BUZ","BAR","FOO"],["zzz1","bar1","foo1"],[null,"bar2","foo2"]]'
[ "$result" = "$expected" ] && echo ok || echo ko

####

result="$(
	sample1 |	
	jq -cM "$jq_function_object_to_array"'map({"BUZ":.BUZ})|object_to_array'
)"
expected='[["BUZ"],["zzz1"],[null]]'
[ "$result" = "$expected" ] && echo ok || echo ko
