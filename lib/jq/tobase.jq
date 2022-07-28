def tobase($a): [while(. > 0; (. / $a) | floor) % $a]|if .==[] then [0] else . end;
