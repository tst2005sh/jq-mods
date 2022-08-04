def greplike_direct($pat;$testflags;PRE;INVERT):
	select( PRE|((type!="string") or (test($pat;$testflags)|INVERT) ))
;

def greplike($pat;$testflags;PRE;INVERT):
	if (type!="array") then
		greplike_direct($pat;$testflags;PRE;INVERT) # [1]

	elif ((first?|type)=="object") then
		map(greplike_direct($pat;$testflags;PRE;INVERT)) # [2]

	else
		with_kv(greplike_direct($pat;$testflags;PRE;INVERT)) #[3]
		#map(greplike_direct($pat;$testflags;.;INVERT)) # [3b]
	end
;
def grepv($pat): greplike($pat;"";.value;not);
def grepv($pat;PRE): greplike($pat;"";PRE;not);

def igrepv($pat): greplike($pat;"i";.value;not);
def igrepv($pat;PRE): greplike($pat;"i";PRE;not);

def grep($pat): greplike($pat;"";.value;.);
def grep($pat;PRE): greplike($pat;"";PRE;.);

def igrep($pat): greplike($pat;"i";.value;.);
def igrep($pat;PRE): greplike($pat;"i";PRE;.);
