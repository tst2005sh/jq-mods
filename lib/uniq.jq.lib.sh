jq_deps_uniq=''
jq_function_uniq='def uniq: 
	[range(0;length) as $i |
		.[$i] as $x |
		if $i == 0 or $x != .[$i-1] then
			$x
		else
			empty
		end
	];
'
jq_function_uniq="$(cat "${dir:-.}/jq/uniq.jq")"
# source: https://github.com/stedolan/jq/wiki/Cookbook#remove-adjacent-matching-elements-from-a-list
