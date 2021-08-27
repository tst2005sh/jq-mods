jq_deps_fromhexstring=''
jq_function_fromhexstring='def fromhexstring: ascii_downcase|explode|map( if .<=57 then .-48 else .-87 end);'
