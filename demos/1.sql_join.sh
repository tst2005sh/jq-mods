. ./lib/from_entries2.jq.lib.sh
. ./lib/with_entries2.jq.lib.sh
. ./lib/grep.jq.lib.sh
if jq --version |grep -q 'jq-1\.5'; then
	. ./lib/jq16sqlbuiltin.jq.lib.sh
else
	jq_function_jq16sqlbuiltin=''
fi

# source: https://github.com/stedolan/jq/issues/1475

#### input ####
assets_ndjson() {
	echo '{"assetid":1, "classid":1, "instanceid":5}'
	echo '{"assetid":2, "classid":1, "instanceid":5}'
	echo '{"assetid":3, "classid":2, "instanceid":3}'
	echo '{"assetid":4, "classid":2, "instanceid":1}'
}
descriptions_ndjson() {
	echo '{"classid":1, "instanceid": 5, "name":"alpha"}'
	echo '{"classid":2, "instanceid": 3, "name":"beta"}'
	echo '{"classid":2, "instanceid": 1, "name":"gamma"}'
}
#### /input ####

#### output ####
wanted='{"assetid":1,"name":"alpha"}
{"assetid":2,"name":"alpha"}
{"assetid":3,"name":"beta"}
{"assetid":4,"name":"gamma"}'
#### /output ####


ndjson_pack() { jq -sc .; }

assets_json() { assets_ndjson|ndjson_pack; }
descriptions_json() { descriptions_ndjson|ndjson_pack; }

data1() {
	{
		assets_json
		descriptions_json
	} | jq -s '{ "assets":.[0], "descriptions":.[1] }'
}

data() {
	{
		assets_json|jq '{"assets":.}'
		descriptions_json|jq '{"descriptions":.}'
	} | jq -s 'add'
}

result="$(
	data |
	jq -c "$jq_function_jq16sqlbuiltin"'
	JOIN(
		INDEX(.descriptions[]; [.classid, .instanceid]);
		.assets[];
		[.classid,.instanceid]|tostring;
		{assetid:(.[0].assetid),name:(.[1].name)}
	)'
)"

if [ "$result" = "$wanted" ]; then
	echo ok
else
	echo KO
	echo ---- WANTED:
	echo "$wanted"
	echo ---- GOT:
	echo "$result"
fi
