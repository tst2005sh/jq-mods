def fromhexstring: ascii_downcase|explode|map( if .<=57 then .-48 else .-87 end);
