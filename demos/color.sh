. ./lib/color.jq.lib.sh
. ./lib/ansicolor.jq.lib.sh

jq -nr "$jq_function_color$jq_function_ansicolor"'
[("green"|color),"text",("reset"|color)]|ansicolor
'
