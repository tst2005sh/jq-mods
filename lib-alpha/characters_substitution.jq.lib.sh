
# name and functions need to be improved ... but it is functionnal
jq_deps_characters_substitution=''
jq_function_characters_substitution='
def with_characters(f): explode|map([.]|implode|f)|join("");
def chars_to_kv: [capture("(?<key>.)=(?<value>[^ ]+) ";"g")]|from_entries;
def characters_substitution($c):
        ($c|chars_to_kv) as $substitutions|
        with_characters($substitutions[.] // .)
;'
# Thanks to emanuele6/2022-02-09 for help (with_characters)
