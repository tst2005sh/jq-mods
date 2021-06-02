. ./lib/tocsv_common.jq.lib.sh
. ./lib/fromtsv.jq.lib.sh
. ./lib/totsv.jq.lib.sh

expected="$(
cat<<EOF
X	XX	XXX	XXXX
a'a	"b""b"	"""c'c"""	"""d""d"""
EOF
)"

result="$(
	cat data-samples/sample1a.tsv |
	jq -RcMr "$jq_function_tocsv_common$jq_function_fromtsv$jq_function_totsv"' [.,inputs]|fromtsv|.[]|totsv'
)"
[ "$result" = "$expected" ] && echo ok || echo ko
echo "$result" | comm -3 - data-samples/sample1a.tsv

result="$(
	cat data-samples/sample1a.tsv |
	jq -RcMr "$jq_function_tocsv_common$jq_function_fromtsv$jq_function_totsv"' [.,inputs]|fromtsv|totsv '
)"
[ "$result" = "$expected" ] && echo ok || echo ko
