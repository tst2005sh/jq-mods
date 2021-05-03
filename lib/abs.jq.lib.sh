
jq_deps_abs=''
jq_function_abs='def abs: if .==0 then [0,.]|min elif .<0 then .*-1 else . end;'
