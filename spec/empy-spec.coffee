describe "EmPy grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-python")
      atom.packages.activatePackage("language-empy")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.empy")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.empy"

  it "tokenizes comment line", ->
    {tokens} = grammar.tokenizeLine('@# comment')

    expect(tokens[0]).toEqual value: '@# comment', scopes: ['source.empy', 'comment.empy']

  it "tokenizes block of statements", ->
    {tokens} = grammar.tokenizeLine('@{print("foo")}')

    expect(tokens[0]).toEqual value: '@{', scopes: ['source.empy', 'storage.type.statement.empy']
    expect(tokens[1]).toEqual value: 'print', scopes: ['source.empy', 'keyword.other.python']
    expect(tokens[2]).toEqual value: '(', scopes: ['source.empy']
    expect(tokens[3]).toEqual value: '"', scopes: ['source.empy', 'string.quoted.double.single-line.python', 'punctuation.definition.string.begin.python']
    expect(tokens[4]).toEqual value: 'foo', scopes: ['source.empy', 'string.quoted.double.single-line.python']
    expect(tokens[5]).toEqual value: '"', scopes: ['source.empy', 'string.quoted.double.single-line.python', 'punctuation.definition.string.end.python']
    expect(tokens[6]).toEqual value: ')', scopes: ['source.empy']
    expect(tokens[7]).toEqual value: '}', scopes: ['source.empy', 'storage.type.statement.empy']

  it "tokenizes control structure", ->
    {tokens} = grammar.tokenizeLine('@[if False]')

    expect(tokens[0]).toEqual value: '@[', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'if', scopes: ['source.empy', 'keyword.control.conditional.python']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.empy']
    expect(tokens[3]).toEqual value: 'False', scopes: ['source.empy', 'constant.language.python']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[end if]')

    expect(tokens[0]).toEqual value: '@[end ', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'if', scopes: ['source.empy', 'keyword.control.conditional.python']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[for _ in range(2)]')

    expect(tokens[0]).toEqual value: '@[', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'for', scopes: ['source.empy', 'keyword.control.repeat.python']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.empy']
    expect(tokens[3]).toEqual value: '_', scopes: ['source.empy']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.empy']
    expect(tokens[5]).toEqual value: 'in', scopes: ['source.empy', 'keyword.operator.logical.python']
    expect(tokens[6]).toEqual value: ' ', scopes: ['source.empy']
    expect(tokens[7]).toEqual value: 'range', scopes: ['source.empy', 'meta.function-call.python', 'support.function.builtin.python']
    expect(tokens[8]).toEqual value: '(', scopes: ['source.empy', 'meta.function-call.python', 'punctuation.definition.arguments.begin.python']
    expect(tokens[9]).toEqual value: '2', scopes: ['source.empy', 'meta.function-call.python', 'meta.function-call.arguments.python', 'constant.numeric.integer.decimal.python']
    expect(tokens[10]).toEqual value: ')', scopes: ['source.empy', 'meta.function-call.python', 'punctuation.definition.arguments.end.python']
    expect(tokens[11]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[end for]')

    expect(tokens[0]).toEqual value: '@[end ', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'for', scopes: ['source.empy', 'keyword.control.repeat.python']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[while True]')

    expect(tokens[0]).toEqual value: '@[', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'while', scopes: ['source.empy', 'keyword.control.repeat.python']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.empy']
    expect(tokens[3]).toEqual value: 'True', scopes: ['source.empy', 'constant.language.python']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[end while]')

    expect(tokens[0]).toEqual value: '@[end ', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'while', scopes: ['source.empy', 'keyword.control.repeat.python']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

  it "tokenizes expression", ->
    {tokens} = grammar.tokenizeLine('@(expression)')

    expect(tokens[0]).toEqual value: '@(', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'expression', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: ')', scopes: ['source.empy', 'storage.type.control.empy']

  it "tokenizes simple expression", ->
    {tokens} = grammar.tokenizeLine('@simple_expression')

    expect(tokens[0]).toEqual value: '@', scopes: ['source.empy', 'comment']
    expect(tokens[1]).toEqual value: 'simple_expression', scopes: ['source.empy', 'variable.parameter.function.python']

  it "tokenizes literal at sign", ->
    {tokens} = grammar.tokenizeLine('@@')

    expect(tokens[0]).toEqual value: '@', scopes: ['source.empy', 'comment']
    expect(tokens[1]).toEqual value: '@', scopes: ['source.empy']

  it "tokenizes whitespace character following the at sign", ->
    {tokens} = grammar.tokenizeLine('@ ')

    expect(tokens[0]).toEqual value: '@ ', scopes: ['source.empy', 'comment']

  it "tokenizes literal at sign at end of line", ->
    {tokens} = grammar.tokenizeLine('@')

    expect(tokens[0]).toEqual value: '@', scopes: ['source.empy', 'comment']
