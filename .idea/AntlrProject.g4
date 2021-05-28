grammar AntlrProject;

start: statement* EOF;

expression: expression '**' expression | '~' expression | '-' expression | '+' expression |
 expression'++' | expression'--' | '++'expression | '--'expression |
 expression '*' expression | expression '/' expression | expression '//' expression |
 expression '%' expression | expression '+' expression | expression '-' expression |
 expression '<<' expression | expression '>>' expression | expression '&' expression |
 expression '^' expression | expression '|' expression | expression '==' expression |
 expression '!=' expression | expression '<' expression | expression '>' expression |
 expression '<=' expression | expression '>=' expression | 'not' expression |
 expression 'and' expression | expression 'or' expression | expression '||' expression |
 expression '&&' expression | expression '=' expression | expression '+=' expression |
 expression '-=' expression | expression '*=' expression | expression '/=' expression |
 expression '%=' expression| value | NAME| STRING | DIGIT | BOOLEAN | '(' expression ')';

//parser
value: NUMBER | BOOLEAN | NAME | STRING;
parameter_list: (((DATATYPE)? STRING)? ((',' (DATATYPE)? STRING)*)) | (((DATATYPE)? value)? ((',' (DATATYPE)? value)*));
function_name: NAME;
variable_name: NAME;
parent_name: NAME;
class_name: NAME;
iterator_name: NAME;
exception_name: NAME;
object_name: NAME;
initial_value: (NAME '= ')? value;
trait: NAME;
interpolation: '$' OPENBRACKET (variable_name | expression) CLOSEBRACKET;
inc_dec: expression'++' | expression'--' | '++'expression | '--'expression;
statement: ((create_variable | class_instantiation | forLoop
 | forEachLoop | if_statement | switch_case | whileLoop | do_while| try_catch
 | functionCall | define_function | define_class | import_libraries | expression)
 (SEMICOLON)? NEWLINE) | LINE_COMMENT | BLOCK_COMMENT;
class_body: statement*;


//define variable
create_variable: (ACCESS_MODIFIER)? (VARIABLE_TYPE | DATATYPE) variable_name
(('= ' value) |
(': ' ((DATATYPE '= ' initial_value) | (variable_name ': ' DATATYPE)) (', ' (DATATYPE '= ' initial_value) |
 (variable_name ': ' DATATYPE))*) | (DATATYPE LPAREN parameter_list RPAREN)
('= ' (NEW)? DATATYPE (LBR DATATYPE RBR)?) |
('= ' DATATYPE '(' parameter_list ')'))?
SEMICOLON;

//define class
define_class: ACCESS_MODIFIER CLASS class_name (EXTENDS parent_name)? (IMPLEMENTS trait (WITH trait)* )? OPENBRACKET
    statement*
    CLOSEBRACKET;

//class instantiation
class_instantiation: (DATATYPE | VARIABLE_TYPE) object_name '= ' NEW class_name LPAREN parameter_list RPAREN SEMICOLON;

//for loop
forLoop: FOR LPAREN initial_value SEMICOLON expression SEMICOLON inc_dec RPAREN OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET;

forEachLoop: FOR LPAREN (VARIABLE_TYPE | DATATYPE) variable_name IN iterator_name RPAREN OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET;

//while loop
whileLoop: WHILE LPAREN expression RPAREN OPENBRACKET '\n'
    statement*
    (BREAK)?
    CLOSEBRACKET;

//do while loop
do_while: DO OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET WHILE LPAREN expression RPAREN SEMICOLON;

//if
if_statement: IF LPAREN expression RPAREN OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET
(ELSEIF LPAREN expression RPAREN OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET )*
(ELSE OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET )?;

//switch case
switch_case: SWITCH LPAREN expression RPAREN OPENBRACKET NEWLINE
    (CASE value ': ' statement* (BREAK SEMICOLON)? NEWLINE)+
    (DEFAULT ': ' statement* (BREAK SEMICOLON)? NEWLINE)?
    CLOSEBRACKET;

//define function
define_function: DATATYPE function_name LPAREN parameter_list RPAREN OPENBRACKET NEWLINE
    statement*
    (RETURN (value | variable_name))?
    CLOSEBRACKET;

//call function
functionCall: function_name LPAREN parameter_list RPAREN SEMICOLON;

//exception
try_catch: TRY OPENBRACKET NEWLINE
    statement*
    CLOSEBRACKET
(ON exception_name (CATCH LPAREN variable_name RPAREN )? OPENBRACKET
    statement*
    SEMICOLON
    CLOSEBRACKET)| (CATCH LPAREN variable_name RPAREN OPENBRACKET
    statement*
    CLOSEBRACKET);

//import libararies
import_libraries: (IMPORT NAME | FROM NAME IMPORT '*' | FROM NAME'.'NAME IMPORT NAME |
FROM NAME IMPORT NAME', 'NAME | FROM NAME IMPORT NAME '=>' NAME) SEMICOLON;

//keywords
DATATYPE: 'int ' | 'double ' | 'String ' | 'boolean ' | 'Array' | 'void ';
IMPORT: 'import ';
FROM: 'from ';
ACCESS_MODIFIER: 'public '|'private '|'protected ';
VARIABLE_TYPE: 'var ' | 'const ';
CLASS: 'class ';
NEW: 'new ';
IMPLEMENTS: 'implements ';
EXTENDS: 'extends ';
FOR: 'for ';
WHILE: 'while ';
DO: 'do ';
SWITCH: 'switch ';
CASE: 'case ';
DEFAULT: 'default';
BREAK: 'break';
TRY: 'try ';
CATCH: 'catch ';
IF: 'if ';
ELSE: 'else ';
ELSEIF: 'else if ';
WITH: 'with ';
IN: 'in ';
ON: 'on ';
RETURN: 'return';
SEMICOLON: ';';
OPENBRACKET: '{';
CLOSEBRACKET: '}';
LBR : '[';
RBR: ']';
QUOTATION: '"';

//operators
LPAREN: '(';
RPAREN: ')';
POWER: '**';
NOT: '~';
POS_NEG: '+' | '-';
UNARY: '--' | '++';
MULT_DIV: '*' | '/' | '//' | '%';
PLUS_MINUS: '+' | '-';
SLL: '<<';
SLR: '>>';
BITWISE: '&' | '^' | '|';
EQUALITY: '==' | '!=';
COMPARE: '<' | '>' | '<=' | '=>';
LOGICAL: 'and' | 'or' | '||' | '&&';
ASSIGN: '=' | '+=' | '*=' | '-=' | '/=';
OPERATOR: LPAREN | RPAREN | POWER | NOT | POS_NEG | UNARY | MULT_DIV | PLUS_MINUS
| SLL | SLR | BITWISE | EQUALITY | COMPARE | LOGICAL | ASSIGN;

//lexer
BOOLEAN: 'true'|'false';
fragment LETTER: [a-zA-Z];
fragment DIGIT: [0-9];
NUMBER: (POS_NEG)? (DIGIT+) (([.] DIGIT+)?) (('e' (POS_NEG)? DIGIT+)?);
STRING: (QUOTATION)? (LETTER*) (QUOTATION)?;
NAME: (QUOTATION)? LETTER (LETTER | DIGIT | '_' | '$')* (' ')? (QUOTATION)?;

//whitespace
BLOCK_COMMENT : ('/*' .*? '*/') -> skip;
LINE_COMMENT : ('//' .*? '\n') -> skip;
NEWLINE: '\n';
WS: [ \t\r\n]+ -> skip;