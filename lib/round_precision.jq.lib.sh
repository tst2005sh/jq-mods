
jq_deps_round_precision='pow'
jq_function_round_precision='
def round($n;$base): (pow($base//10;$n)) as $m | (.*$m | round / $m);
def round($n): round($n;10);
'

jq_deps_round_decimals='pow'
jq_function_round_decimals='
def round($decimals):
	. as $x
	# Assuming decimal numbers.
	| 10 as $base
	| (if $x < 0 then -1 else 1 end) as $signNegator
	| pow($base; $decimals) as $shifter
	| $x * $shifter * $signNegator
	| floor as $integer
	| (
		if (((. - $integer) * $base | floor) * 2) >= $base then
			1
		else
			0
		end
	) as $rounding
	| $integer + $rounding
	| . / $shifter * $signNegator
;
#def round: round(0);
'
# source: https://github.com/joelpurra/jq-math/blob/master/jq/main.jq
