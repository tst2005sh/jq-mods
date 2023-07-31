def uniq: 
	[range(0;length) as $i |
		.[$i] as $x |
		if $i == 0 or $x != .[$i-1] then
			$x
		else
			empty
		end
	]
;
