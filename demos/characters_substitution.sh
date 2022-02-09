. ./lib-alpha/characters_substitution.jq.lib.sh

jq -n "$jq_function_characters_substitution"'
"Hélène et François" | characters_substitution("à=a ç=c é=e è=e ") == "Helene et Francois"
'

