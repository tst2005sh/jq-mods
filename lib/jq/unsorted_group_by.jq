def unsorted_group_by(f):
	reduce .[] as $item ([]; if length == 0 then [[$item]] elif last[0]|f == ($item|f) then last += [$item] else . + [[$item]] end)
;
