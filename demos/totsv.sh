. ./lib/is_array_of_array.jq.lib.sh
. ./lib/totsv.jq.lib.sh

expected="$(
cat<<EOF
X	XX	XXX	XXXX
a'a	"b""b"	"""c'c"""	"""d""d"""
EOF
)"

#         [["X","XX","XXX","XXXX"],["a'a","b\"b","\"c'c\"","\"d\"d\""]]
json='[["X","XX","XXX","XXXX"],["a'\''a","b\"b","\"c'\''c\"","\"d\"d\""]]'

result="$(
	echo "$json" |
	jq -cMr "$jq_function_is_array_of_array$jq_function_totsv"' totsv'
)"
[ "$result" = "$expected" ] && echo ok || echo ko

#jq -n "$jq_function_totsv"' [["a","b"],["a\"a","bb"]]|totsv'
