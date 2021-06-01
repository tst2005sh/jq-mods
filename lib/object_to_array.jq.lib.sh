# my version
#jq_function_object_to_array='def object_to_array:
#	{
#		"data": .,
#		"keys": (.|map(keys)|flatten(1)|unique)
#	} |
#	.data |= map(
#		to_entries|sort_by(.key)|map(.value)|flatten(1)
#	) |
#	[ [.keys|sort], .data ] | flatten(1);
#'

jq_deps_object_to_array=''
# thanks to geirha #jq 20180601
jq_function_object_to_array='
def object_to_array($k): [$k,(.[]|[ .[$k[]] ])];
def object_to_array: object_to_array([.[]|keys[]]|unique);
def object_to_array($k;$z): if $z!="*" then object_to_array($k) else
	([.[]|keys[]]|unique) as $a| object_to_array([$k, ($a-$k)]|add)
end;
'
#def object_to_array: ([.[]|keys[]]|unique) as $k | [$k,(.[]|[ .[$k[]] ])];

