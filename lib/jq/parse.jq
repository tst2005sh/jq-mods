# jqjq - jq implementation of jq
# Copyright (c) 2022 Mattias Wadman
# MIT License
# https://github.com/wader/jqjq

#def debug(f): . as $c | f | debug | $c;

def parse:
  def _consume(f): select(.[0] | f) | .[1:];
  def _optional(f):
    ( f
    // [., null]
    );
  def _repeat(f):
    def _f:
      ( f as [$rest, $v]
      | [$rest, $v]
      , ( $rest
        | _f
        )
      );
    ( . as $c
    | [_f]
    | if length > 0 then [.[-1][0], map(.[1])]
      else [$c, []]
      end
    );
  def _keyword($name): _consume(.ident == $name);

  def _p($type):
    # based on:
    # https://www.engr.mun.ca/~theo/Misc/exp_parsing.htm#climbing
    # filter is used to disable operators, ex in keyval query
    def _op_prec_climb($p; filter):
      def _ops:
        if filter then false
        elif .pipe then           {prec: 0, name: "|",   assoc: "right"}
        # TODO: understand why jq has left associativity for "," but right seems to give correct parse tree
        elif .comma then          {prec: 1, name: ",",   assoc: "right"}
        elif .slash_slash then    {prec: 2, name: "//",  assoc: "right"}
        elif .equal then          {prec: 3, name: "=",   assoc: "none"}
        elif .pipe_equal then     {prec: 3, name: "|=",  assoc: "none"}
        elif .equal_plus then     {prec: 3, name: "+=",  assoc: "none"}
        elif .equal_dash then     {prec: 3, name: "-=",  assoc: "none"}
        elif .equal_star then     {prec: 3, name: "*=",  assoc: "none"}
        elif .equal_slash then    {prec: 3, name: "/=",  assoc: "none"}
        elif .equal_percent then  {prec: 3, name: "%=",  assoc: "none"}
        elif .ident == "or" then  {prec: 4, name: "or",  assoc: "left"}
        elif .ident == "and" then {prec: 5, name: "and", assoc: "left"}
        elif .equal_equal then    {prec: 6, name: "==",  assoc: "none"}
        elif .not_equal then      {prec: 6, name: "!=",  assoc: "none"}
        elif .less then           {prec: 6, name: "<",   assoc: "none"}
        elif .less_equal then     {prec: 6, name: "<=",  assoc: "none"}
        elif .greater then        {prec: 6, name: ">",   assoc: "none"}
        elif .greater_equal then  {prec: 6, name: ">=",  assoc: "none"}
        elif .plus then           {prec: 7, name: "+",   assoc: "left"}
        elif .dash then           {prec: 7, name: "-",   assoc: "left"}
        elif .star then           {prec: 8, name: "*",   assoc: "left"}
        elif .slash then          {prec: 8, name: "/",   assoc: "left"}
        elif .percent then        {prec: 8, name: "%",   assoc: "left"}
        else false
        end;

      ( _p("query1") as [$rest, $t]
      | $rest
      | def _f($t):
          ( .[0] as $next # peek next
          | ($next | _ops) as $next_op
          | if $next_op and $next_op.prec >= $p then
              ( .[1:] # consume
              | ( if $next_op.assoc == "right" then
                    _op_prec_climb($next_op.prec; filter)
                  elif $next_op.assoc == "left" then
                    _op_prec_climb($next_op.prec+1; filter)
                  else
                    # TODO: none associativity, 1 == 2 == 3 etc, should be error
                    _op_prec_climb($next_op.prec+1; filter)
                  end
                ) as [$rest, $t1]
              | $rest
              # TODO: better way?
              # if functions was defined for the left side they should be
              # move to the op itself to also be available on the right side
              # ex: def f: 123; 1 + f
              | $t as {$func_defs}
              | _f(
                  ( { op: $next_op.name
                    , left: ($t | del(.func_defs))
                    , right: $t1
                    }
                  | if $func_defs then
                      .func_defs = $func_defs
                    else .
                    end
                  )
                )
              )
            else
              [., $t]
            end
          );
        _f($t)
      );

    # {<keyval>...} where keyval is:
    # name
    # "name"
    # $name
    # name: <term>
    # "name": <term>
    # <subquery>: <term>
    def _object:
      ( _consume(.lcurly)
      | _repeat(
          # TODO:
          # string interpolated key
          #   {"\(...)"} -> {"\(...)"": .["\(...)"]}
          #   {"\(...)": ...} -> {"\(...)"": ...}
          # multi query val:
          #    term | ...
          ( ( def _colon_val:
                ( _consume(.colon)
                # keyval_query only allows | operator (, is separator)
                | _p("keyval_query") as [$rest, $val]
                | $rest
                | [ .
                  , { queries: [$val]
                    }
                  ]
                );
              (
                # {a} -> {a: .a}
                # {a: ...} -> {a: ...}
                ( .[0] as $ident
                | _consume(.ident)
                | _optional(_colon_val) as [$rest, $val]
                | $rest
                | [ .
                  , { key: $ident.ident
                    , val: $val
                    }
                  ]
                )
              //
                # {"a"} -> {a: .a}
                # {"a": ...} -> {a: ...}
                ( _p("string") as [$rest, $string]
                | $rest
                | _optional(_colon_val) as [$rest, $val]
                | $rest
                | [ .
                  , { key_string:
                        { str: $string.term.str
                        }
                    , val: $val
                    }
                  ]
                )
              //
                # {$a} -> {a: $a}
                ( .[0] as $binding
                | _consume(.binding)
                | [ .
                  , { key: $binding.binding
                    }
                  ]
                )
              //
                # {(...): ...} -> {...: ...}
                ( _p("subquery") as [$rest, $query]
                | $rest
                | _colon_val as [$rest, $val]
                | $rest
                | [ .
                  , { key_query: $query
                    , val: $val
                    }
                  ]
                )
              )
            ) as [$rest, $key_vals]
          | $rest
          | _optional(
              # TODO: _one() etc?
              ( _consume(.comma)
              | [., null]
              )
            ) as [$rest, $_]
          | [$rest, $key_vals]
          )
        ) as [$rest, $key_vals]
      | $rest
      | _consume(.rcurly)
      | [ .
        , { term:
              { type: "TermTypeObject"
              , object:
                  { key_vals: $key_vals
                  }
              }
          }
        ]
      );

    # destructing pattern:
    # pattern is:
    # $name
    # name: pattern
    # "name": pattern
    # "\(...)": pattern
    # (query): pattern
    # [pattern, ...]
    def _pattern:
      ( ( _consume(.lcurly)
        | _repeat(
            ( ( def _colon_pattern:
                  ( _consume(.colon)
                  | _p("pattern") as [$rest, $pattern]
                  | $rest
                  | [ .
                    , $pattern
                    ]
                  );
                (
                  # {a} -> {a: .a}
                  # {a: ...} -> {a: ...}
                  ( .[0] as $ident
                  | _consume(.ident)
                  | _optional(_colon_pattern) as [$rest, $val]
                  | $rest
                  | [ .
                    , { key: $ident.ident
                      , val: $val
                      }
                    ]
                  )
                //
                  # {"a"} -> {a: .a}
                  # {"a": ...} -> {a: ...}
                  ( _p("string") as [$rest, $string]
                  | $rest
                  | _optional(_colon_pattern) as [$rest, $val]
                  | $rest
                  | [ .
                    , { key_string:
                          { str: $string.term.str
                          }
                      , val: $val
                      }
                    ]
                  )
                //
                  # {$a} -> {a: $a}
                  ( .[0] as $binding
                  | _consume(.binding)
                  | [ .
                    , { key: $binding.binding
                      }
                    ]
                  )
                //
                  # {(...): ...} -> {...: ...}
                  ( _p("subquery") as [$rest, $query]
                  | $rest
                  | _colon_pattern as [$rest, $val]
                  | $rest
                  | [ .
                    , { key_query: $query
                      , val: $val
                      }
                    ]
                  )
                )
              ) as [$rest, $key_patterns]
            | $rest
            | _optional(
                # TODO: _one() etc?
                ( _consume(.comma)
                | [., null]
                )
              ) as [$rest, $_]
            | [$rest, $key_patterns]
            )
          ) as [$rest, $key_patterns]
        | $rest
        | _consume(.rcurly)
        | [ .
          , {object: $key_patterns}
          ]
        )
      //
        ( _consume(.lsquare)
        | _repeat(
            ( _p("pattern") as [$rest, $pattern]
            | $rest
            | _optional(
                # TODO: _one() etc?
                ( _consume(.comma)
                | [., null]
                )
              ) as [$rest, $_]
            | [$rest, $pattern]
            )
          ) as [$rest, $pattern]
        | $rest
        | _consume(.rsquare)
        | [ .
          , {array: $pattern}
          ]
        )
      //
        ( .[0] as $binding
        | _consume(.binding)
        | [ .
          , {name: $binding.binding}
          ]
        )
      );

    # (<query>)
    def _subquery:
      ( _consume(.lparen)
      | _p("query") as [$rest, $query]
      | $rest
      | _consume(.rparen)
      | [ .
        , { term:
              { type: "TermTypeQuery",
                query: $query
              }
          }
        ]
      );

    # ident
    # ident(<query>[;...])
    def _func:
      ( . as [$first]
      | _consume(.ident)
      | ( _consume(.lparen)
        | _repeat(
            ( _p("query") as [$rest, $arg]
            | $rest
            | _optional(
                # TODO: _one() etc?
                ( _consume(.semicolon)
                | [., null]
                )
              ) as [$rest, $_]
            | [$rest, $arg]
            )
          ) as [$rest, $args]
        | $rest
        | _consume(.rparen)
        | [ .
          , { term:
                { type: "TermTypeFunc"
                , func:
                    { name: $first.ident
                    , args: $args
                    }
                }
            }
          ]
        )
        //
          [ .
          , { term:
                { type: "TermTypeFunc"
                , func:
                    { name: $first.ident
                    }
                }
            }
          ]
      );

    # $name
    def _binding:
      ( . as [$first]
      | _consume(.binding)
      | [ .
        , { term:
              { type: "TermTypeFunc"
              , func:
                  { name: $first.binding
                  }
              }
          }
        ]
      );

    # [<query>]
    def _array:
      ( _consume(.lsquare)
      | _optional(_p("query")) as [$rest, $query]
      | $rest
      | _consume(.rsquare)
      | [ .
        , { term:
              { type: "TermTypeArray",
                array:
                  { query: $query
                  }
              }
          }
        ]
      );

    # reduce <term> as <binding> (<start-query>;<update-query>)
    def _reduce:
      ( _keyword("reduce")
      | _p("term") as [$rest, $term]
      | $rest
      | _keyword("as")
      | _p("pattern") as [$rest, $pattern]
      | $rest
      | _consume(.lparen)
      | _p("query") as [$rest, $start]
      | $rest
      | _consume(.semicolon)
      | _p("query") as [$rest, $update]
      | $rest
      | _consume(.rparen)
      | [ .
        , { term:
            { type: "TermTypeReduce"
            , reduce:
              { term: $term.term
              , pattern: $pattern
              , start: $start
              , update: $update
              }
            }
          }
        ]
      );

    # foreach <term> as <binding> (<start-query>;<update-query>[;<extract-query>])
    def _foreach:
      ( _keyword("foreach")
      | _p("term") as [$rest, $term]
      | $rest
      | _keyword("as")
      | _p("pattern") as [$rest, $pattern]
      | $rest
      | _consume(.lparen)
      | _p("query") as [$rest, $start]
      | $rest
      | _consume(.semicolon)
      | _p("query") as [$rest, $update]
      | $rest
      | _optional(
          ( _consume(.semicolon)
          | _p("query")
          )
        ) as [$rest, $extract]
      | $rest
      | _consume(.rparen)
      | [ .
        , { term:
            { type: "TermTypeForeach"
            , foreach:
                ( { term: $term.term
                  , pattern: $pattern
                  , start: $start
                  , update: $update
                  }
                | if $extract then .extract = $extract else . end
                )
            }
          }
        ]
      );

    # if <cond> then <expr>
    # [elif <cond> then <expr>]*
    # [else expr]?
    # end
    def _if:
      ( _keyword("if")
      | _p("query") as [$rest, $cond]
      | $rest
      | _keyword("then")
      | _p("query") as [$rest, $then_]
      | $rest
      | _repeat(
          ( _keyword("elif")
          | _p("query") as [$rest, $cond]
          | $rest
          | _keyword("then")
          | _p("query") as [$rest, $then_]
          | $rest
          | [., {cond: $cond, then: $then_}]
          )
        ) as [$rest, $elif_]
      | $rest
      | _optional(
          ( _keyword("else")
          | _p("query")
          )
        ) as [$rest, $else_]
      | $rest
      | _keyword("end")
      | [ .
        , { term:
              { type: "TermTypeIf"
              , if:
                  ( { cond: $cond
                    , then: $then_
                    , else: $else_
                    }
                  | if ($elif_ | length) > 0 then .elif = $elif_
                    else .
                    end
                  )
              }
          }
        ]
      );

    # def a: ...;
    # def a(f) ...;
    # def a(f; $v) ...;
    def _func_defs:
      _repeat(
        ( _keyword("def")
        | . as [{ident: $name}]
        | _consume(.ident)
        | ( ( _consume(.lparen)
            | _repeat(
                ( .[0] as $arg
                | ( ( _consume(.ident)
                    | [., $arg.ident]
                    )
                  //
                    ( _consume(.binding)
                    | [., $arg.binding]
                    )
                  ) as [$rest, $arg]
                | $rest
                | ( _consume(.semicolon)
                  // .
                  )
                | [., $arg]
                )
              ) as [$rest, $args]
            | $rest
            | _consume(.rparen)
            | _consume(.colon)
            | _p("query") as [$rest, $body]
            | $rest
            | _consume(.semicolon)
            | [ .
              , { name: $name
                , args: $args
                , body: $body
                }
              ]
            )
          //
            ( _consume(.colon)
            | _p("query") as [$rest, $body]
            | $rest
            | _consume(.semicolon)
            | [ .
              , { name: $name
                , body: $body
                }
              ]
            )
          )
        )
      );

    # []
    # [<query>]
    # .name
    # ."name"
    # ?
    # as $v | <query>
    def _suffix:
      (
        # [] iter
        ( _consume(.lsquare)
        | _consume(.rsquare)
        | [., {iter: true}]
        )
      //
        # [...] query
        ( _consume(.lsquare)
        | _p("query") as [$rest, $start]
        | $rest
        | _consume(.rsquare)
        | [ .
          , { index:
                {start: $start}
            }
          ]
        )
      //
        # [...:...]
        # [:...]
        # [...:]
        ( _consume(.lsquare)
        | _optional(_p("query")) as [$rest, $start]
        | $rest
        | _consume(.colon)
        | _optional(_p("query")) as [$rest, $end_]
        | $rest
        | _consume(.rsquare)
        # fail if both missing
        | if $start == null and $end_ == null then empty else . end
        | [ .
          , { index:
                ( {is_slice: true}
                | if $start then .start = $start else . end
                | if $end_ then .end = $end_ else . end
                )
            }
          ]
        )
      //
        # .name index
        ( .[0] as $index
        | _consume(.index)
        | [ .
          , { index:
                { name: $index.index
                }
            }
          ]
        )
      //
        # ."name" index
        ( _consume(.dot)
        | _p("string") as [$rest, $string]
        | $rest
        | [ .
          , { index:
                { str:
                    { str: $string.term.str
                    }
                }
            }
          ]
        )
      //
        # ? optional (try)
        ( _consume(.qmark)
        | [ .
          , {optional: true}
          ]
        )
      //
        ( _keyword("as")
        | _p("pattern") as [$rest, $pattern]
        | $rest
        | _consume(.pipe)
        | _p("query") as [$rest, $body]
        | $rest
        | [ .
          , { bind:
                { body: $body
                , patterns: [$pattern]
                }
              }
          ]
        )
      );

    # .
    def _identity:
      ( _consume(.dot)
      | [ .
        , { term:
              { type: "TermTypeIdentity"
              }
          }
        ]
      );

    # .[<query>]
    # .[<query>:<query>]
    # .name
    # ."name"
    # TODO: share with _suffix? tricky because of leading dot
    def _index:
      ( ( _consume(.dot)
        | _consume(.lsquare)
        | _p("query") as [$rest, $query]
        | $rest
        | _consume(.rsquare)
        | [ .
          , { term:
                { type: "TermTypeIndex"
                , index:
                  { start: $query
                  }
              }
            }
          ]
        )
      //
        ( _consume(.dot)
        | _consume(.lsquare)
        | _optional(_p("query")) as [$rest, $start]
        | $rest
        | _consume(.colon)
        | _optional(_p("query")) as [$rest, $end_]
        | $rest
        | _consume(.rsquare)
        # fail is both missing
        | if $start == null and $end_ == null then empty else . end
        | [ .
          , { term:
                { type: "TermTypeIndex"
                , index:
                    ( {is_slice: true}
                    | if $start then .start = $start else . end
                    | if $end_ then .end = $end_ else . end
                    )
                }
            }
          ]
        )
      //
        ( .[0] as $index
        | _consume(.index)
        | [ .
          , { term:
                { type: "TermTypeIndex"
                , index:
                  { name: $index.index
                  }
                }
            }
          ]
        )
      //
        # ."name" index
        ( _consume(.dot)
        | _p("string") as [$rest, $string]
        | $rest
        | [ .
          , { term:
                { type: "TermTypeIndex"
                , index:
                    { str:
                        { str: $string.term.str
                        }
                    }
                }
            }
          ]
        )
      );

    # try <query>
    # try <query> catch <query>
    # TODO: query should not allow |?
    def _try:
      ( _keyword("try")
      | _p("query") as [$rest, $body]
      | $rest
      | _optional(
          ( _keyword("catch")
          | _p("query")
          )
        ) as [$rest, $catch_]
      | $rest
      | [ .
        , { term:
            { type: "TermTypeTry"
            , try:
                ( { body: $body
                  }
                | if $catch_ then .catch = $catch_ else . end
                )
            }
          }
        ]
      );

    # +<term> etc
    def _unary_op(f; $op):
      ( _consume(f)
      | _p("term") as [$rest, $term]
      | $rest
      | [ .
        , { term:
              { type: "TermTypeUnary"
              , unary:
                 { op: $op
                 , term: $term.term
                 }
              }
          }
        ]
      );

    # ..
    # transform .. into recurse call
    def _recurse:
      ( _consume(.dotdot)
      | [ .
        , { term:
              { type: "TermTypeFunc"
              , func:
                 { name: "recurse"
                 }
              }
          }
        ]
      );

    def _scalar($type; c; f):
      ( . as [$first]
      | _consume(c)
      | [ .
        , { term:
              ( $first
              | f
              | .type = $type
              )
          }
        ]
      );

    ( .# debug({_p: $type})
    | if $type == "query" then
        # query1, used by _op_prec_climb, exist to fix infinite recursion
        _op_prec_climb(0; false)
      elif $type == "keyval_query" then
        # keyval query only allows | operator
        _op_prec_climb(0; .pipe | not)
      elif $type == "query1" then
        ( _p("func_defs") as [$rest, $func_defs]
        | $rest
        | ( if length == 0 then
              [., {term: {type: "TermTypeIdentity"}}]
            else
              _p("term")
            end
          ) as [$rest, $query]
        | $query
        | if ($func_defs | length) > 0 then
            .func_defs = $func_defs
          else .
          end
        | [$rest, .]
        )
      elif $type == "term" then
        # "keyword" ident parsing first
        ( ( _p("if")
          // _p("reduce")
          // _p("foreach")
          // _p("try")
          // _p("true")
          // _p("false")
          // _p("null")
          // _p("func")
          // _p("number")
          // _p("string")
          // _p("array")
          // _p("subquery") # TODO: rename?
          // _p("object")
          // _p("index") #.name
          // _p("identity") # .
          // _p("binding")
          // _p("unary_plus")
          // _p("unary_minus")
          // _p("recurse") # ".."
          ) as [$rest, $term]
        | $rest
        | _repeat(_p("suffix")) as [$rest, $suffix_list]
        | $rest
        | [ .
          , ( $term
            | if ($suffix_list | length) > 0 then
                .term.suffix_list = $suffix_list
              else .
              end
            )
          ]
        )
      elif $type == "suffix" then _suffix
      elif $type == "if" then _if
      elif $type == "func_defs" then _func_defs
      elif $type == "true" then _scalar("TermTypeTrue"; .ident == "true"; .)
      elif $type == "false" then _scalar("TermTypeFalse"; .ident == "false"; .)
      elif $type == "null" then _scalar("TermTypeNull"; .ident == "null"; .)
      elif $type == "number" then _scalar("TermTypeNumber"; .number; {number: .number})
      elif $type == "string" then _scalar("TermTypeString"; .string; {str: .string})
      elif $type == "index" then _index
      elif $type == "identity" then _identity
      elif $type == "array" then _array
      elif $type == "object" then _object
      elif $type == "subquery" then _subquery
      elif $type == "func" then _func
      elif $type == "binding" then _binding
      elif $type == "reduce" then _reduce
      elif $type == "foreach" then _foreach
      elif $type == "try" then _try
      elif $type == "unary_plus" then _unary_op(.plus; "+")
      elif $type == "unary_minus" then _unary_op(.dash; "-")
      elif $type == "recurse" then _recurse
      elif $type == "pattern" then _pattern
      else error("unknown type " + $type)
      end
    );
  ( ( _p("query")
    | if .[0] != [] then error("tokens left: " + tojson) else . end
    | .[1]
    )
  // error("parse error: " + tojson)
  );
