
#jq_function_rpad='def rpad($n): (if (length<$n) then (" "*($n-length)+.) else . end);'
#jq_function_lpad='def lpad($n): (if (length<$n) then (.+" "*($n-length)) else . end);'

jq_deps_pad=''
#jq_function_pad='def pad($n): " "*([0,($n-length)]|max);'
#jq_function_rpad='def lpad($n): pad($n)+.;'
#jq_function_lpad='def rpad($n): .+pad($n);'
#echo '"1234567890"' | jq "$jq_function_pad""$jq_function_rpad""$jq_function_lpad"' rpad(10) '; exit

#22:03:44 <    geirha> every language needs a leftpad library
#def leftpad(n): if length > n then . else (" "*n + .)[-n:] end; "12345678901", "123" | leftpad(10)'
jq_function_pad="$(cat "${dir:-.}/jq/pad.jq")"
