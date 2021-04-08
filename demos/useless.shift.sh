
. ./lib-useless/shift.jq.lib.sh

[ "$(echo '["a","b","c","d","e"]' | jq -cM "$jq_function_shift"'shift'
)" = '["b","c","d","e"]' ] &&
echo ok || echo KO

[ "$(echo '["a","b","c","d","e"]' | jq -cM "$jq_function_shift"'shift(3)'
)" = '["d","e"]' ] &&
echo ok || echo KO
