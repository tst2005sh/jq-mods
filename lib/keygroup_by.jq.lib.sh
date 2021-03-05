jq_function_keygroup_by='def keygroup_by($field): group_by(.[$field]) | map({"key": .[0][$field], "value": (map(del(.[$field]))) }) |from_entries;'
