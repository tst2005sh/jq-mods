. ./lib/unsortedunique.jq.lib.sh

echo '["foo","bar","foo","bar"]' |
jq -cM "$jq_function_unsortedunique"'
	unsortedunique == ["foo","bar"]
'
