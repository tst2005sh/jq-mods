
jq_deps_tobase=''
# source: https://github.com/stedolan/jq/pull/2241
jq_function_tobase='def tobase($a): [while(. > 0; (. / $a) | floor) % $a]|if .==[] then [0] else . end;'
