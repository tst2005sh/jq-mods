. ./lib/better_from_entries_with_entries.jq.lib.sh

jq -ncM "$jq_function_better_from_entries_with_entries"'
(

{}                      |to_entries | .== []				),(
{"a":"A"}              |to_entries | .== [{key:"a",value:"A"}]		),(
["foo"]                 |to_entries | .== [{key:0, value:"foo"}]	),(

[]                      |from_entries == {}			),(
[{key:"a",value:"A"}]   |from_entries == {"a":"A"}		),(
[{key:0, value:"foo"}]  |from_entries == ["foo"]		),(
[]                      |from_entries("array") == []		),(

{}                      |with_entries(.) == {}			),(
{"a":"A"}               |with_entries(.) == {"a":"A"}		),(
["a"]                   |with_entries(.) == ["a"]		),(
[]                      |with_entries(.) == []			

)'
