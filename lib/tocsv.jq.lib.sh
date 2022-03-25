
jq_deps_tocsv='is_array_of_array'
jq_function_tocsv='
def _tocsv: @csv;
def tocsv: if length==1 and (first|is_array_of_array) then .[] else . end |if is_array_of_array then .[]|_tocsv else _tocsv end;
'
