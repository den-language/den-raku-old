
module Parsing::AST is export {
    class Name {
        has Str $.name is required;
    }

    class Type {
        has Str $.name is required;
    }

    # Expressions
    role Expression { }

    class Reference does Expression {
        has Name $.value is required;
    }

    class Variable does Expression {
        has Name $.value is required;
    }

    class Integer does Expression {
        has Str $.value is required;
    }

    # Operator
    role Op does Expression {
        has Str $.op is required;
    }

    class BinaryOp does Op {
        has Expression ($.left, $.right) is required;
    }

    # Statements
    role Statement { }

    class VariableAssign does Statement {
        has Expression $.expr is required;
        has Name $.name is required;
    }

    class VariableDeclaration does Statement {
        has Type $.type is required;
        has Name $.name is required; 
    }

    # TODO: Implement this
    class VaraibleAssignFull does Statement {
        has Type $.type is required;
        has Name $.name is required; 
        has Expression $.expr is required;
    }

    enum Visibility <public private>;

    class PositionalArg {
        has Type $.type is required;
        has Name $.name is required;
    }

    class OptionalArg {
        has Type $.type is required;
        has Name $.name is required;
    }

    class KeywordArg {
        has Type $.type is required;
        has Name $.name is required;
        has Expression $.expr is required;
    }

    class Arguments {
        has PositionalArg @.positional-args is required;
        has OptionalArg @.optional-args is required;
        has KeywordArg @.keyword-args is required;
    }

    class FunctionDefine does Statement {
        has Arguments $.arguments is required;
        has Type $.return-type is required;
        has Name $.name is required;
        has Visibility $.visibility is required;
    }

    class Block {
        has Statement @.statements is required;
    }
    
}
