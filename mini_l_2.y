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
			| var { printf("vars -> var\n"); }
			| var COMMA vars { printf("vars -> var COMMA vars\n"); }
			;

bool_exp:		relation_and_exp { printf("bool_exp -> relation_and_exp\n"); }
			| relation_and_exp OR bool_exp { printf("bool_exp -> relation_and_exp OR bool_exp\n"); }
			;

relation_and_exp:	relation_exp { printf("relation_and_exp -> relation_exp\n"); }
			| relation_exp AND relation_and_exp { printf("relation_and_exp -> relation_exp AND relation_and_exp\n"); }
			;

relation_exp:		expression comp expression { printf("relation_exp -> expression comp expression\n"); }
			| TRUE { printf("relation_exp -> TRUE\n"); }
			| FALSE { printf("relation_exp -> FALSE\n"); }
			| L_PAREN bool_exp R_PAREN { printf("relation_exp -> L_PAREN bool_exp R_PAREN\n"); }
			| NOT expression comp expression { printf("relation_exp -> NOT expression comp expression\n"); }
			| NOT TRUE { printf("relation_exp -> NOT TRUE\n"); }
			| NOT FALSE { printf("relation_exp -> NOT FALSE\n"); }
			| NOT L_PAREN bool_exp R_PAREN { printf("relation_exp -> NOT L_PAREN bool_exp R_PAREN\n"); }
			;

comp:			EQ { printf("comp -> EQ\n"); }
			| NEQ { printf("comp -> NEQ\n"); }
			| LT  { printf("comp -> LT\n"); }
			| GT  { printf("comp -> GT\n"); }
			| LTE { printf("comp -> LTE\n"); }
			| GTE { printf("comp -> GTE\n"); }
			;

expression:		mult_exp { printf("expression -> mult_exp\n"); }
			| mult_exp ADD expression { printf("expression -> mult_exp ADD expression\n"); }
			| mult_exp SUB expression { printf("expression -> mult_exp SUB expression\n"); }
			;

mult_exp:		term { printf("mult_exp -> term\n"); }
			| term MULT mult_exp { printf("mult_exp -> term MULT mult_exp\n"); }
			| term DIV mult_exp { printf("mult_exp -> term DIV mult_exp\n"); }
			| term MOD mult_exp { printf("mult_exp -> term MOD mult_exp\n"); }
			;

term:			var { printf("term -> var\n"); }
			| NUMBER { printf("term -> NUMBER\n"); }
			| L_PAREN expression R_PAREN { printf("term -> L_PAREN expression R_PAREN\n"); }
			| U_MINUS var { printf("term -> U_MINUS var\n"); }
			| U_MINUS NUMBER { printf("term -> U_MINUS NUMBER\n"); }
			| U_MINUS L_PAREN expression R_PAREN { printf("term -> U_MINUS L_PAREN expression R_PAREN\n"); }
			| identifier L_PAREN expressions R_PAREN { printf("term -> identifier L_PAREN expressions R_PAREN\n"); }
			;

expressions:		/* empty */ { printf("expressions -> epsilon\n"); }
			| expression { printf("expressions -> expression\n"); }
			| expression COMMA expressions { printf("expressions -> expression COMMA expressions\n"); }
			;

var:			identifier { printf("var -> identifier\n"); }
			| identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET { printf("var -> identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n"); }
			;

identifiers:		identifier { printf("identifiers -> identifier\n"); }
			| identifier COMMA identifiers { printf("identifiers -> identifier COMMA identifiers\n"); }
			;

identifier:		IDENT { printf("identifier -> IDENT %s\n", yylval.var); }
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


