. ./lib/is_in_array.jq.lib.sh

jq -ncM "$jq_function_is_in_array"'
(
	2 | is_in_array([range(10)]) == true
),(
	["a","b","c"] as $wanted |
	["aa","a","aaa","c", "a"] | map(is_in_array($wanted)) == [false,true,false,true,true]
),(
	["a","b","c"] as $wanted |
	["aa","a","aaa","c", "a"] | map(select(is_in_array($wanted))) == ["a","c","a"]
)
'
