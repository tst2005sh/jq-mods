
jq_deps_frombase=''
# source: https://github.com/stedolan/jq/pull/2241
jq_function_frombase='def frombase($a): reduce (reverse | .[]) as $i (0; . * $a + $i);'
