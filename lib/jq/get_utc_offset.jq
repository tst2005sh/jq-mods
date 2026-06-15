def get_utc_offset:
{"hz":strftime("%H"),"mz":strftime("%M"),"hl":strflocaltime("%H"),"ml":strflocaltime("%M")}|map_values(tonumber)
|[(.hl-.hz),(.ml-.mz)]| (first|if .<0 then "-" else "" end)+(map( fabs|tostring|lpad(2;"0") )|add)
;
