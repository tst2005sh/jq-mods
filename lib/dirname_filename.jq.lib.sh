
jq_deps_dirname_filename=''
jq_function_dirname_filename='def dirname_filename:
	"/" as $sep
	|(if startswith("/") then "/" else "." end) as $left
	| sub("/+";"/")|split($sep)
	| (last) as $filename
	| (
		.[0:-1]|join($sep)|if .=="" then $left else . end
	) as $dirname
	| [ $dirname, $filename ]
;'
