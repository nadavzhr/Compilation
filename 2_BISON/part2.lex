%{
/* Declarations section */
#include <stdio.h>
void showToken(char *);
void print_str(char *);
void handle_error();
%}

/* Options */
%option yylineno
%option noyywrap

/* Regular Expression Definitions */
digit       [0-9]
letter      [a-zA-Z]
whitespace  [ \t\n\r]

/* Complex Tokens*/
reserved_word    int|float|void|write|read|va_arg|while|do|if|then|else|return
sign        \(|\)|\{|\}|,|;|:|\.\.\.
id          {letter}({letter}|{digit}|_)*
integernum  {digit}+
realnum     {digit}+\.{digit}+
string      \"(?:(\\["nt])|[^\\\"\n\r])*\"
relop       ==|<>|<=|>=|<|>
addop       \+|-
mulop       \*|\/
assign      =
and         &&
or          \|\|
not         !
comment     #[^\n\r]*

/* Rules Section in Descending Priority */
%%

{reserved_word}                 {
                                    return makeNode()
								    return TK_RSRVD;
								}
{id}                            {
                                    yylval.name = yytext;
                                    return TK_ID;
                                }
{integernum}                    {
                                    yylval.val = atoi(yytext);
                                    return TK_INT;
                                }
{realnum}                       {
                                    yylval.val = atof(yytext);
                                    return TK_REAL;
                                }
{string}                        {
                                    yylval.name = yytext;
                                    return TK_STR;
                                }
{sign}                          {
                                    yylval.name = yytext;
                                    return TK_SIGN;
                                }
{relop}                         {
                                    yylval.name = yytext;
                                    return TK_RELOP;
                                }
{addop}                         {
                                    yylval.name = yytext;
                                    return TK_ADD;
                                }
{mulop}                         {
                                    yylval.name = yytext;
                                    return TK_MULOP;
                                }
{assign}                        {
                                    yylval.name = yytext;
                                    return TK_ASSN;
                                }
{and}                           {
                                    yylval.name = yytext;
                                    return TK_AND;
                                }
{or}                            {
                                    yylval.name = yytext;
                                    return TK_OR;
                                }
{not}                           {
                                    yylval.name = yytext;
                                    return TK_NOT;
                                }
{whitespace}                    {
                                    yylval.val = yytext;
                                    return TK_WSPC;
                                }
{comment}                       ;
.                               handle_error();

%%
/* C Function Definition */
void showToken(char *name) {
    printf("<%s,%s>", name, yytext);
}
void print_str(char *str) {
    char * only_string = yytext + 1;
    only_string[yyleng - 2] = '\0';
    printf("<%s,%s>", str, only_string);
}
void handle_error(){
    printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}