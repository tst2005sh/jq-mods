def _avgsum:
	add as $sum
	| length as $count
	| ($sum/$count) as $avg
	| {min:min, avg:$avg, max:max, sum:$sum, count:$count};
def avgsum: _avgsum | .avg |= (.*100|((if . < 0 then -1 else 1 end) as $sign | (.*$sign + 0.5) | floor * $sign)/100) ;
def avgsum(f): map(f) | avgsum ;
