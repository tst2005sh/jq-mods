jq_function_avgsum='
def avgsum(f):
	map(f)
	| add as $sum
	| length as $count
	| ($sum/$count*100|((if . < 0 then -1 else 1 end) as $sign | (.*$sign + 0.5) | floor * $sign)/100) as $avg
	| {min:min, avg:$avg, max:max, sum:$sum, count:$count};
'
