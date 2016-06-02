describe "EmPy C++ grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-c")
      atom.packages.activatePackage("language-empy")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.empy.cpp")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.empy.cpp"

  it "tokenizes C++ comment line", ->
    {tokens} = grammar.tokenizeLine('// C++ comment')

    expect(tokens[0]).toEqual value: '//', scopes: ['source.empy.cpp', 'comment.line.double-slash.cpp', 'punctuation.definition.comment.cpp']
    expect(tokens[1]).toEqual value: ' C++ comment', scopes: ['source.empy.cpp', 'comment.line.double-slash.cpp']

  it "tokenizes EmPy comment line", ->
    {tokens} = grammar.tokenizeLine('@# EmPy comment')

    expect(tokens[0]).toEqual value: '@# EmPy comment', scopes: ['source.empy.cpp', 'comment.empy']

  it "tokenizes include directive", ->
    {tokens} = grammar.tokenizeLine('#include <cstddef>')

    expect(tokens[0]).toEqual value: '#', scopes: ['source.empy.cpp', 'meta.preprocessor.include.c', 'keyword.control.directive.include.c', 'punctuation.definition.directive.c']
    expect(tokens[1]).toEqual value: 'include', scopes: ['source.empy.cpp', 'meta.preprocessor.include.c', 'keyword.control.directive.include.c']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.empy.cpp', 'meta.preprocessor.include.c']
    expect(tokens[3]).toEqual value: '<', scopes: ['source.empy.cpp', 'meta.preprocessor.include.c', 'string.quoted.other.lt-gt.include.c', 'punctuation.definition.string.begin.c']
    expect(tokens[4]).toEqual value: 'cstddef', scopes: ['source.empy.cpp', 'meta.preprocessor.include.c', 'string.quoted.other.lt-gt.include.c']
    expect(tokens[5]).toEqual value: '>', scopes: ['source.empy.cpp', 'meta.preprocessor.include.c', 'string.quoted.other.lt-gt.include.c', 'punctuation.definition.string.end.c']
