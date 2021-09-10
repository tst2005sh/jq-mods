. ./lib/unsortedunique.jq.lib.sh

echo '["foo","bar","foo","bar"]' |
jq -cM "$jq_function_unsortedunique"'
	unsortedunique == ["foo","bar"]
'

echo '["foo","bar","buz","foo","bar"]' |
jq -cM "$jq_function_unsortedunique"'
	unsortedunique == ["foo","bar","buz"]
'

echo '["foo","bar","foo","bar","buz"]' |
jq -cM "$jq_function_unsortedunique"'
	unsortedunique == ["foo","bar","buz"]
'


