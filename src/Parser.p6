
grammar Tokens {
    token arrow { "=>" }
    token pub { "pub" }
}

grammar Identifier {
    token name-id { <[A-Za-z_]> <[A-Za-z_0-9]>* }
    token ref-id { <[A-Za-z_]> <[A-Za-z_0-9]>* }
    token type { <[A-Za-z_]> <[A-Za-z_0-9]>* }
}

grammar Function is Identifier is Token {
    token function-definition { <pub>? <type>? <name-id> <arguments>? <arrow> "\{" "\}" }
    token arguments { "(" ")" }
}

grammar Statement is Function {
    token statement { <function-definition> }
}

grammar Den is Statement {
    token TOP { <statement>* }
}

