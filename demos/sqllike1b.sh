. ./lib/jq16sqlbuiltin.jq.lib.sh

data_assets() {
cat<<EOF
{"assetid":1, "classid":1, "instanceid":5}
{"assetid":2, "classid":1, "instanceid":5}
{"assetid":3, "classid":2, "instanceid":3}
{"assetid":4, "classid":2, "instanceid":1}
EOF
}

data_descriptions() {
cat<<EOF
{"classid":1, "instanceid": 5, "name":"alpha"}
{"classid":2, "instanceid": 3, "name":"beta"}
{"classid":2, "instanceid": 1, "name":"gamma"}
EOF
}

data() {
	{
		data_assets | jq -s .
		data_descriptions | jq -s .
	} |
	jq -s '{"assets":.[0], "descriptions":.[1]}'

}

solution() {
	jq -c "$jq_function_jq16sqlbuiltin"'
		JOIN(	INDEX(.descriptions[]; [.classid, .instanceid]);
			.assets[];
			[.classid,.instanceid]|tostring;
			{assetid:(.[0].assetid),name:(.[1].name)}
		)
	'
}
result="$(data|solution)"

expected='{"assetid":1,"name":"alpha"}
{"assetid":2,"name":"alpha"}
{"assetid":3,"name":"beta"}
{"assetid":4,"name":"gamma"}'

[ "$result" = "$expected" ] && echo ok || echo ko
exit
