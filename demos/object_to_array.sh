
. ./lib/object_to_array.jq.lib.sh
. ./lib/array_to_csv.jq.lib.sh

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


result="$(
	sample1 |
	jq -cM "$jq_function_object_to_array"'object_to_array(["BAR"])'
)"
expected='[["BAR"],["bar1"],["bar2"]]'
[ "$result" = "$expected" ] && echo ok || echo ko


sample1 | jq "$jq_function_object_to_array"'object_to_array'

result="$(
	sample1 |
	jq -r "$jq_function_object_to_array$jq_function_array_to_csv"'object_to_array|array_to_csv'
)"

expected='"BAR","BUZ","FOO"
"bar1","zzz1","foo1"
"bar2",,"foo2"'
[ "$result" = "$expected" ] && echo ok || echo ko

