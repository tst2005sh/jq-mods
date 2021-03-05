jq_array_to_csv() { jq -r '.[]|@csv'; }
jq_array_to_csv() {
	jq_stack option -r
	jq_stack call '.[]|@csv'
}
