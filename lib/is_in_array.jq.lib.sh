jq_function_is_in_array='
def is_in_array($a): . as $x|$a|map(select(.==$x)!=null)|first//false;
#def is_in_array($a): length>(($a-[.])|length);
'

