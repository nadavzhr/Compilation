%{
/* Declarations section */
#include <stdio.h>
#include "part2_helpers.h"
#include "part2.h"
#include "part2.tab.h"


void showToken(char *);
void print_str(char *);
void handle_error();
%}

/* Options */
%option yylineno
%option noyywrap

%option outfile="part2-lex.c"

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
int {
    yylval = makeNode("int", NULL, NULL);
    return tk_int;
}
float {
    yylval = makeNode("float", NULL, NULL);
    return tk_float;
}
void {
    yylval = makeNode("void", NULL, NULL);
    return tk_void;
}
write {
    yylval = makeNode("write", NULL, NULL);
    return tk_write;
}
read {
    yylval = makeNode("read", NULL, NULL);
    return tk_read;
}
va_arg {
    yylval = makeNode("va_arg", NULL, NULL);
    return tk_va_arg;
}
while {
    yylval = makeNode("while", NULL, NULL);
    return tk_while;
}
do {
    yylval = makeNode("do", NULL, NULL);
    return tk_do;
}
if {
    yylval = makeNode("if", NULL, NULL);
    return tk_if;
}
then {
    yylval = makeNode("then", NULL, NULL);
    return tk_then;
}
else {
    yylval = makeNode("else", NULL, NULL);
    return tk_else;
}
return {
    yylval = makeNode("return", NULL, NULL);
    return tk_return;
}
{id}                            { yylval = makeNode("id", yytext, NULL); return tk_id; }
{integernum}                    { yylval = makeNode("integernum", yytext, NULL); return tk_integernum; }
{realnum}                       { yylval = makeNode("realnum", yytext, NULL); return tk_realnum; }
{string}                        { yylval = makeNode("str", yytext, NULL); return tk_string; }
{sign}                          { yylval = makeNode(yytext, NULL, NULL); return yytext[0]; }
{relop}                         { yylval = makeNode("relop", yytext, NULL); return tk_relop; }
{addop}                         { yylval = makeNode("addop", yytext, NULL); return tk_addop; }
{mulop}                         { yylval = makeNode("mulop", yytext, NULL); return tk_mulop; }
{assign}                        { yylval = makeNode("assign", yytext, NULL); return tk_assign; }
{and}                           { yylval = makeNode("and", yytext, NULL); return tk_and; }
{or}                            { yylval = makeNode("or", yytext, NULL); return tk_or; }
{not}                           { yylval = makeNode("not", yytext, NULL); return tk_not; }
{whitespace}                    { /* Ignore whitespace */ }
{comment}                       { /* Ignore comments */ }
.                               { handle_error(); }

%%
// int get_sign_token_type(const char *text) {
//     if (strcmp(text, "(") == 0) {
//         printf("Found ( \n");
//         yylval = makeNode(text, NULL, NULL);
//         return "(";
//     }
//     if (strcmp(text, ")") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return ")";
//     }
//     if (strcmp(text, "{") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return "{";
//     }
//     if (strcmp(text, "}") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return "}";
//     }
//     if (strcmp(text, ",") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return ",";
//     }
//     if (strcmp(text, ";") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return ";";
//     }
//     if (strcmp(text, ":") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return ":";
//     }
//     if (strcmp(text, "...") == 0) {
//         yylval = makeNode(text, NULL, NULL);
//         return "...";
//     }
//     return -1; // Unrecognized token
// }
void handle_error() {
    printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}