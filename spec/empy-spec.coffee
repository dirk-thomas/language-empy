describe "EmPy grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
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
    {tokens} = grammar.tokenizeLine('@{block of statements}')

    expect(tokens[0]).toEqual value: '@{', scopes: ['source.empy', 'storage.type.statement.empy']
    expect(tokens[1]).toEqual value: 'block of statements', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: '}', scopes: ['source.empy', 'storage.type.statement.empy']

  it "tokenizes control structure", ->
    {tokens} = grammar.tokenizeLine('@[if True]')

    expect(tokens[0]).toEqual value: '@[', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'if True', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[end if]')

    expect(tokens[0]).toEqual value: '@[end ', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'if', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[for _ in range(2)]')

    expect(tokens[0]).toEqual value: '@[', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'for _ in range(2)', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[end for]')

    expect(tokens[0]).toEqual value: '@[end ', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'for', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[while True]')

    expect(tokens[0]).toEqual value: '@[', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'while True', scopes: ['source.empy']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.empy', 'storage.type.control.empy']

    {tokens} = grammar.tokenizeLine('@[end while]')

    expect(tokens[0]).toEqual value: '@[end ', scopes: ['source.empy', 'storage.type.control.empy']
    expect(tokens[1]).toEqual value: 'while', scopes: ['source.empy']
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
