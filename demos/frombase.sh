. ./lib/frombase.jq.lib.sh

jq -ncM "$jq_function_frombase"'
	[0,1,1,1] | frombase(2) == 14
'
