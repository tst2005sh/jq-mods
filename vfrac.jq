def multiply: reduce .[] as $item (1;.*$item);

#def is_in_array($a): . as $x|$a|map(select(.==$x)!=null)|first//false;
def is_in_array($a): length>(($a-[.])|length);

def assert_type($t):
	if $t|type=="string" then
		if type==$t then . else error("invalid type") end
	else
		if type|is_in_array($t) then . else error("assert_type: invalid type") end
	end
;

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
	assert_vtype("frac")|
	(.frac.up|assert_vtype("vnum")|vvalue) as $up|
	(.frac.down|assert_vtype("vnum")|vvalue) as $down|
	.frac.up.vnum = ($up-$down)|
	.frac.down.vnum = ($down-$up)
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
	assert_vtype("frac")|
	($by|vnumtonumber) as $b|
	.frac[$where].vnum=[.frac[$where].vnum[],$b]
;
def vfrac_div($by): vfrac_insert("down";$by);
def vfrac_mul($by): vfrac_insert("up";$by);


# 5 | is_in_array([2,5,1024])				| .==true
# [2,5,1024] | multiply | .==10240

# [123,"a"]|map(assert_type(["string","number"]))	| .==[123,"a"]
# [123,"a"]|map(assert_type([(""|type),(1|type)]))	| .==[123,"a"]

# {}|assert_type(["string","number"])			===> error


# {}|vtype=="object"					| .==false
# {type:"foo"}|vtype=="foo"				| .==true

# ["foo"]|assert_type("array")				| .==["foo"]
# ["foo"]|assert_type([]|type)				| .==["foo"]
# ["foo"]|assert_type(["array","object"])		| .==["foo"]
# ["foo"]|assert_type([([]|type),({}|type)])		| .==["foo"]

# {}|vtype=="object"|.==false

# [1,3]|vfrac
# [1,3]|vfrac|assert_vtype("frac")

# [ [2,5,1000,1024], [1,3,5,1000] ]|vfrac|assert_vtype("frac")|vfracsimplify
# [2,5,1024] |vnum | vnumtonumber == 10240
# [ [2,5,1000,1024], [1,3,5,1000] ]|vfrac|assert_vtype("frac")|vfracsimplify|assert_vtype("frac")|vfractonumber

# [1,3]|vfrac|assert_vtype("frac")|vfrac_div(2)|vfractonumber|.==1/6
# [1,3]|vfrac|assert_vtype("frac")|vfrac_div(2)|vfrac_mul(3)|vfractonumber|.==1/2
# [1,3]|vfrac|assert_vtype("frac")|vfrac_div(2)|vfrac_mul(3)|vfracsimplify|[(vvalue|.up|vvalue),(vvalue|.down|vvalue)]| .==[[1],[2]]
