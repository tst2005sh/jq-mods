
. ./lib/tohexstring.jq.lib.sh

jq -ncM "$jq_function_tohexstring"'
(
[0,1,2,8,9,10,11,14,15]		| tohexstring=="01289abef"
),(
[0] | tohexstring=="0"
)
'
