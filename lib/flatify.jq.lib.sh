
jq_deps_flatify=''
jq_option_flatify=''
jq_function_flatify='def flatify(f;k): del(f) + (f // {} | with_entries(.key|=k));'
