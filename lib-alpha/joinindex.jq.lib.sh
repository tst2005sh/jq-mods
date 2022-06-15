jq_deps_joinindex='' # JOIN INDEX
jq_function_joinindex='
def joinindex(a;b;$aa;$bb):
	JOIN(	INDEX(b[]; [.[$bb]]);
		a[];
		[.[$aa]]|tostring;
		[.[0],{($aa):.[1]}]|add
	)
;
def joinindex(a;b;aa;bb;aaa):
	JOIN(	INDEX(b[]; [bb]);
		a[];
		[aa]|tostring;
		[.[0],{(aaa):.[1]}]|add
	)
;
'
