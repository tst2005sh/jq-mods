ndjson2json() {
        jq_stack option -s
}

json2ndjson() {
        jq_stack option -cMS
        jq_stack call 'if type=="array" then .[] else . end'
}
