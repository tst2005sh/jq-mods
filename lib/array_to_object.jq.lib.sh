jq_function_array_to_object='def array_to_object:
	(first) as $keys|
	.[1:]|map( with_entries(.key=($keys[.key])) )
;'
