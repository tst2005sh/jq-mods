
jq_deps_array_to_sqlite=''
jq_function_array_to_sqlite='
def ifquote(q): if (type=="null") then "NULL" elif (type=="string") then q else . end;
def sql_squote: "'\''\( gsub("'\''";"'\'\''") )'\''";
def sql_dquote: "\"\( gsub("\"";"\"\"") )\"";
def sql_tickquote: "`\(.)`";
def sql_brackquote: "[\(.)]";
def sql_type: ({"string":"TEXT","number":"NUMERIC","boolean":"BOOLEAN"})[type] // ("unknown sql type for json type \(type)"|error);
def schema_first_field_is_primary_key: [ (.[0]|"\(.[0]) \(.[1]) PRIMARY KEY"), (.[1:][]|"\(.[0]) \(.[1])") ];
def schema_no_primary_key: map( "\(.[0]) \(.[1])" );
def array_to_sqlite($tablename;primary):
	"PRAGMA foreign_keys=OFF;",
	"BEGIN TRANSACTION;",
	"CREATE TABLE \($tablename|sql_dquote) ( \(
		[(.[0]|map(sql_tickquote)),(.[1]|map(sql_type))]|transpose
		| primary
		| join(", ")
	) );",
	(
		.[1:]|map(
		"INSERT INTO \($tablename|sql_dquote) VALUES( \(
			map(ifquote(sql_squote)|tostring)|join(", ")
		) );"
	))[],
	"COMMIT;"
;
def array_to_sqlite: array_to_sqlite("data";schema_no_primary_key);
'
