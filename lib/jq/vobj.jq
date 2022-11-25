def vtype: assert_type("object")| .type?;
def assert_vtype($t):
	if $t|type=="string" then
		if vtype==$t then . else error("invalid vtype") end
	else
		if vtype|is_in_array($t) then . else error("assert_type: invalid vtype") end
	end
;
def vobj($t): {"type":$t, ($t): .};
def vobj($t;$v): $v|vobj($t);
def vvalue: .[.type];
