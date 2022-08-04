def packby($n): 
        [range(0;length) as $i |
                if $i % $n != 0 then
                       empty
                else
                       .[$i:$i+$n]
                end
        ]
;
