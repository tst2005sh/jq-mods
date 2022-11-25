def fromtsv:
	map(
		gsub("\\\\n";"\n")|gsub("\\\\r";"\r")|split("\t")|
		map(
			if ((startswith("\"")) and (endswith("\""))) then
				.[1:-1]|gsub("\"\"";"\"")
			else	. end
			|gsub("\\\\t";"\t")
			|gsub("\\\\";"\\")
		)
	)
;
