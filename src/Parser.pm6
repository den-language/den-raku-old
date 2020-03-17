use Grammar::PrettyErrors;
use Grammar::Tracer;

grammar Den {
    token TOP { <statement>* }

    token statement { 
        <.s> 
        [ 
            || <function-definition>
            || <variable-dec>
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

    token variable-dec {
        <type-id> <.s> ':' <.s> <name-id>+ %% [<.s> ',' <.s>] ';'
    }

    token function-definition {
        [ $<visibility>=[ <.pub> | <.pri> ] <.r> ]?
        [ <type-id> <.r>]?
        <name-id> <.s>
        [<arguments> <.s>]?
        <.arrow> <.s>
        [   
            || [ <expression> ';' ]
            || ['{' $<block>=[ 
                    || <.s> <?before '}'>
                    || <statement>* 
                ] '}' ] 
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
        <.s> <expression=.expr3> <.s>
    }

    token expression-item {
        | <int>
        | <reference>
        | <ref-id> 
        | '(' <expression> ')'
    }

    token expr1 {
        $<left>=<.expression-item>
        [   
            <.s>
            $<op> = '**'
            <.s>
            $<right>=<.expression-item>
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

    token int { \d+ }

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