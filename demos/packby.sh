. ./lib/packby.jq.lib.sh

jq -ncM "$jq_function_packby"'
(
	[1,2,3,4,5,6,7,8,9,10,11,12] | packby(2) == [[1,2],[3,4],[5,6],[7,8],[9,10],[11,12]]
),(
	[1,2,3,4,5,6,7,8,9,10,11,12] | packby(3) == [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]
),(
	[1,2,3,4,5,6,7,8,9,10,11   ] | packby(3) == [[1,2,3],[4,5,6],[7,8,9],[10,11   ]]
),(
	[1,2,3,4,5,6,7,8,9,10,11,12] | packby(4) == [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
),(
	[1,2,3,4,5,6,7,8,9,10,11,12] | packby(5) == [[1,2,3,4,5],[6,7,8,9,10],[11,12]]
)
'
