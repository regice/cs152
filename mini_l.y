   /* CS152 Project Phase 2: Parser Generation Using bison */
   /* The grammar for the MINI-L language */
   /* Written by Brandon Tran */

   /* References:
	https://www.cs.ucr.edu/~amazl001/teaching/webpages2/phase2_parser.html
	https://www.cs.ucr.edu/~amazl001/teaching/webpages2/syntax.html
	http://alumni.cs.ucr.edu/~lgao/teaching/bison.html (bison tutorial)
	https://www.cs.ucr.edu/~amazl001/teaching/webpages2/lab02_solution/calc.y
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
%token SUB ADD MULT DIV MOD
%token EQ NEQ LT GT LTE GTE
%token IDENT NUMBER
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN

%token MULT DIV PLUS MINUS EQUAL L_PAREN R_PAREN END
%token <dval> NUMBER
%type <dval> exp
%left PLUS MINUS
%left MULT DIV
%nonassoc UMINUS


%% 
program:	function

function:	FUNCTION IDENT SEMICOLON BEGINPARAMS Declaration END_PARAMS BEGIN_LOCALS declaration END_LOCALS BEGIN_BODY statement END_BODY	{}

Declaration:	/* empty */
		| IDENT declaration

declaration:	/* empty */
		| COMMA Declaration
		| COLON array INTEGER SEMICOLON

array:		/* empty */
		| ARRAY L_SQUARE_BRACKET NUMBER  R_SQUARE_BRACKET OF 

Statement:	/* empty */
		| Var ASSIGN Expression
		| IF BoolExp THEN Statement SEMICOLON 

identifier:	IDENT {$$ = $1 /* account for identifier string accompanying IDENT */}

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


