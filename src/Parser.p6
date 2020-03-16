
=begin comment
grammar Tokens {

}

grammar Identifier {

}

grammar Function is Identifier is Token {

}

grammar Statement is Function {

}
=end comment

use Grammar::PrettyErrors;

grammar Den does Grammar::PrettyErrors {
    rule TOP { <statement>* }

    rule statement { <function-definition> }

    rule function-definition {
        <pub>?
        <type>?
        <name-id>
        <arguments>?
        <arrow>
        ['{' <statement>* '}'] | [<expression> ';']
    }

    rule arguments {
        '('
        [<positional-args> ','?]?
        [<optional-args> ','?]?
        [<keyword-args> ','?]?
        ')'
    }

    rule positional-args {
        [<type-id> ':' <name-id> ',']+
        [<type-id> ':' <name-id>] | [<type-id> ':' <name-id>]
    }

    rule optional-args {
        [<type-id> ':' <name-id> '?' ',']+
        [<type-id> ':' <name-id> '?'] | [<type-id> ':' <name-id> '?']
    }

    rule keyword-args {
        [<type-id> ':' <name-id> '=' <expression> ',']+
        [<type-id> ':' <name-id> '=' <expression>] | [<type-id> ':' <name-id> '=' <expression>]
    }

    token expression { <int> }
    token int        { \d+ }

    token name-id { <.alpha> \w* }
    token ref-id  { <.alpha> \w* }
    token type    { <.alpha> \w* }

    token arrow { '=>' }
    token pub   { 'pub' }
}

my $test = slurp 'examples/functions.den';
say Den.parse($test);

