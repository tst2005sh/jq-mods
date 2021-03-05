jq_function_without='
def without($pat;$keyname): select(if (.[$keyname]|test($pat)) then empty else . end);
def without($pat): without($pat;"value");
'
