# jqjq - jq implementation of jq
# Copyright (c) 2022 Mattias Wadman
# MIT License
# https://github.com/wader/jqjq

def _fromradix($base; tonum):
  reduce explode[] as $c (
    0;
    . * $base + ($c | tonum)
  );
def _fromhex:
  _fromradix(
    16;
    if . >= 48 and . <= 57 then .-48 # 0-9
    elif . >= 97 and . <= 102 then .-97+10 # a-f
    else .-65+10 # A-F
    end
  );

# TODO: keep track of position?
def lex:
  def _token:
    def _re($re; f):
      ( .remain
      | . as $v
      | match($re; "m").string
      | { result: f
        , remain: $v[length:]
        }
      );
    if .remain == "" then empty
    else
      (  _re("^\\s+"; {whitespace: .})
      // _re("^#[^\n]*"; {comment: .})
      // _re("^\\.[_a-zA-Z][_a-zA-Z0-9]*"; {index: .[1:]})
      // _re("^[_a-zA-Z][_a-zA-Z0-9]*"; {ident: .})
      // _re("^\\$[_a-zA-Z][_a-zA-Z0-9]*"; {binding: .})
      # 1.23, .123, 123e2, 1.23e2, 123E2, 1.23e+2, 1.23E-2 or 123
      // _re("^(?:[0-9]*\\.[0-9]+|[0-9]+)(?:[eE][-\\+]?[0-9]+)?"; {number: .})
      # match " <any non-"-or-\> or <\ + any> "
      // _re("^\"(?:[^\"\\\\]|\\\\.)*?\"";
          ( .[1:-1]
          | gsub("\\\\u(?<c>[0-9a-fA-F]{4})";
              ( .c
              | [_fromhex]
              | implode
              )
            )
          | gsub("\\\\(?<c>.)";
              ( . as {$c}
              | { "n": "\n"
                , "r": "\r"
                , "t": "\t"
                , "f": "\f"
                , "b": "\b"
                , "\"": "\""
                , "\/": "\/"
                , "\\": "\\"
                , "(": "\\(" # TODO: fix string interpolation
                }[$c]
              | if not then error("unknown escape: \\" + $c) else . end
              )
            )
          | {string: .}
          )
        )
      // _re("^==";     {equal_equal: .})
      // _re("^\\|=";   {pipe_equal: .})
      // _re("^=";      {equal: .})
      // _re("^!=";     {not_equal: .})
      // _re("^<=";     {less_equal: .})
      // _re("^>=";     {greater_equal: .})
      // _re("^\\+=";   {equal_plus: .})
      // _re("^-=";     {equal_dash: .})
      // _re("^\\*=";   {equal_star: .})
      // _re("^/=";     {equal_slash: .})
      // _re("^%=";     {equal_percent: .})
      // _re("^<";      {less: .})
      // _re("^>";      {greater: .})
      // _re("^:";      {colon: .})
      // _re("^;";      {semicolon: .})
      // _re("^\\|";    {pipe: .})
      // _re("^,";      {comma: .})
      // _re("^\\+";    {plus: .})
      // _re("^-";      {dash: .})
      // _re("^\\*";    {star: .})
      // _re("^//";     {slash_slash: .})
      // _re("^/";      {slash: .})
      // _re("^%";      {percent: .})
      // _re("^\\(";    {lparen: .})
      // _re("^\\)";    {rparen: .})
      // _re("^\\[";    {lsquare: .})
      // _re("^\\]";    {rsquare: .})
      // _re("^{";      {lcurly: .})
      // _re("^}";      {rcurly: .})
      // _re("^\\.\\."; {dotdot: .})
      // _re("^\\.";    {dot: .})
      // _re("^\\?";    {qmark: .})
      // error("unknown token: " + (.remain | tojson))
      )
    end;
  def _lex:
    ( {remain: ., result: {whitespace: ""}}
    | recurse(_token)
    | .result
    | select((.whitespace // .comment) | not)
    );
  [_lex];
