. ./lib/frombase_tobase.jq.lib.sh

jq -ncM "$jq_function_frombase_tobase"'
(
	14 | tobase(2)== [0,1,1,1]
),(
	[0,1,1,1] | frombase(2) == 14
)
'
