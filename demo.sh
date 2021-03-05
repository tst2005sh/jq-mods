. ./lib/from_entries2.jq.lib.sh
. ./lib/with_entries2.jq.lib.sh
. ./lib/grep.jq.lib.sh
#. ./lib/without.jq.lib.sh

[ $# -gt 0 ] || set -- '"foo"'

printf %s\\n \
'"foo"' \
'"bar"' \
'"foobar"' |
jq -s . |

jq "$jq_function_from_entries2""$jq_function_with_entries2""$jq_function_grep"'igrep('"$1"')'

(
echo '{"foo":"bar", "value":"FOO"}'
echo '[{"foo":"bar", "value":"bbfoobb"}]'
echo '["bar","buz",123,"foobar",543]'
) |
jq "$jq_function_from_entries2""$jq_function_with_entries2""$jq_function_grep"'igrep('"$1"';(.value|tostring))'

#jq "$jq_function_from_entries2""$jq_function_with_entries2"'with_entries2(.)'
