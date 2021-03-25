
#jq_function_arrayseparator='def arrayseparator($sep): [foreach .[] as $item ([]; ($item, $sep) )] | flatten(1) | [.[0:-1]] ;'
jq_function_arrayseparator='def arrayseparator($sep): if length>1 then [.[0]] + ([.[1:][] | [$sep, .]] | add) else . end;'
