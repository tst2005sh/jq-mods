
jq_deps_vobj='is_in_array assert_type'
jq_function_vobj='
def vtype: assert_type("object")| .type?;
def assert_vtype($t):
	if $t|type=="string" then
		if vtype==$t then . else error("invalid vtype") end
	else
		if vtype|is_in_array($t) then . else error("assert_type: invalid vtype") end
	end
;
def vobj($t): {"type":$t, ($t): .};
def vvalue: .[.type];
'
