
. ./lib/ansicolor.jq.lib.sh

echo '[ {"color": "yellow"}, "foo", {"color": "reset"} ]' | jq -r "$jq_function_ansicolor"'ansicolor(true)'
echo '[ {"color": "yellow"}, "foo", {"color": "reset"} ]' | jq -r "$jq_function_ansicolor"'ansicolor(false)'
echo '[ {"color": "yellow"}, "foo", [" ", {"color":null}], {"color": "reset"} ]'  | jq "$jq_function_ansicolor"'ansi_calculate_len'

# {"string":"unicode glyph", "length":1}
#echo '{"string":"►", "length":1}' | jq '.string|length'
#echo '{"string":"🦠", "length":1}' | jq '.string|length'
#echo -n '🦠' | hexdump -C
#echo -n '🤣' |hexdump -C
