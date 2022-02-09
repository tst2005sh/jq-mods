. ./lib/to_kv.jq.lib.sh
. ./lib/from_kv.jq.lib.sh
. ./lib/with_kv.jq.lib.sh

jq -ncM "$jq_function_to_kv$jq_function_from_kv$jq_function_with_kv"'
(

{}				|to_kv | .== []				),(
{"a":"A"}			|to_kv | .== [{key:"a",value:"A"}]	),(
["foo"]				|to_kv | .== [{key:0, value:"foo"}]	),(

#[]				|from_kv == {}				),(
#[{key:"a",value:"A"}]		|from_kv == {"a":"A"}			),(
#[{key:0, value:"foo"}]		|from_kv == ["foo"]			),(
[]				|from_kv("array") == []			),(

{}				|with_kv(.) == {}			),(
{"a":"A"}			|with_kv(.) == {"a":"A"}		),(
["a"]				|with_kv(.) == ["a"]			),(
[]				|with_kv(.) == []

)'
