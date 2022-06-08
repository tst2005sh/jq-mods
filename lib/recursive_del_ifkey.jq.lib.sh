
jq_deps_recursive_del_ifkey=''
jq_function_recursive_del_ifkey='def recursive_del_ifkey(f): delpaths([paths|select(last|strings|f)]);'

# 11:49:48 <    geirha> and a recursive version  delpaths([paths|select(last|endswith("_count"))])

# 13:34:27 <    geirha> one quickfix, since the *_count keys are always scalars in your case, is to change paths to paths(scalars)
# 13:34:47 < emanuele6> or you could replace last|f with any(f?)
# 13:36:38 < emanuele6> ( or last|f? )
# 13:37:23 <    geirha> or last|tostring|f
# 13:38:57 <    geirha> but then you won't be able to distinguish between a key "5" and index 5
# 13:44:13 < emanuele6> it depends on how you want the function to work
# ...
# 14:01:35 < emanuele6> but wouldn't strings/0 make more sense than tostring/0 in that case?
