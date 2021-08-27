
. ./lib/frombase.jq.lib.sh
. ./lib/fromhexstring.jq.lib.sh
. ./lib/fromhex.jq.lib.sh

jq -ncM "$jq_function_frombase$jq_function_fromhexstring$jq_function_fromhex"'
(
"0"		| fromhex == 0
),(
"001"		| fromhex == 1
),(
"100"		| fromhex == 256
),(
"ff"		| fromhex == 255
),(
"FF"		| fromhex == 255
),(
"FFFF1234fff"	| fromhex == 17591936700415
)
'
