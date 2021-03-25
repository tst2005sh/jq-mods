jq_function_color='
def color:
	if .==null or . == "" then empty else
		{"color": .}
	end
;
def color_text($colorv):
	if .== "" then empty else
		(($colorv)|color),
		.,
		if ($colorv != null) and ($colorv != "") then ("reset"|color) else empty end
	end
;
'
