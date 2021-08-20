. ./lib/re_quote.jq.lib.sh
. ./lib/glob_to_re.jq.lib.sh
. ./lib/glob.jq.lib.sh

jq -n "$@" "$jq_function_re_quote$jq_function_glob_to_re$jq_function_glob"'
"foo-123-*-bar.txt"|glob("foo-*-\\*-*.txt")
'
