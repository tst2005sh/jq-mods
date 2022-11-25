
jq_deps_unsorted_unique='unsorted_unique_by'
#jq_function_unsorted_unique='def unsorted_unique: to_entries|group_by(.value)|map(min_by(.key))|sort_by(.key)|map(.value);'
#jq_function_unsorted_unique='def unsorted_unique: to_entries|unique_by(.value)|sort_by(.key)|map(.value);'
# Thanks geirha (2021-09-10 12:12:16)
jq_function_unsorted_unique="$(cat "${dir:-.}/jq/unsorted_unique.jq")"
