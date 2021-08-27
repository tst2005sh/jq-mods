jq_deps_fromhexstring=''
jq_function_fromhexstring='def fromhexstring: explode|map(.-48|if .>=17 then .-7 else . end|if .>=42 then .-32 else . end);'

