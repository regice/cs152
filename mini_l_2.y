   /* CS152 Project Phase 3: Code Generation */
   /* The grammar for the MINI-L language with intermediate code */
   /* Written by Brandon Tran */

   /* References:
	Project Spec: https://www.cs.ucr.edu/~amazl001/teaching/webpages3/phase3_code_generator.html
   */

%{
 #include <stdio.h>
 #include <stdlib.h>
 int yylex();
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
  char* var;
  int intval;
}

%error-verbose
%start program
%token FUNCTION 
%token BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
%token INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE RETURN
%token IDENT 
%token NUMBER
%token SEMICOLON COLON COMMA 

%token ASSIGN
%token AND OR
%token NOT
%token EQ NEQ LT GT LTE GTE
%token ADD SUB
%token MULT DIV MOD
%token U_MINUS
%token L_SQUARE_BRACKET R_SQUARE_BRACKET
%token L_PAREN R_PAREN 

%% 
program:		functions {  }
			;

functions:		/* empty */ {  }
			| function functions { }
			;

function:		FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {  }
			;

declarations:		/* empty */ {  }
			| declaration SEMICOLON declarations {  }
			;

declaration:		/* empty */ {  }
			| identifiers COLON INTEGER {  }
			| identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {  }
			;

statements:		/* empty */ {  }
			| statement SEMICOLON statements {  }
			;

statement:		/* empty */ {  }
			| var ASSIGN expression {  }
			| IF bool_exp THEN statements ELSE statements ENDIF {  }
			| IF bool_exp THEN statements ENDIF {  }
			| WHILE bool_exp BEGINLOOP statements ENDLOOP {  }
			| DO BEGINLOOP statements ENDLOOP WHILE bool_exp {  }
			| READ vars {  }
			| WRITE vars {  }
			| CONTINUE {  }
			| RETURN expression {  }
			;

vars:			/* empty */ {  }
			| var {  }
			| var COMMA vars {  }
			;

bool_exp:		relation_and_exp {  }
			| relation_and_exp OR bool_exp {  }
			;

relation_and_exp:	relation_exp {  }
			| relation_exp AND relation_and_exp {  }
			;

relation_exp:		expression comp expression {  }
			| TRUE {  }
			| FALSE {  }
			| L_PAREN bool_exp R_PAREN {  }
			| NOT expression comp expression {  }
			| NOT TRUE {  }
			| NOT FALSE {  }
			| NOT L_PAREN bool_exp R_PAREN {  }
			;

comp:			EQ {  }
			| NEQ {  }
			| LT  {  }
			| GT  {  }
			| LTE {  }
			| GTE {  }
			;

expression:		mult_exp {  }
			| mult_exp ADD expression {  }
			| mult_exp SUB expression {  }
			;

mult_exp:		term {  }
			| term MULT mult_exp {  }
			| term DIV mult_exp {  }
			| term MOD mult_exp {  }
			;

term:			var {  }
			| NUMBER {  }
			| L_PAREN expression R_PAREN {  }
			| U_MINUS var {  }
			| U_MINUS NUMBER {  }
			| U_MINUS L_PAREN expression R_PAREN {  }
			| identifier L_PAREN expressions R_PAREN {  }
			;

expressions:		/* empty */ {  }
			| expression {  }
			| expression COMMA expressions {  }
			;

var:			identifier {  }
			| identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET {  }
			;

identifiers:		identifier {  }
			| identifier COMMA identifiers {  }
			;

identifier:		IDENT {  }
			;


%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   printf("Syntax error at line %d: \"%s\"\n", currLine, msg);
}


