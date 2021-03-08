. ./lib/abs.jq.lib.sh

echo '
123
-123
1.23
0
-0
12345.3
' |
jq -c "$jq_function_abs"'
[.,abs]'
