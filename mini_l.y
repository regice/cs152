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

%right ASSIGN
%left AND OR
%right NOT
%left EQ NEQ LT GT LTE GTE
%left ADD SUB
%left MULT DIV MOD
%right U_MINUS
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN 

%% 
program:		functions { printf("program -> functions"); }
			;

functions:		/* empty */ { printf("functions -> epsilon"); }
			| function functions { printf("functions -> function functions"); }
			;

function:		FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY { printf("function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY"); }
			;

declarations:		/* empty */ { printf("declarations -> epsilon"); }
			| declaration SEMICOLON declarations { printf("declarations -> declaration SEMICOLON declarations"); }
			;

declaration:		/* empty */ { printf("declaration -> epsilon"); }
			| identifiers COLON INTEGER { printf("declaration -> identifiers COLON INTEGER"); }
			| identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER { printf("declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER"); }
			;

statements:		/* empty */ { printf("statements -> epsilon"); }
			| statement SEMICOLON statements { printf("statements -> statement SEMICOLON statements"); }
			;

statement:		/* empty */ { printf("statement -> epsilon"); }
			| var ASSIGN expression { printf("statement -> var ASSIGN expression"); }
			| IF bool_exp THEN statements ELSE statements ENDIF { printf("statement -> IF bool_exp THEN statements ELSE statements ENDIF"); }
			| IF bool_exp THEN statements ENDIF { printf("statement -> IF bool_exp THEN statements ENDIF"); }
			| WHILE bool_exp BEGINLOOP statements ENDLOOP { printf("statement -> WHILE bool_exp BEGINLOOP statements ENDLOOP"); }
			| DO BEGINLOOP statements ENDLOOP WHILE bool_exp { printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_exp"); }
			| READ vars { printf("statement -> READ vars"); }
			| WRITE vars { printf("statement -> WRITE vars"); }
			| CONTINUE { printf("statement -> CONTINUE"); }
			| RETURN expression { printf("statement -> RETURN expression"); }
			;

vars:			/* empty */ { printf("vars -> epsilon"); }
			| var { printf("vars -> var"); }
			| var COMMA vars { printf("vars -> var COMMA vars"); }
			;

bool_exp:		relation_and_exp { printf("bool_exp -> relation_and_exp"); }
			| relation_and_exp OR relation_and_exp { printf("bool_exp -> relation_and_exp OR relation_and_exp"); }
			;

relation_and_exp:	relation_exp { printf("relation_and_exp -> relation_exp"); }
			| relation_exp AND relation_exp { printf("relation_and_exp -> relation_exp AND relation_exp"); }
			;

relation_exp:		expression comp expression { printf("relation_exp -> expression comp expression"); }
			| TRUE { printf("relation_exp -> TRUE"); }
			| FALSE { printf("relation_exp -> FALSE"); }
			| L_PAREN bool_exp R_PAREN { printf("relation_exp -> L_PAREN bool_exp R_PAREN"); }
			| NOT expression comp expression { printf("relation_exp -> NOT expression comp expression"); }
			| NOT TRUE { printf("relation_exp -> NOT TRUE"); }
			| NOT FALSE { printf("relation_exp -> NOT FALSE"); }
			| NOT L_PAREN bool_exp R_PAREN { printf("relation_exp -> NOT L_PAREN bool_exp R_PAREN"); }
			;

comp:			EQ { printf("comp -> EQ"); }
			| NEQ { printf("comp -> NEQ"); }
			| LT  { printf("comp -> LT"); }
			| GT  { printf("comp -> GT"); }
			| LTE { printf("comp -> LTE"); }
			| GTE { printf("comp -> GTE"); }
			;

expression:		mult_exp { printf("expression -> mult_exp"); }
			| mult_exp ADD mult_exp { printf("expression -> mult_exp ADD mult_exp"); }
			| mult_exp SUB mult_exp { printf("expression -> mult_exp SUB mult_exp"); }
			;

mult_exp:		term { printf("mult_exp -> term"); }
			| term MULT term { printf("mult_exp -> term MULT term"); }
			| term DIV term { printf("mult_exp -> term DIV term"); }
			| term MOD term { printf("mult_exp -> term MOD term"); }
			;

term:			var { printf("term -> var"); }
			| NUMBER { printf("term -> NUMBER"); }
			| L_PAREN expression R_PAREN { printf("term -> L_PAREN expression R_PAREN"); }
			| U_MINUS var { printf("term -> U_MINUS var"); }
			| U_MINUS NUMBER { printf("term -> U_MINUS NUMBER"); }
			| U_MINUS L_PAREN expression R_PAREN { printf("term -> U_MINUS L_PAREN expression R_PAREN"); }
			| identifier L_PAREN expressions R_PAREN { printf("term -> identifier L_PAREN expressions R_PAREN"); }
			;

expressions:		/* empty */ { printf("expressions -> epsilon"); }
			| expression COMMA expressions { printf("expressions -> expression COMMA expressions"); }
			;

var:			identifier { printf("var -> identifier"); }
			| identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET { printf("var -> identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET"); }
			;

identifiers:		identifier { printf("identifiers -> identifier"); }
			| identifier COMMA identifiers { printf("identifiers -> identifier COMMA identifiers"); }
			;

identifier:		IDENT { printf("identifier -> IDENT %s", yylval.var); }
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


