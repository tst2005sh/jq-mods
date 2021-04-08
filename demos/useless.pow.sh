# jq 1.5 already include pow()

. ./lib-useless/pow.jq.lib.sh

echo '
[10,3,1000]
[1000,3,1000000000]
[1024,3,1073741824]
' |
jq -c "$jq_function_pow"'
pow(.[0];.[1])==.[2]
'

jq -c -n "$jq_function_pow"' pow(1000;3)/pow(1024;3)'
