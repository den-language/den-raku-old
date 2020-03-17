use Grammar::PrettyErrors;
use Grammar::Tracer;

grammar Den {
    token TOP { <statement>* }

    token statement { 
        <.s> 
        [ 
            <function-definition> 
        ]
        <.s> 
    }
    
    token comment { 
        '//' \N*
    }

	token multiline-comment {
        '/*'
        [
            || <?{'/*'}> <.multiline-comment>
            || '*' <!before '/'>
            || .
        ]*?
        '*/'
    }

    token s {
        [
            | <.comment>
            | <.multiline-comment>
            | \s
        ]*
    }

    token r {
        [
            | <.comment>
            | <.multiline-comment>
            | \s
        ]+
    }

    token function-definition {
        [ $<visibility>=[ <.pub> | <.pri> ] <.r> ]?
        [ <type-id> <.r>]?
        <name-id> <.s>
        [<arguments> <.s>]?
        <.arrow> <.s>
        [
            | ['{' $<block>=[ <statement>* | <.s> ] '}' ] 
            | [ <expression> ';' ]
        ] 
    }

    token arguments {
        '('
        [ 
            | <positional-args> 
            | <optional-args> 
            | <keyword-args> 
        ] * %% [ ',' ]
        ')'
    }

    token positional-args {
        | [ [ <.s> <type-id> <.s> ':' <.s> <name-id> <.s> ',' <.s> ]+? [ <type-id> <.s> ':' <.s> <name-id> <.s> ] ] 
        | [ <.s> <type-id> <.s> ':' <.s> <name-id> <.s> ]
    }

    token optional-args {
        | [ [ <.s> <type-id> <.s> ':' <.s> <name-id> <.s> '?' <.s> ','<.s> ]+? [ <type-id> <.s> ':' <.s> <name-id> <.s> '?' <.s>] ] 
        | [ <.s> <type-id> <.s> ':' <.s> <name-id> <.s> '?' <.s> ]
    }

    token keyword-args {
        | [ [ <.s> <type-id> <.s> ':' <.s> <name-id> <.s> '=' <expression> ',' <.s> ]+? [ <type-id> <.s> ':' <.s> <name-id> <.s> '=' <expression> ] ] 
        | [ <.s> <type-id> <.s> ':' <.s> <name-id> <.s> '=' <expression> ]
    }

    token expression { 
        <.s> <expr3> <.s>
    }

    token expression-item {
        | <literal>
        | <reference>
        | <ref-id> 
        | '(' <expression> ')'
    }

    token expr1 {
        $<left>=<expression-item>
        [   
            <.s>
            $<op> = '**'
            <.s>
            $<right>=<expression-item>
        ]?
    }

    token expr2 {
        $<left>=<.expr1>
        [   
            <.s>
            $<op> = ( '*' | '/' | '%' )
            <.s>
            $<right>=<.expr1>
        ]?
    }

    token expr3 {
        $<left>=<.expr2>
        [
            <.s>
            $<op> = ( '+' | '-' )
            <.s>
            $<right>=<.expr2>
        ]?
    }

    proto token literal {*}
    token literal:sym<int> { \d+ }

    token reference  { "&" <ref-id> }

    token name-id { <.alpha> \w* }
    token ref-id  { <.alpha> \w* }
    token type-id    { <.alpha> \w* }

    token arrow { '=>' }
    token pub   { 'pub' }
    token pri   { 'pri' }
}

my $test = slurp 'examples/functions.den';
say Den.parse($test);
