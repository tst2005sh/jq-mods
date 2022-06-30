
jq_deps_keyselect='with_kv'
jq_function_keyselect='
def keyselect(f): 
	if type=="array" then
		map(keyselect(f))
	else
	#	if f|type=="string" then
	#		with_kv(select(.key==f))
	#	else
		with_entries(select(.key|f))
	#	end
	end|if .=={} then empty else . end
;'
