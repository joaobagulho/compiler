grammar simple;


// Core
root : (stat)*;


// Basic Structures
stat : scope
     | if
     | switch
     | while
     | for
     | sub
     | ((expr | flow | var_decl) ';')
     ;
scope : '{' (stat)* '}';


// Basic Expressions
expr : expr op=(OP_MUL | OP_DIV | OP_MOD) expr                                                                                     # mulDivMod
     | expr op=(OP_ADD | OP_SUB) expr                                                                                              # addSub
     | expr op=(OP_SHL | OP_SHR | OP_AND | OP_OR | OP_XOR) expr                                                                    # bitwise
     | op=OP_NEG expr                                                                                                              # bitwise
     | symbol op=(OP_INC | OP_DEC)                                                                                                 # unary

     | symbol '(' (expr (',' expr)*)? ')'                                                                                          # call_sub

     | var_decl OP_SET expr                                                                                                        # var_def
     | symbol (op=(OP_MUL | OP_DIV | OP_ADD | OP_SUB | OP_SHL | OP_SHR | OP_MOD | OP_AND | OP_OR | OP_XOR | OP_NEG))? OP_SET expr  # set

     | expr op=(OP_CMP_EQ | OP_CMP_NEQ | OP_CMP_LTH | OP_CMP_BTH | OP_CMP_LEQ | OP_CMP_BEQ) expr                                   # comp
     | expr 'in' (array | symbol | STRING)                                                                                         # comp
     | OP_LOG_NOT expr                                                                                                             # cond
     | expr op=(OP_LOG_AND | OP_LOG_OR) expr                                                                                       # cond
     
     | '(' expr ')'                                                                                                                # paren

     | (atom | array | symbol)                                                                                                     # atomic
     ;
var_decl : 'var' symbol;


// Conditionals
if   : 'if' '(' expr ')' stat;
case : 'case' atom ':' (stat)*;
default : 'default' ':' (stat)+;
switch : 'switch' '(' symbol ')' '{' (case)* (default)? '}';


// Loops
while : 'while' '(' expr ')' stat;
cond_for : expr ';' expr ';' expr;
cond_foreach : var_decl 'in' (array | symbol | STRING);
for : 'for' '(' (cond_for | cond_foreach) ')' stat;


// Subroutines
arg : symbol;
arg_def : symbol '=' (atom | array | symbol);
args :  (arg (',' arg)*)? (arg_def (',' arg_def)*)?;
sub : 'sub' symbol '(' args ')' scope;


// Operators
OP_SET : '=';

OP_INC : '++';
OP_DEC : '--';

OP_ADD : '+';
OP_SUB : '-';
OP_MUL : '*';
OP_DIV : '/';
OP_MOD : '%';
OP_SHL : '>>';
OP_SHR : '<<';
OP_NEG : '~';
OP_AND : '&';
OP_OR  : '|';
OP_XOR : '^';

OP_LOG_AND : '&&';
OP_LOG_OR  : '||';
OP_LOG_NOT : '!';

OP_CMP_EQ  : '==';
OP_CMP_NEQ : '!=';
OP_CMP_LTH : '<';
OP_CMP_BTH : '>';
OP_CMP_LEQ : '<=';
OP_CMP_BEQ : '>=';


// Basic types
array  : '[' (array | atom)* ']';
symbol : SYMBOL;
atom : NULL
     | BOOL
     | NUMBER
     | STRING
     ;

STRING : '"' .*? '"';
BOOL   : 'true' | 'false';
SYMBOL : [a-zA-Z_][a-zA-Z0-9_]*;
NUMBER : [0-9]+ (('.'[0-9]+([eE]('+'|'-')?[0-9]+)?)|([eE]('+'|'-'?)[0-9]+))?;
NULL   : 'null';

flow : BREAK | CONTINUE | RETURN (atom | array | symbol);

BREAK    : 'break';
CONTINUE : 'continue';
RETURN   : 'return';


// Core types
COMMENT : '#'~[\r\n]* -> skip;
WHITSPACE : [ \t\r\n]+ -> skip;
