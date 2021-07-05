
. ./lib/array_to_object.jq.lib.sh

result="$(
	echo '[["BUZ","BAR","FOO"],["zzz1","bar1","foo1"],[null,"bar2","foo2"]]' |
	jq -cM "$jq_function_array_to_object"'array_to_object'
)"

expected='[{"BUZ":"zzz1","BAR":"bar1","FOO":"foo1"},{"BUZ":null,"BAR":"bar2","FOO":"foo2"}]'
[ "$result" = "$expected" ] && echo ok || echo ko
