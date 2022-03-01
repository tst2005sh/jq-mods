
jq_deps_unique_no_sort_by=''
jq_function_unique_no_sort_by='def unique_no_sort_by(f): to_entries|unique_by(.value|f)|sort_by(.key)|map(.value);'
