def xl_col_to_name:
	("A"|explode[]) as $min|
	.+1|tobase(26)|reverse|map(.+$min-1)|implode
;
