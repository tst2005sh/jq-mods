
jq_deps_unsortedunique=''
jq_function_unsortedunique='def unsortedunique: to_entries|group_by(.value)|map(min_by(.key))|sort_by(.key)|map(.value);'
# Thanks geirha (2021-09-10 12:12:16)
