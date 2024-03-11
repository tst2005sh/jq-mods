def group_until(condition):
	reduce .[] as $l ([[]]; .[-1] += [$l] | if ($l|condition) then . + [[]] else . end) |
	map(select(length > 0))
;
