
. ./lib/fromtsv.jq.lib.sh
. ./lib/is_array_of_array.jq.lib.sh
. ./lib/tocsv.jq.lib.sh
. ./lib/fromcsv.jq.lib.sh

cat data-samples/sample1a.tsv
jq -R "$jq_function_fromtsv"'[.,inputs]|fromtsv' < data-samples/sample1a.tsv

jq -R "$jq_function_fromtsv"'[.,inputs]|fromtsv' < data-samples/sample1a.tsv |
jq -r "$jq_function_is_array_of_array$jq_function_tocsv"'tocsv' |
cat
#jq -R "$jq_function_fromcsv"'[.,inputs]|fromcsv'


