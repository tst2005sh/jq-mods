# drop text between parenthesis
# <- foo(commenthere)bar
# -> foobar
jq_function_drop_parenthesis_content='def drop_parenthesis_content(): gsub("\\([^\\(\\)]*\\)";"");'
#deps:none
