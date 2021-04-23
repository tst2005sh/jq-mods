. ./lib/multiply.jq.lib.sh
. ./lib/is_in_array.jq.lib.sh
. ./lib/assert_type.jq.lib.sh
. ./lib/vfrac.jq.lib.sh


jq_tests='
def test1:	5 | is_in_array([2,5,1024])				| .==true ;
def test2:	[2,5,1024] | multiply					| .==10240 ;

def test3:	[123,"a"]|map(assert_type(["string","number"]))	| .==[123,"a"] ;
def test4:	[123,"a"]|map(assert_type([(""|type),(1|type)]))	| .==[123,"a"] ;

def test5error:	{}|assert_type(["string","number"]) ;
def test5: try (test5error|false) catch true				| .==true ;

def test6a:	{}|vtype=="object"					| .==false ;
def test6b:	{type:"foo"}|vtype=="foo"				| .==true ;

def test7a:	["foo"]|assert_type("array")				| .==["foo"] ;
def test7b:	["foo"]|assert_type([]|type)				| .==["foo"] ;
def test7c:	["foo"]|assert_type(["array","object"])			| .==["foo"] ;
def test7d:	["foo"]|assert_type([([]|type),({}|type)])		| .==["foo"] ;

def test8:	{}|vtype=="object"					|.==false ;

def test9a:	[1,3]|vfrac						| .=={"type":"frac","frac":{"up":{"type":"vnum","vnum":[1]},"down":{"type":"vnum","vnum":[3]}}} ;
def test9b:	[1,3]|vfrac|assert_vtype("frac")			| .=={"type":"frac","frac":{"up":{"type":"vnum","vnum":[1]},"down":{"type":"vnum","vnum":[3]}}} ;

def test10a:	[ [2,5,1000,1024], [1,3,5,1000] ]|vfrac|assert_vtype("frac")|vfracsimplify
									| .=={"type":"frac","frac":{"up":{"type":"vnum","vnum":[2,1024]},"down":{"type":"vnum","vnum":[1,3]}}} ;
def test10b:	[2,5,1024] |vnum | vnumtonumber				| .== 10240 ;
def test10c: 	[ [2,5,1000,1024], [1,3,5,1000] ]|vfrac|assert_vtype("frac")|vfracsimplify|assert_vtype("frac")|vfractonumber
									| .==682.6666666666666;

def test11a: [1,3]|vfrac|assert_vtype("frac")|vfrac_div(2)|vfractonumber
									|.==1/6 ;
def test11b: [1,3]|vfrac|assert_vtype("frac")|vfrac_div(2)|vfrac_mul(3)|vfractonumber
									|.==1/2 ;
def test11c: [1,3]|vfrac|assert_vtype("frac")|vfrac_div(2)|vfrac_mul(3)|vfracsimplify|[(vvalue|.up|vvalue),(vvalue|.down|vvalue)]
									| .==[[1],[2]] ;

def tests:
test1,
test2,
test3,
test4,
test5,
test6a,test6b,
test7a,test7b,
test8,
test9a,test9b,
test10a,test10b,test10c,
test11a,test11b,test11c
;
'

jq -ncM "$jq_function_multiply$jq_function_is_in_array$jq_function_assert_type$jq_function_vfrac$jq_tests"'
tests
'
