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

# thanks to geirha #jq 20180601
jq_function_object_to_array='
def object_to_array: ([.[]|keys[]]|unique) as $k | [$k,(.[]|[ .[$k[]] ])];
def object_to_array($k): [$k,(.[]|[ .[$k[]] ])];
'
#deps:none
