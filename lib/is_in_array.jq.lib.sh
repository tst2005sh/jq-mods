jq_deps_is_in_array=''
jq_function_is_in_array='def is_in_array($a): any($a[] == .; .);'
jq_function_is_in_array="$(cat "${dir:-.}/jq/is_in_array.jq")"
# Note: is_in_array($myarray) equals IN($myarray[]) (IN function is available in jq 1.6)
