def with_kv(f): type as $type | to_kv | map(f) | from_kv($type);
