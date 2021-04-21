. ./lib/is_in_array.jq.lib.sh
. ./lib/assert_type.jq.lib.sh

jq -ncM "$jq_function_is_in_array$jq_function_assert_type"'
def test1:	["ok"]|assert_type(["array","number"])		| (.==["ok"]);
def test2:	{"ok"}|assert_type("object")			| (.=={"ok"});
[test1,test2]|all
'
