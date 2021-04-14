. ./lib/avgsum.jq.lib.sh

printf %s\\n 23 45 678 13 |
jq -R . |
jq -s "$jq_function_avgsum"'avgsum(tonumber) == {"min":13,"avg":189.75,"max":678,"sum":759,"count":4}'
