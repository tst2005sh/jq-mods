
jq_deps_walk=''
# source: https://github.com/stedolan/jq/blob/jq-1.6/src/builtin.jq#L273-L280
jq_function_walk='# Apply f to composite entities recursively, and to atoms
def walk(f):
  . as $in
  | if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;'
