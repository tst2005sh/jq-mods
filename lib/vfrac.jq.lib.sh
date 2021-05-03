
jq_deps_vfrac='multiply is_in_array assert_type eachother'
jq_function_vfrac='

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
def vnum: if type=="number" then [.] else . end|vobj("vnum");
def vfrac: ({"up": .[0]|vnum, down:.[1]|vnum})|vobj("frac");

def vfracsimplify:
	assert_vtype("frac")
	| (.frac.up|assert_vtype("vnum")|vvalue) as $up
	| (.frac.down|assert_vtype("vnum")|vvalue) as $down
	| .frac.up.vnum = ($up-$down)
	| .frac.down.vnum = ($down-$up)
;

def vnumtonumber:
	if type=="number" then . else
		assert_vtype("vnum")|vvalue|multiply
	end
;

def vfractonumber:
	assert_vtype("frac")|vvalue|
	(
		.up|assert_vtype("vnum")|vnumtonumber
	)/(
		.down|assert_vtype("vnum")|vnumtonumber
	)
;

def vfrac_insert($where;$by):
	assert_vtype("frac")
	| ($by|vnumtonumber) as $b
	| (vvalue[$where]|assert_vtype("vnum")|vvalue) |= (.+=[$b])
;
def vfrac_div($by): vfrac_insert("down";$by);
def vfrac_mul($by): vfrac_insert("up";$by);

#def eachother(f): reduce .[] as $item (null;[.,$item]|f);

#def vadd: eachother( (.[0]//0) + .[1] ) ;
#def vmultiply: eachother( (.[0]//1) * .[1] );
'
