# on peut traiter plusieurs types de donnes en entré
# 1. object		: no-conv : direct filter once ; the access is .value or the custom one
# 2. array of object	: no-conv : 			 the access is .value or the custom one
# 3. array of value	: convert to a list of object (use to_entries) the access is .value
# 3b.			: we should just use map_values and access '.' but we can not be compatible with .value access 

jq_function_grep='

def greplike_direct($pat;$testflags;PRE;INVERT):
	select( PRE|((type!="string") or (test($pat;$testflags)|INVERT) ))
;

def greplike($pat;$testflags;PRE;INVERT):
	if (type!="array") then
		greplike_direct($pat;$testflags;PRE;INVERT) # [1]

	elif ((first?|type)=="object") then
		map(greplike_direct($pat;$testflags;PRE;INVERT)) # [2]

	else
		with_entries2(greplike_direct($pat;$testflags;PRE;INVERT)) #[3]
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
'
#deps:with_entries2
