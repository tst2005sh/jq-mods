
jq_deps_tondjson=''
jq_option_tondjson='-c'
jq_function_tondjson='def tondjson: if type=="array" then .[] else . end;'
jq_function_tondjson="$(cat "${dir:-.}/jq/tondjson.jq")"
