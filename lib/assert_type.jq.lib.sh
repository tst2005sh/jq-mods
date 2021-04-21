#require: is_in_array

jq_function_assert_type='
def assert_type($t):
	if $t|type=="string" then
		if type==$t then . else error("invalid type") end
	else
		if type|is_in_array($t) then . else error("assert_type: invalid type") end
	end
;'
