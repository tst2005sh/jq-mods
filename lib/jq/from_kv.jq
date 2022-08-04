def _from_kv_array: map(select(.key // .Key // .name // .Name >=0)) | map(if has("value") then .value elif has("Value") then .Value else empty end);
def _from_kv_object: from_entries;
def from_kv($type): if ($type=="array") then _from_kv_array else _from_kv_object end;
def from_kv: error("Use: from_kv(type)");
