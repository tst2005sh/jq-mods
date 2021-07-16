
jq_deps_array_to_sqlite=''
jq_function_array_to_sqlite='
def ifquote(q): if (type=="null") then "NULL" elif (type=="string") then q else . end;
def sql_squote: "'\''\( gsub("'\''";"'\'\''") )'\''";
def sql_dquote: "\"\( gsub("\"";"\"\"") )\"";
def sql_tickquote: "`\(.)`";
def sql_brackquote: "[\(.)]";
def array_to_sqlite($tablename):
	"PRAGMA foreign_keys=OFF;",
	"BEGIN TRANSACTION;",
	"CREATE TABLE \($tablename|sql_dquote) ( \(
		first |
			[ (first|"\(sql_tickquote) text PRIMARY KEY"), (.[1:][]|"\(sql_tickquote) text")]
		|join(", ")
	) );",
	(
		.[1:]|map(
		"INSERT INTO \($tablename|sql_dquote) VALUES( \(
			map(ifquote(sql_squote))|join(", ")
		) );"
	))[],
	"COMMIT;"
;
def array_to_sqlite: array_to_sqlite("data");
'
