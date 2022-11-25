
#[.,inputs]
jq_deps_fromndjson=''
jq_function_fromndjson='def fromndjson: if type=="array" and length==1 and (first|type)=="array" and (first|length)>=1 then .[] else . end;'
jq_function_fromndjson="$(cat "${dir:-.}/jq/fromndjson.jq")"
