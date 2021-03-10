#jq_array_to_csv() { jq -r '.[]|@csv'; }
#jq_array_to_csv() {
#	jq_stack option -r
#	jq_stack call '.[]|@csv'
#}

jq_function_array_to_csv='def array_to_csv: .[]|@csv;'
#deps:none
