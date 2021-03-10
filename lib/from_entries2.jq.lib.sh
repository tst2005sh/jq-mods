jq_function_from_entries2='
def from_entries2($TYPE):
	if ($TYPE=="array") then
		map(.value?)
	else
		from_entries
	end
;
def from_entries2:
if (first|.key|type)=="number" or length==0 then
	map(.value?)
else
	from_entries
end
;'
#deps:none
