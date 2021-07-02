. ./lib/dirname_filename.jq.lib.sh

jq -n "$jq_function_dirname_filename"'
(
	"foo/bar/buz" | dirname_filename == ["foo/bar","buz"]
),(
	"foo/bar/buz/zzz" | dirname_filename == ["foo/bar/buz","zzz"]
),(
	"foo/buz" | dirname_filename == ["foo","buz"]
),(
	"foo" | dirname_filename == [".","foo"]
),(
	"./foo" | dirname_filename == [".","foo"]
),(
	"/foo" | dirname_filename == ["/","foo"]
),(
	".foo" | dirname_filename == [".",".foo"]
),(
	"/.foo" | dirname_filename == ["/",".foo"]
),(
	"///foo" | dirname_filename == ["/",".foo"]
),(
	".///foo" | dirname_filename == [".",".foo"]
)'
