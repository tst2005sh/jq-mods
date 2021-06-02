
jq_deps_totsv=''
jq_function_totsv='
def csv_quote_if(f): if f then "\"\( gsub("\"";"\"\"") )\"" else . end;
def csv_quote: csv_quote_if(test("\""));
def csv_quote($opt): if $opt=="string" then csv_quote_if(type=="string") else csv_quote_if(test("\"")) end;
def is_array_of_array: (type=="array") and (length>0) and (map(type=="array")|all);
def _totsv: map(csv_quote)|@tsv;
def totsv: if is_array_of_array then .[]|_totsv else _totsv end;
'
