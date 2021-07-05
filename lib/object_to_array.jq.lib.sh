
jq_deps_object_to_array=''
jq_function_object_to_array='
def _object_to_array($k): [$k,(.[]|[ .[$k[]] ])];
def object_to_array: _object_to_array([.[]|keys[]]|unique);
def object_to_array($k): ([.[]|keys[]]|unique) as $a| _object_to_array([$k, ($a-$k)]|add);
'
# thanks to geirha #jq 20180601

