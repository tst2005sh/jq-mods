jq_deps_eachother=''
jq_function_eachother='def eachother(f): reduce .[] as $item (null;[.,$item]|f);'
