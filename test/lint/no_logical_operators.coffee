module.exports = class NoLogicalOperators
  rule:
    name:     'no_logical_operators'
    level:    'error'
    message:  'Logical operators are forbidden'
    description: """
      This rule checks that logical operators are not in use.
      Instead we prefer to use 'is' 'isnt' 'not' 'or' 'and'
      over '==' '!=' '!' '||' '&&'
      """

  tokens: ['COMPARE', 'UNARY', 'LOGIC']
  lintToken: (token, tokenApi) ->
    actual_token = tokenApi.lines[tokenApi.lineNumber][token[2].first_column..token[2].last_column]
    err = context:
      switch actual_token
        when '==' then 'Replace "==" with "is"'
        when '!=' then 'Replace "!=" with "isnt"'
        when '!'  then 'Replace "!" with "not"'
        when '||' then 'Replace "|| with "or"'
        when '&&' then 'Replace "&&" with "and"'
        else undefined
    return (err if err.context?)
