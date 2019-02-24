   /* CS152 Project Phase 1: Lexical Analyzer Generation Using flex */
   /* A flex scanner specification for the MINI-L language */
   /* Written by Brandon Tran */

   /* MODIFIED mini_l.lex FOR USE IN PHASE 2 OF THE PROJECT. USE THIS WITH mini_l.y !!! */

%{   
   #include "y.tab.h"   
	int currLine = 1, currPos = 0;
%}

digit    	[0-9]
alpha	 	[a-zA-Z]
identifier	{alpha}({alpha}|{digit})*("_"({alpha}|{digit})+)*
number		{digit}+
comment		"##".*"\n"

invalid_ident_letter		({digit}|"_")({alpha}|{digit})*("_"({alpha}|{digit})+)*
invalid_ident_underscore	{alpha}({alpha}|{digit})*("_"({alpha}|{digit})+)*"_"*
   
%%

"function"	{currPos += yyleng; return FUNCTION;}
"beginparams"	{currPos += yyleng; return BEGIN_PARAMS;}
"endparams"	{currPos += yyleng; return END_PARAMS;}
"beginlocals"	{currPos += yyleng; return BEGIN_LOCALS;}
"endlocals"	{currPos += yyleng; return END_LOCALS;}
"beginbody"	{currPos += yyleng; return BEGIN_BODY;}
"endbody"	{currPos += yyleng; return END_BODY;}
"integer"	{currPos += yyleng; return INTEGER;}
"array"		{currPos += yyleng; return ARRAY;}
"of"		{currPos += yyleng; return OF;}
"if"		{currPos += yyleng; return IF;}
"then"		{currPos += yyleng; return THEN;}
"endif"		{currPos += yyleng; return ENDIF;}
"else"		{currPos += yyleng; return ELSE;}
"while"		{currPos += yyleng; return WHILE;}
"do"		{currPos += yyleng; return DO;}
"beginloop"	{currPos += yyleng; return BEGINLOOP;}
"endloop"	{currPos += yyleng; return ENDLOOP;}
"continue"	{currPos += yyleng; return CONTINUE;}
"read"		{currPos += yyleng; return READ;}
"write"		{currPos += yyleng; return WRITE;}
"and"		{currPos += yyleng; return AND;}
"or"		{currPos += yyleng; return OR;}
"not"		{currPos += yyleng; return NOT;}
"true"		{currPos += yyleng; return TRUE;}
"false"		{currPos += yyleng; return FALSE;}
"return"	{currPos += yyleng; return RETURN;}

"-"            	{currPos += yyleng; return SUB;}
"+"            	{currPos += yyleng; return ADD;}
"*"            	{currPos += yyleng; return MULT;}
"/"            	{currPos += yyleng; return DIV;}
"%"		{currPos += yyleng; return MOD;}

"=="		{currPos += yyleng; return EQ;}
"<>"		{currPos += yyleng; return NEQ;}
"<"		{currPos += yyleng; return LT;}
">"		{currPos += yyleng; return GT;}
"<="		{currPos += yyleng; return LTE;}
">="		{currPos += yyleng; return GTE;}

{identifier}	{currPos += yyleng; yylval.var = (yytext); return IDENT;}
{number}	{currPos += yyleng; yylval.intval = atoi(yytext); return NUMBER;}

";"		{currPos += yyleng; return SEMICOLON;}
":"		{currPos += yyleng; return COLON;}
","		{currPos += yyleng; return COMMA;}
"("		{currPos += yyleng; return L_PAREN;}
")"		{currPos += yyleng; return R_PAREN;}
"["		{currPos += yyleng; return L_SQUARE_BRACKET;}
"]"		{currPos += yyleng; return R_SQUARE_BRACKET;}
":="		{currPos += yyleng; return ASSIGN;}

[ \t]+         	{/* Ignore spaces */ currPos += yyleng;}

"\n"           	{/* Move to next line */ currLine++; currPos = 0;}

{comment}	{/* Ignore comments */ currLine++; currPos = 0;}


{invalid_ident_letter}	{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);}
{invalid_ident_underscore}	{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}

.              	{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos+yyleng, yytext); exit(0);}

%%
/*
int main(int argc, char ** argv)
{
   if(argc >= 2)
   {
      yyin = fopen(argv[1], "r");
      if(yyin == NULL)
      {
         yyin = stdin;
      }
   }
   else
   {
      yyin = stdin;
   }
   
   yylex();
}

*/