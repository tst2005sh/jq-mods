jq_deps_is_in_array=''
jq_function_is_in_array='def is_in_array($a): any($a[] == .; .);'

# Note: is_in_array($myarray) equals IN($myarray[]) (IN function is available in jq 1.6)
