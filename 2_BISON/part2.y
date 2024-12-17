%{
#include <stdio.h>
#include <stdlib.h>
// #include "part2_helpers.h"
#include "part2.tab.h"

#include "part2.h"

// #define YYSTYPE ParserNode*
extern int yylex();
extern char* yytext;
extern int yylineno;
void yyerror(const char *s);
ParserNode*  parseTree = NULL;

%}

// %token "," "..."
%token tk_id
%token tk_int tk_float tk_void
%token tk_write tk_read tk_va_arg
%token tk_while tk_do tk_if tk_then tk_else
%token tk_return
%token tk_integernum
%token tk_realnum
%token tk_string

%right tk_assign

%left tk_or
%left tk_and
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
    | /* Empty */ { $$ = makeNode("FDEFS", NULL, makeNode("EPSILON", NULL, NULL)); };

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
        $$ = makeNode("FUNC_DEF_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
    }
    | TYPE tk_id "(" FUNC_ARGLIST ")" 
    {
        $$ = makeNode("FUNC_DEF_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
    }
    | TYPE tk_id "(" FUNC_ARGLIST "," "..." ")" 
    {
        $$ = makeNode("FUNC_DEF_API", NULL, $1);
        concatList($1, $2);
        concatList($1, $3);
        concatList($1, $4);
        concatList($1, $5);
        concatList($1, $6);
        concatList($1, $7);
    };

FUNC_ARGLIST: FUNC_ARGLIST "," DCL 
{
    $$ = makeNode("FUNC_ARGLIST", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
    | DCL { $$ = makeNode("FUNC_ARGLIST", NULL, $1);
        };

BLK: "{" STLIST "}" { $$ = makeNode("BLK", NULL, $1);
                    concatList($1, $2);
                    concatList($1, $3);
                };

DCL: tk_id ":" TYPE
{
    $$ = makeNode("DCL", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| tk_id "," DCL 
{
    $$ = makeNode("DCL", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
};

TYPE: tk_int
{
    $$ = makeNode("TYPE", NULL, $1);
} 
| tk_float 
{
    $$ = makeNode("TYPE", NULL, $1);
} 
| tk_void
{
    $$ = makeNode("TYPE", NULL, $1);
};

STLIST: STLIST STMT
{
    $$ = makeNode("STLIST", NULL, $1);
    concatList($1, $2);
} 
| /* Empty */
 
{ 
    $$ = makeNode("STLIST", NULL, makeNode("EPSILON", NULL, NULL)); 
};

STMT: DCL ";" 
{
    $$ = makeNode("STMT", NULL, $1);
    concatList($1, $2);
}
| ASSN 
{
    $$ = makeNode("STMT", NULL, $1);
}
| EXP ";" 
{
    $$ = makeNode("STMT", NULL, $1);
    concatList($1, $2);
}
| CNTRL 
{
    $$ = makeNode("STMT", NULL, $1);
}
| READ
{
    $$ = makeNode("STMT", NULL, $1);
} 
| WRITE 
{
    $$ = makeNode("STMT", NULL, $1);
}
| RETURN 
{
    $$ = makeNode("STMT", NULL, $1);
}
| BLK
{
    $$ = makeNode("STMT", NULL, $1);
};

RETURN: tk_return EXP ";" 
{
    $$ = makeNode("RETURN", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| tk_return";"
{
    $$ = makeNode("RETURN", NULL, $1);
    concatList($1, $2);
};

WRITE: tk_write "(" EXP ")" ";" 
{
    $$ = makeNode("WRITE", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
    concatList($1, $5);
}
| tk_write "(" tk_string ")" ";" 
{
    $$ = makeNode("WRITE", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
    concatList($1, $5);
};

READ: tk_read "(" LVAL ")" ";" 
{
    $$ = makeNode("READ", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
    concatList($1, $5);
};

ASSN: LVAL tk_assign EXP ";" 
{
    $$ = makeNode("ASSN", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
};

LVAL: tk_id 
{
    $$ = makeNode("LVAL", NULL, $1);
};

CNTRL: tk_if BEXP tk_then STMT tk_else STMT 
{
    $$ = makeNode("CNTRL", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
    concatList($1, $5);
    concatList($1, $6);
}
| tk_if BEXP tk_then STMT 
{
    $$ = makeNode("CNTRL", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
}
| tk_while BEXP tk_do STMT
{
    $$ = makeNode("CNTRL", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
};

BEXP: BEXP tk_or BEXP
{
    $$ = makeNode("BEXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| BEXP tk_and BEXP
{
    $$ = makeNode("BEXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| tk_not BEXP
{
    $$ = makeNode("BEXP", NULL, $1);
    concatList($1, $2);
}
| EXP tk_relop EXP
{
    $$ = makeNode("BEXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| "(" BEXP ")"
{
    $$ = makeNode("BEXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
};

EXP: EXP tk_addop EXP
{
    $$ = makeNode("EXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| EXP tk_mulop EXP
{
    $$ = makeNode("EXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| "(" EXP ")"
{
    $$ = makeNode("EXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
| "(" TYPE ")" EXP
{
    $$ = makeNode("EXP", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
}
| tk_id
{
    $$ = makeNode("EXP", NULL, $1);
}
| NUM
{
    $$ = makeNode("EXP", NULL, $1);
}
| CALL
{
    $$ = makeNode("EXP", NULL, $1);
}
| VA_MATERIALISE
{
    $$ = makeNode("EXP", NULL, $1);
};

NUM: tk_integernum
{
    $$ = makeNode("NUM", NULL, $1);
}
| tk_realnum
{
    $$ = makeNode("NUM", NULL, $1);
};

CALL: tk_id "(" CALL_ARGS ")"
{
    $$ = makeNode("CALL", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
};

VA_MATERIALISE: tk_va_arg "("  TYPE "," EXP ")"
{
    $$ = makeNode("VA_MATERIALISE", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
    concatList($1, $4);
    concatList($1, $5);
    concatList($1, $6);
};

CALL_ARGS: CALL_ARGLIST
{
    $$ = makeNode("CALL_ARGS", NULL, $1);
}
| /* EPSILON */
{
    $$ = makeNode("CALL_ARGS", NULL, makeNode("EPSILON", NULL, NULL));
};

CALL_ARGLIST: CALL_ARGLIST "," EXP
{
    $$ = makeNode("CALL_ARGLIST", NULL, $1);
    concatList($1, $2);
    concatList($1, $3);
}
|  EXP
{
    $$ = makeNode("CALL_ARGLIST", NULL, $1);
};


%%
void yyerror(const char *s) {
    printf("\nSyntax error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}

int main(void) {
    return yyparse();
}