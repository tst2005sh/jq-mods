
jq_deps_unflatify=''
jq_option_unflatify=''
#jq_function_unflatify='def unflatify(f;$k): to_entries | group_by(.key | . != scan($k)[]) | .[-1][] |= (.key |= scan($k)[]) | map(from_entries) | .[-1] as $o | .[0] | f = $o;'
jq_function_unflatify='def unflatify(f;$k): to_entries|group_by(.key|.!= scan($k)[]) | if length==1 then first|from_entries else .[-1][]|=(.key|=scan($k)[])|map(from_entries) |.[-1] as $o |.[0] | f=$o end;'
# thanks emanuele6 !
