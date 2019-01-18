/* 
 * Description: Simple calculator.
	
 */


NUMBER 		[0-9]
PLUS		"+"
MINUS		"-"
MULT		"*"
DIV		"/"
L_PAREN		"("
R_PAREN		")"
EQUAL		"="

mult_exp	{NUMBER}+(({MULT}|{DIV})*{NUMBER}*)*
expression	{mult_exp}(({PLUS}|{MINUS})*{mult_exp}*)*

exp		({NUMBER}|{PLUS}|{MINUS}|{MULT}|{DIV}|{L_PAREN}|{R_PAREN})*{EQUAL}

%%
{exp}		printf("");
.		{printf("Error."); return;}
%%

main()
{
  yylex();
}
