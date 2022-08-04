# on peut traiter plusieurs types de donnes en entré
# 1. object		: no-conv : direct filter once ; the access is .value or the custom one
# 2. array of object	: no-conv : 			 the access is .value or the custom one
# 3. array of value	: convert to a list of object (use to_entries) the access is .value
# 3b.			: we should just use map_values and access '.' but we can not be compatible with .value access 
# EDIT: utilisation with_kv a la place with_entries

jq_deps_grep='with_kv'
jq_function_grep="$(cat "${dir:-.}/jq/grep.jq")"
