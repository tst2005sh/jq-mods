
jq_deps_with_kv='to_kv from_kv'
jq_function_with_kv='def with_kv(f): type as $type | to_kv | map(f) | from_kv($type);'
