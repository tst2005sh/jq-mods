
jq_deps_recursive_del_ifkey=''
jq_function_recursive_del_ifkey='def recursive_del_ifkey(f): delpaths([paths|select(last|f)]);'

# 11:49:48 <    geirha> and a recursive version  delpaths([paths|select(last|endswith("_count"))])
