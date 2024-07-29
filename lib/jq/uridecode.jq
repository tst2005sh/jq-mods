# code from: https://github.com/wader/jqjq
def _fromradix($base; tonum):
  reduce explode[] as $c (
    0;
    . * $base + ($c | tonum)
  );
# code from: https://github.com/wader/jqjq
def _fromhex:
  _fromradix(
    16;
    if . >= 48 and . <= 57 then .-48 # 0-9
    elif . >= 97 and . <= 102 then .-97+10 # a-f
    else .-65+10 # A-F
    end
  );

# cde modified
def uridecode:
	gsub("%(?<c>[0-9a-fA-F]{2})";
		( .c
		| [_fromhex]
		| implode
		)
	);
