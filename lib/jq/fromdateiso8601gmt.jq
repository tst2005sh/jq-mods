def fromdateiso8601gmt:
	scan("^(....)-(..)-(..)T(..):(..):(..)(\\.?[0-9]*)([Z+-])(.?.?)(.?.?)$")|
	(.[6]) as $ms|
	if .[7] == "Z" then
		"\(.[0])-\(.[1])-\(.[2])T\(.[3]):\(.[4]):\(.[5])Z"
		|fromdateiso8601
	else 
		((.[7]+.[8]|tonumber*3600)+(.[7]+.[9]|tonumber*60)) as $offset
		|"\(.[0])-\(.[1])-\(.[2])T\(.[3]):\(.[4]):\(.[5])Z"
		|fromdateiso8601-$offset
	end| .+("0\($ms)"|tonumber)
;
