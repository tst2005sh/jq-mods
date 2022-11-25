def fromndjson: if type=="array" and length==1 and (first|type)=="array" and (first|length)>=1 then .[] else . end;
