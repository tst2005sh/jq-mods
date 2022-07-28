def frombase($a): reduce (reverse | .[]) as $i (0; . * $a + $i);
