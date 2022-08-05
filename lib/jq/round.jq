def round: (if . < 0 then -1 else 1 end) as $sign | (.*$sign + 0.5) | floor * $sign;
