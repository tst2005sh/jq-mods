jq_function_db_keepresult='def db_keepresult($resultfield;$dbfield;$idfield):
	(.[$resultfield]|map({key:., value:true})|from_entries) as $want | .[$dbfield] |= map(select($want[.[$idfield]]))|del(.[$resultfield]);
def db_keepresult: db_keepresult("result";"db";"id");'
#deps: none
