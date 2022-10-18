def colorname2ansicolorseqOLD:
	({	"reset":		"\u001b[0m"
	,	"-":			"\u001b[0m"
	,	"red":			"\u001b[31m"
	,	"yellow":		"\u001b[33m"
	,	"blue":			"\u001b[34m"
	,	"b_yellow":		"\u001b[1;33m"
	,	"bg_green+black":	"\u001b[30;42m"
	,	"bg_hi_black+white":	"\u001b[37;100m"
	,	"bold+bg_blue":		"\u001b[1;44m"
	# P0-P6:
	,	"bold+black":		"\u001b[1;30m"
	,	"b+red":		"\u001b[1;31m"
	,	"b+purple":		"\u001b[1;35m"
	,	"b+yellow":		"\u001b[1;33m"
	,	"cyan":			"\u001b[36m"
	,	"bg+blue":		"\u001b[44m"
	,	"green":		"\u001b[32m"
	# ERROR
	,	"bold+yellow+bg_red":	"\u001b[1;33;41m"
#	,	"bold+red+bg_yellow":	"\u001b[1;31;43m"
	,	"":			""		# nothing
	})[.]? //""
;
def ansicolor_name_to_value:
	({	"reset":		"0"
	,	"-":			"0"
	,	"b":			"1"
	,	"bold":			"1"
	,	"black":		"30"
	,	"red":			"31"
	,	"green":		"32"
	,	"yellow":		"33"
	,	"blue":			"34"
	,	"purple":		"35"
	,	"cyan":			"36"
	,	"white":		"37"
	,	"bg_hi_black":		"100"
	,	"bg_red":		"41"
	,	"bg_green":		"42"
	,	"bg_yellow":		"43"
	,	"bg_blue":		"44"
	,	"":			""
	})[.]? //empty
;
def colorname2ansicolorseq:
	split("+")|map(ansicolor_name_to_value)|join(";")|"\u001b[\(.)m"
;
def ansicolor($withcolor):
	map(
		if type=="array" then
			ansicolor($withcolor)
		elif type=="object" then
			if (.color?) then
				if ($withcolor?) then
					(.color|colorname2ansicolorseq? //"")
				else
					""
				end
			elif (.string?) then
				.string
			else
				("ERROR:"+tostring)
			end
		elif type=="number" then
			tostring
		else
			.
		end
	)|flatten |join("")
;
def ansi_calculate_len:
	flatten|map(
		if type=="object" then empty else length end
	)|add
;
def ansicolor:
	ansicolor(true)
;
