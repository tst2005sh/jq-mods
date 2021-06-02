
jq_deps_totsv='tocsv_common'
jq_function_totsv='
def _totsv: map(csv_quote)|@tsv;
def totsv: if is_array_of_array then .[]|_totsv else _totsv end;
'
