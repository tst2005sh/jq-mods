jq_deps_round=''
jq_function_round='
def round: (if . < 0 then -1 else 1 end) as $sign | (.*$sign + 0.5) | floor * $sign;'
#deps:none

#jq_deps_round_precision='pow'
#jq_function_round_precision='
#def round($n;$base): (pow($base//10;$n)) as $m | (.*$m | round / $m);
#def round($n): round($n;10);
#'
