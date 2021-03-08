. ./lib/ceil.jq.lib.sh

[ $# -gt 0 ] || set -- '-1234.567'

data() {
	echo '
		1.199
		123.456
		987.654
		-1.1
		-1.9
		-123.456
	' | jq -s .
} 

data |
jq -c "$jq_function_ceil"'
	map([floor,.,ceil])|.[]
'
