
jq_deps_totsv='is_array_of_array'
jq_function_totsv='
def tsv_quote_if(f): if f then "\"\( gsub("\"";"\"\"") )\"" else . end;
def tsv_quote: tsv_quote_if(test("\""));
def tsv_quote($opt): if $opt=="string" then tsv_quote_if(type=="string") else tsv_quote_if(test("\"")) end;

def _totsv: map(tsv_quote)|@tsv;
def totsv: if is_array_of_array then .[]|_totsv else _totsv end;
'
