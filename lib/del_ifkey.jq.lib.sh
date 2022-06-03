
jq_deps_del_ifkey=''
jq_function_del_ifkey='def del_ifkey(f): delpaths(keys | map(select(f)|[.]));

jq_deps_recursive_del_ifkey=''
jq_function_recursive_del_ifkey='def recursive_del_ifkey(f): delpaths([paths|select(last|f)]);'
#jq_function_recursive_del_ifkey='def recursive_del_ifkey(f): delpaths([paths(last|f)]);


# 11:45:35 < emanuele6> i mean  delpaths(keys | map(select(endswith("_count"))|[.]))
# 11:49:48 <    geirha> and a recursive version  delpaths([paths|select(last|endswith("_count"))])
# 11:55:53 < emanuele6> can be written as   delpaths([paths(last|endswith("_count"))])  i think
