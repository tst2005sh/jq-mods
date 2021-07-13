
jq_deps_fromtsv=''
jq_function_fromtsv='def fromtsv:
	map(split("\t")|
	map(
		if ((startswith("\"")) and (endswith("\""))) then
			.[1:-1]|gsub("\"\"";"\"")
		else	. end|
		gsub("\\\\n";"\n")|gsub("\\\\r";"\r")|
		gsub("\\\\t";"\t")|gsub("\\\\";"\\")
	))
;'
