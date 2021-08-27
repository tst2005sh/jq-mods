
. ./lib/tobase.jq.lib.sh
. ./lib/tohexstring.jq.lib.sh
. ./lib/tohex.jq.lib.sh

jq -ncM "$jq_function_tobase$jq_function_tohexstring$jq_function_tohex"'
(
0		| tohex == "0"
),(
1		| tohex == "1"
),(
256		| tohex == "100"
),(
255		| tohex == "ff"
),(
255		| tohex|ascii_upcase == "FF"
),(
17591936700415	| tohex == "ffff1234fff"
)
'
