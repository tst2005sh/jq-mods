. ./lib-useless/string_to_array.jq.lib.sh

[ "$(echo '"abcde"' | jq -cM "$jq_function_string_to_array"'string_to_array')" = '["a","b","c","d","e"]' ] &&
echo "ok" || echo "KO"
