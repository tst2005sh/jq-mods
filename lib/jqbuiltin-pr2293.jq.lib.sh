jq_function_pr2293='
def _from_entries_array: map(select(.key // .Key // .name // .Name >=0)) | map(if has("value") then .value elif has("Value") then .Value else empty end);
def _from_entries_object: map({(.key // .Key // .name // .Name): (if has("value") then .value else .Value end)}) | add | .//={};
def from_entries($type): if $type=="array" then _from_entries_array else _from_entries_object end;
def from_entries: from_entries(if .[0].key|type=="number" then "array" else "object" end);
def with_entries(f): type as $type | to_entries | map(f) | from_entries($type);
'
