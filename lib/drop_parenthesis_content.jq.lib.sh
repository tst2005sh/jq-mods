
# drop text between parenthesis
# <- foo(commenthere)bar
# -> foobar
jq_deps_drop_parenthesis_content=''
jq_function_drop_parenthesis_content='def drop_parenthesis_content(): gsub("\\([^\\(\\)]*\\)";"");'
