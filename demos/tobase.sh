. ./lib/tobase.jq.lib.sh

jq -ncM "$jq_function_tobase"'
(
	14 | tobase(2)== [0,1,1,1]
),(
	0 | tobase(2)== [0]
)
'
