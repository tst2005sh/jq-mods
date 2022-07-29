
jq_deps_unsorted_unique_by=''
jq_function_unsorted_unique_by='def unsorted_unique_by(f): to_entries|unique_by(.value|f)|sort_by(.key)|map(.value);'
