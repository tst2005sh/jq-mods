
jq_deps_del_ifkey=''
jq_function_del_ifkey='def del_ifkey(f): delpaths(keys | map(select(f)|[.]));'

# 11:45:35 < emanuele6> i mean  delpaths(keys | map(select(endswith("_count"))|[.]))
