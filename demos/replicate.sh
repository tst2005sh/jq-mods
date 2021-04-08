
. ./lib/replicate.jq.lib.sh

[ "$(
	echo '123' |
	jq -cM "$jq_function_replicate"'
		[replicate(3)]
	'
)" = '[123,123,123]' ] &&
echo ok || echo KO

[ "$(
	echo '[123,5]' |
	jq -cM "$jq_function_replicate"'
		.[1] as $n|first|[replicate($n)]
	'
)" = '[123,123,123,123,123]' ] &&
echo ok || echo KO
