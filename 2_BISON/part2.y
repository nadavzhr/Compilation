%{
#include <iostream>
#include <map>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include "part2_helpers.h"

#define YYSTYPE ParserNode*
int yylex();
void yyerror(const char *s);

map<string, int> vars;
%}

%left ","

%token "..."
%token tk_int tk_float tk_void
%token tk_write tk_read tk_va_arg
%token tk_while tk_do tk_if tk_then tk_else
%token tk_return
%token tk_integernum
%token tk_realnum
%token tk_string

%right tk_assign

%left tk_or
$left tk_and
%left tk_relop
%left tk_addop
%left tk_mulop
%right tk_not
%left "("
%left ")"
%left "{"
%left "}"
%left ";"
%left ":"

%%
PROGRAM: FDEFS
    {
        $$ = makeNode("PROGRAM", NULL, $1);
        parseTree = $$;
    };
FDEFS: FDEFS FUNC_DEF_API BLK { $$ = makeNode("FDEFS", NULL, $1);
                                concatList($1, $2);
                                concatList($1, $3); 
                            }
    | FDEFS FUNC_DEC_API { $$ = makeNode("FDEFS", NULL, $1);
                        concatList($1, $2); 
    }
    | /* Empty */ { $$ = makeNode("FDEFS", NULL, makeNode("EPSILON", NULL, NULL)) };

FUNC_DEC_API: TYPE tk_id "(" ")" ";"
    {
        $$ = makeNode("FUNC_DEC_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
    }
    | TYPE tk_id "(" FUNC_ARGLIST ")" ";"
    {
        $$ = makeNode("FUNC_DEC_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
        concatList($1, $6);
    }
    | TYPE tk_id "(" FUNC_ARGLIST "," "..." ")" ";"
    {
        $$ = makeNode("FUNC_DEC_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
        concatList($1, $6);
        concatList($1, $7);
        concatList($1, $8);
    };

FUNC_DEF_API: TYPE tk_id "(" ")" 
    {
        $$ = makeNode("FUNC_DEC_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
    }
    | TYPE tk_id "(" FUNC_ARGLIST ")" 
    {
        $$ = makeNode("FUNC_DEC_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
    }
    | TYPE tk_id "(" FUNC_ARGLIST "," "..." ")" 
    {
        $$ = makeNode("FUNC_DEC_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
        concatList($1, $6);
        concatList($1, $7);
    };

BLK: "{" STLIST "}" { $$ = makeNode("BLK", NULL, $1);
                    concatList($1, $2);
                    concatList($1, $3);
                };


DCL → id : TYPE | id , DCL
TYPE → int | float | void
STLIST → STLIST STMT | ε
STMT → DCL ; | ASSN | EXP ; | CNTRL | READ | WRITE | RETURN |
BLK
RETURN → return EXP ; | return;
WRITE → write ( EXP ) ; | write ( str ) ;
READ → read ( LVAL ) ;
ASSN → LVAL assign EXP ;
LVAL → id
CNTRL → if BEXP then STMT else STMT | if BEXP then STMT |
while BEXP do STMT

%%
void yyerror(const char *s) {
    printf("\nSyntax error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}

int main(void) {
    return yyparse();
}