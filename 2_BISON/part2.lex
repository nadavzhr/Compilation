%{
/* Declarations section */
#include <stdio.h>
#include "part2_helpers.h"

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
{reserved_word}                 { return get_reserved_token_type(yytext); }
{id}                            { yylval = makeNode("id", yytext, NULL); return tk_id; }
{integernum}                    { yylval = makeNode("integernum", yytext, NULL); return tk_integernum; }
{realnum}                       { yylval = makeNode("realnum", yytext, NULL); return tk_realnum; }
{string}                        { yylval = makeNode("string", yytext, NULL); return tk_string; }
{sign}                          { yylval = makeNode(yytext, NULL, NULL); return yytext; }
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

/* Helper Functions */
int get_reserved_token_type(const char *text) {
    if (strcmp(text, "int") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_int;
    }
    if (strcmp(text, "float") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_float;
    }
    if (strcmp(text, "void") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_void;
    }
    if (strcmp(text, "write") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_write;
    }
    if (strcmp(text, "read") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_read;
    }
    if (strcmp(text, "va_arg") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_va_arg;
    }
    if (strcmp(text, "while") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_while;
    }
    if (strcmp(text, "do") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_do;
    }
    if (strcmp(text, "if") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_if;
    }
    if (strcmp(text, "then") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_then;
    }
    if (strcmp(text, "else") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_else;
    }
    if (strcmp(text, "return") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_return;
    }
    return -1; // Unrecognized token
}
int get_sign_token_type(const char *text) {
    if (strcmp(text, "(") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_lparen;
    }
    if (strcmp(text, ")") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_rparen;
    }
    if (strcmp(text, "{") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_lbrace;
    }
    if (strcmp(text, "}") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_rbrace;
    }
    if (strcmp(text, ",") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_comma;
    }
    if (strcmp(text, ";") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_semicolon;
    }
    if (strcmp(text, ":") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_colon;
    }
    if (strcmp(text, "...") == 0) {
        yylval = makeNode(text, NULL, NULL);
        return tk_ellipsis;
    }
    return -1; // Unrecognized token
}

void handle_error() {
    printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}