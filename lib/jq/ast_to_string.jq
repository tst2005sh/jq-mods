def ast_to_string:
	def _f:
		( . as {term: {type: $type}, $op, $func_defs}
		|if $func_defs then
			$func_defs|map(
				if .args then
					"def \(.name)(\( .args|join(";") )):\(.body|[_f]|join(" # "));"
				else
					"def \(.name):\(.body|_f);"
				end
			)|join("")
		else empty
		end,
		if $type then
			(	# . as $input |
				if $type == "TermTypeNull" then "null"
				elif $type == "TermTypeNumber" then .term.number | tostring
				elif $type == "TermTypeString" then .term.str | tojson
				elif $type == "TermTypeTrue" then "true"
				elif $type == "TermTypeFalse" then "false"
				elif $type == "TermTypeIdentity" then "."
				elif $type == "TermTypeIndex" then "[TODO]"
				elif $type == "TermTypeFunc" then
					.term.func|
					if .args // [] | length <= 0 then
						"\(.name)"
					else
						"\(.name)(\( .args|map([_f]|join("") )|join(";") ))"
					end	
				elif $type == "TermTypeObject" then
					( .term.object.key_vals[]
					| debug
					| "{"
					, ( .key # TODO: string
						, ( if .val.queries then
									( ": "
									, .val.queries | map(_f) | join(", ") # TODO: ()?
									)
								else empty
								end
							)
						)
					/" ", "}"
					)
				elif $type == "TermTypeArray" then	"[", (.term.array.query | _f), "]"
				elif $type == "TermTypeIf" then
					.term.if
					| if .elif then
						([.cond,.then,.else]|map(ast_to_string))
						+[.elif|map(
								[.cond,.then]|map(ast_to_string)|" elif \(.[0]) then \(.[1])"
							)|join("")
						]|"if \(.[0]) then \(.[1])\(.[3]) else \(.[2]) end"
					else
						[.cond,.then,.else]|map(ast_to_string)|"if \(.[0]) then \(.[1]) else \(.[2]) end"
					end
				elif $type == "TermTypeReduce" then "reduce"
				elif $type == "TermTypeForeach" then "foreach"
				elif $type == "TermTypeQuery" then "(", (.term.query | _f), ")"
				else error("unsupported term: \(.)")
				end
			# | if $query.term.suffix_list then _suffix_list($input; $path)
			#	else .
			#	end
			)
		elif $op then
			( (if $op | . == "," then "" else " " end) as $pad
			| (.left | _f)
#			, $pad
			, "\($op)"
#			, " "
			, (.right | _f)
			)
		else error("unsupported query: \(.)")
		end
	);
	[_f] | join("")
;
