
. ./lib/from_entries2.jq.lib.sh
. ./lib/with_entries2.jq.lib.sh
. ./lib/grep.jq.lib.sh

[ $# -gt 0 ] || set -- '"foo"'

printf %s\\n \
'"foo"' \
'"bar"' \
'"foobar"' |
jq -s . |

jq "$jq_function_from_entries2""$jq_function_with_entries2""$jq_function_grep"'igrep('"$1"')'

