. ./lib/jq16sqlbuiltin.jq.lib.sh

jq -c -n "$jq_function_jq16sqlbuiltin"'{
    "assets":[
            {"assetid":1, "classid":1, "instanceid":5},
            {"assetid":2, "classid":1, "instanceid":5},
            {"assetid":3, "classid":2, "instanceid":3},
            {"assetid":4, "classid":2, "instanceid":1}],
    "descriptions":[
            {"classid":1, "instanceid": 5, "name":"alpha"},
            {"classid":2, "instanceid": 3, "name":"beta"},
            {"classid":2, "instanceid": 1, "name":"gamma"}]
} | JOIN(
        INDEX(.descriptions[]; [.classid, .instanceid]);
        .assets[];
        [.classid,.instanceid]|tostring;
        {assetid:(.[0].assetid),name:(.[1].name)}
)'

