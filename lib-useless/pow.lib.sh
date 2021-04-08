
# pow already exist in jq 1.5 !

jq_function_pow='
def pow($base; $n):
	1 | reduce range($n) as $i (
		[ -1, . ];
		.[0] = $i | .[1] = (.[1] * $base)
	) | .[1]
;'
#deps:none

# original source: https://github.com/joelpurra/jq-math/blob/master/jq/main.jq https://github.com/joelpurra/jq-dry/blob/master/jq/main.jq
