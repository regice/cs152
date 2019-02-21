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
program:		functions {printf("program -> functions);}
			;

functions:		/* empty */ {printf("functions -> epsilon");}
			| function functions {printf("functions -> function functions");}
			;

function:		FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY");}
			;

declarations:		/* empty */ {printf("declarations -> epsilon");}
			| declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations");}
			;

declaration:		/* empty */ {printf("declaration -> epsilon");}
			| identifiers COLON INTEGER {printf("declaration -> identifiers COLON INTEGER");}
			| identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER");}
			;

statements:		/* empty */ {printf("statements -> epsilon");}
			| statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements");}
			;

statement:		/* empty */ {printf("statement -> epsilon");}
			| var ASSIGN expression {printf("statement -> var ASSIGN expression");}
			| IF bool_exp THEN statement ELSE statement ENDIF {printf("statement -> IF bool_exp THEN statement ELSE statement ENDIF");}
			| WHILE bool_exp BEGINLOOP statement ENDLOOP {printf("statement -> WHILE bool_exp BEGINLOOP statement ENDLOOP");}
			| DO BEGINLOOP statement ENDLOOP WHILE bool_exp {printf("statement -> DO BEGINLOOP statement ENDLOOP WHILE bool_exp");}
			| READ vars {printf("statement -> READ vars");}
			| CONTINUE {printf("statement -> CONTINUE");}
			| RETURN expression {printf("statement -> RETURN expression");}
			;

vars:			/* empty */ {printf("vars -> epsilon");}
			| var {printf("vars -> var");}
			| var COMMA vars {printf("vars -> var COMMA vars");}
			;

bool_exp:		relation_and_exp {printf("bool_exp -> relation_and_exp");}
			| relation_and_exp OR relation_and_exp {printf("bool_exp -> relation_and_exp OR relation_and_exp");}
			;

relation_and_exp:	relation_exp {printf("relation_and_exp -> relation_exp");}
			| relation_exp AND relation_exp {printf("relation_and_exp -> relation_exp AND relation_exp");}
			;

relation_exp:		not expression comp expression {printf("relation_exp -> not expression comp expression");}
			| not TRUE {printf("relation_exp -> not TRUE);}
			| not FALSE {printf("relation_exp -> not FALSE);}
			| not L_PAREN bool_exp R_PAREN {printf("relation_exp -> not L_PAREN bool_exp R_PAREN");}
			;

not:			/* empty */ {printf("not -> epsilon");}
			| NOT {printf("not -> NOT");}
			;

comp:			EQ {printf("comp -> EQ");}
			| NEQ {printf("comp -> NEQ");}
			| LT  {printf("comp -> LT");}
			| GT  {printf("comp -> GT");}
			| LTE {printf("comp -> LTE");}
			| GTE {printf("comp -> GTE");}
			;

expression:		mult_exp {printf("expression -> mult_exp");}
			| mult_exp ADD mult_exp {printf("expression -> mult_exp ADD mult_exp");}
			| mult_exp SUB mult_exp {printf("expression -> mult_exp SUB mult_exp");}
			;

mult_exp:		term {printf("mult_exp -> term");}
			| term MULT term {printf("mult_exp -> term MULT term");}
			| term DIV term {printf("mult_exp -> term DIV term");}
			| term MOD term {printf("mult_exp -> term MOD term");}
			;

term:			var {printf("term -> var");}
			| NUMBER {printf("term -> NUMBER");}
			| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN");}
			| U_MINUS var {printf("term -> U_MINUS var");}
			| U_MINUS NUMBER {printf("term -> U_MINUS NUMBER");}
			| U_MINUS L_PAREN expression R_PAREN {printf("term -> U_MINUS L_PAREN expression R_PAREN");}
			| identifier L_PAREN expressions R_PAREN {printf("term -> identifier L_PAREN expressions R_PAREN");}
			;
			

expressions:		/* empty */ {printf("expressions -> epsilon");}
			| expression COMMA expressions {printf("expressions -> expression COMMA expressions");}
			;

var:			identifier {printf("var -> identifier");}
			| identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET");}
			;

identifiers:		identifier {printf("identifiers -> identifier");}
			| identifier COMMA indentifiers {printf("identifiers -> identifier COMMA identifiers");}
			;

identifier:		








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


