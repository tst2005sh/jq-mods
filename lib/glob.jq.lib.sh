jq_deps_glob="glob_to_re"
jq_function_glob='def glob($g): test("^"+($g|glob_to_re)+"$");'
