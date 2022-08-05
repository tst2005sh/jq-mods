def assert_type($t):
	if $t|type=="string" then
		if type==$t then . else error("assert_type: invalid type, expected \"\($t)\", got \"\(type)\"") end
	else
		if type|is_in_array($t) then . else error("assert_type: invalid type, expected \"\($t|join("\" or \""))\", got \"\(type)\"") end
	end
;
