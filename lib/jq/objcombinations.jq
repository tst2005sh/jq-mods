def objcombinations(f):
	if type=="object" then
		(keys_unsorted) as $keys
		|to_entries|map(
			if f then
				.value|if type=="array" then . else [.] end|objcombinations(f)
			else	.value end
		)
		|combinations
		|with_entries(.key|=$keys[.])
	elif type=="array" then
		map(objcombinations(f))
	else	. end
;
def objcombinations: objcombinations(true);
# objcombinations(.key|test("^@")|not)
