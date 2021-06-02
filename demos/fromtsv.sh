. ./lib/fromtsv.jq.lib.sh


# data-samples/sample1a.tsv
expected="$(
cat<<EOF
X	XX	XXX	XXXX
a'a	"b""b"	"""c'c"""	"""d""d"""
EOF
)"

#         [["X","XX","XXX","XXXX"],["a'a","b\"b","\"c'c\"","\"d\"d\""]]
expected='[["X","XX","XXX","XXXX"],["a'\''a","b\"b","\"c'\''c\"","\"d\"d\""]]'

result="$(
	cat data-samples/sample1a.tsv |
	jq -RcMr "$jq_function_fromtsv$jq_function_totsv"' [.,inputs]|fromtsv'
)"
[ "$result" = "$expected" ] && echo ok || echo ko

result="$(
	cat data-samples/sample1b.tsv |
	jq -RcMr "$jq_function_fromtsv$jq_function_totsv"' [.,inputs]|fromtsv'
)"
[ "$result" = "$expected" ] && echo ok || echo ko

