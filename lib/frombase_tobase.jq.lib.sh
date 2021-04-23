
# source: https://github.com/stedolan/jq/pull/2241
jq_function_frombase_tobase='
def tobase($a): [while(. > 0; (. / $a) | floor) % $a];
def frombase($a): reduce (reverse | .[]) as $i (0; . * $a + $i);'
