
jq_function_round='
def round:
	. as $x
	| (if $x < 0 then -1 else 1 end) as $sign
	| ((($x * $sign)+0.5)|floor)
	| (. * $sign)
;'
#deps:none

jq_function_round_precision='
def round($n):
	. as $x
	| (pow(10;$n)) as $m
	| ($x * $m | round / $m)
;'
#deps:pow
