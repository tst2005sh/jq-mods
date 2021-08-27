jq_deps_tohexstring=''
jq_function_tohexstring='def tohexstring: map(if .<10 then .+48 else .+87 end)|implode;'
