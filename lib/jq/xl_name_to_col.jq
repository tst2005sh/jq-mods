def xl_name_to_col:
	("A"|explode[]) as $min|
	ascii_upcase|explode|map(.-$min+1)|reverse|frombase(26)-1
;
