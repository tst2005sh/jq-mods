def unlinebreak(condition): (reduce .[] as $l ([]; if $l|condition then .[-1] += [$l] else . += [[$l]] end));
