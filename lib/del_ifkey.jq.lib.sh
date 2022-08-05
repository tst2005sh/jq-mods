
jq_deps_del_ifkey=''
jq_function_del_ifkey="$(cat "${dir:-.}/jq/del_ifkey.jq")"
# 11:45:35 < emanuele6> i mean  delpaths(keys | map(select(endswith("_count"))|[.]))
