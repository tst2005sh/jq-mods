def array_to_object:
	(first) as $keys|
	.[1:]|map( with_entries(.key=($keys[.key])) )
;
