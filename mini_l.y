   /* CS152 Project Phase 2: Parser Generation Using bison */
   /* The grammar for the MINI-L language */
   /* Written by Brandon Tran */

   /* References:
	Project Spec: https://www.cs.ucr.edu/~amazl001/teaching/webpages2/phase2_parser.html
	Syntax diagrams: https://www.cs.ucr.edu/~amazl001/teaching/webpages2/syntax.html
	Bison tutorial: http://alumni.cs.ucr.edu/~lgao/teaching/bison.html
	lab 2 solution (used for ref on how to write .y files): https://www.cs.ucr.edu/~amazl001/teaching/webpages2/lab02_solution/calc.y
   */

%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
  double dval;
  int ival;
}

%error-verbose
%start program
%token FUNCTION 
%token BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
%token INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN
%left SUB ADD MULT DIV MOD
%left EQ NEQ LT GT LTE GTE
%token IDENT NUMBER
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN

%token MULT DIV PLUS MINUS EQUAL L_PAREN R_PAREN END
%token <dval> NUMBER
%type <dval> exp
%left PLUS MINUS
%left MULT DIV
%nonassoc UMINUS


%% 
program:		functions
			;

functions:		/* empty */
			| function functions
			;

function:		FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY	
			;

declarations:		/* empty */
			| declaration SEMICOLON declarations
			;

declaration:		/* empty */
			| identifiers COLON INTEGER
			| identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER  R_SQUARE_BRACKET OF INTEGER
			;

statements:		/* empty */
			| statement SEMICOLON statements
			;

statement:		/* empty */
			| var ASSIGN expression
			| IF bool_exp THEN statement ELSE statement ENDIF
			| WHILE bool_exp BEGINLOOP statement ENDLOOP
			| DO BEGINLOOP statement ENDLOOP WHILE bool_exp
			| READ vars
			| CONTINUE
			| RETURN expression
			;

bool_exp:		relation_and_exp
			| relation_and_exp OR relation_and_exp
			;

relation_and_exp:	relation_exp
			| relation_exp AND relation_exp
			;

relation_exp:		not expression comp expression
			| not TRUE			
			| not FALSE
			| not L_PAREN bool_exp R_PAREN
			;

not:			/* empty */
			| NOT
			;

comp:			EQ 
			| NEQ 
			| LT 
			| GT 
			| LTE 
			| GTE
			;

expression:		mult_exp
			| mult_exp ADD mult_exp
			| mult_exp SUB mult_exp
			;

mult_exp:		term
			| term MULT term
			| term DIV term
			| term MOD term
			;

term:			var /*include SUB in front of this production*/
			| NUMBER /*include SUB in front of this production*/
			| L_PAREN expression R_PAREN /*include SUB in front of this production*/
			| identifier L_PAREN expressions R_PAREN

expressions:		/* empty */
			| expression COMMA expressions
			;

var:			

identifier:	IDENT {$$ = $1 /* TO-DO: account for identifier string accompanying IDENT */}

input:	
	| input line
	;

line:	exp EQUAL END         { printf("\t%f\n", $1);}
	;

exp:	NUMBER                { $$ = $1; }
	| exp PLUS exp        { $$ = $1 + $3; }
	| exp MINUS exp       { $$ = $1 - $3; }
	| exp MULT exp        { $$ = $1 * $3; }
	| exp DIV exp         { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; }
	| MINUS exp %prec UMINUS { $$ = -$2; }
	| L_PAREN exp R_PAREN { $$ = $2; }
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
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}


