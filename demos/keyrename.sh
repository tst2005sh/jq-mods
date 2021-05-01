. ./lib/keyrename.jq.lib.sh

echo '{"a":"foo","b":"bar","buz":"buz"}' |
jq -cM "$jq_function_keyrename"'keyrename("a";"foo")|keyrename("b";"bar")'

echo '{"a":"foo","b":"bar","buz":"buz"}' |
jq -cM "$jq_function_keyrename"'keyrename({"a":"foo","b":"bar","c":"ccc"})'

echo '{"foo":"foo","bar":"bar","buz":"buz"}' |
jq -cM "$jq_function_keyrename"'keyrename({"a":"foo","b":"bar","c":"ccc"})'
