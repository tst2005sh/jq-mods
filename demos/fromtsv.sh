. ./lib/fromtsv.jq.lib.sh

#         [["X","XX","XXX","XXXX"],["a'a","b\"b","\"c'c\"","\"d\"d\""]]
expected='[["X","XX","XXX","XXXX"],["a'\''a","b\"b","\"c'\''c\"","\"d\"d\""]]'

result="$(
	cat data-samples/sample1a.tsv |
	jq -RcMr "$jq_function_fromtsv"' [.,inputs]|fromtsv'
)"
[ "$result" = "$expected" ] && echo ok || echo ko

result="$(
	cat data-samples/sample1b.tsv |
	jq -RcMr "$jq_function_fromtsv"' [.,inputs]|fromtsv'
)"
[ "$result" = "$expected" ] && echo ok || echo ko

result="$(
	printf 'foo\tbar\n"x\\ny"\tBAR\n' |
	jq -RcMr "$jq_function_fromtsv"'
		[.,inputs]|fromtsv == [["foo","bar"],["x\ny","BAR"]]
	'
)"
expected='true'
[ "$result" = "$expected" ] && echo ok || echo ko
