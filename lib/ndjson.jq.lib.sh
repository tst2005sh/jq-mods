echo >&2 "lib/ndjson.jq.lib.sh is obsolete, please use tondjson or fromndjson instead."; exit 1

ndjson2json() {
        jq_stack option -s
}

json2ndjson() {
        jq_stack option -cMS
        jq_stack call 'if type=="array" then .[] else . end'
}
