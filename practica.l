%{

  #include "y.tab.h"

  
  int nLineas=1;
%}
entero	[0-9]+
letra	[a-zA-Z]
real	{entero}+[.]{entero}([eE][-+]?{entero})?
iden	[a-zA-Z][a-zA-Z0-9]*
caracter '(.|\\{letra})'
cadena \"[^\"]*\"
bool true|false|TRUE|FALSE
comentarioSimple (\/)(\/).*
linea \n

%%
define  { return DEFINE;}
    
int { yylval.tipo = 1;
	  return INT;}
	
float { yylval.tipo = 2;
		return FLOAT;}
	
char { yylval.tipo = 3;
	   return CHAR;}
	   
string { yylval.tipo = 4;
	   	 return STRING;}
	   	
boolean {yylval.tipo = 5;
	   	 return BOOLEAN;}
	
main {return MAIN;}
	
printf {return PRINTF;}
		
scanf {return SCANF;}	

if {return IF;}

else {return ELSE;}
	 
while {return WHILE;}

for {return FOR;}
	 
"||"|"&&" {return OPBOOLEANO;}
	 	   
"!" {return OPNOT;}
	 
"<"|">"|(">"|"<"|"="|"!")"="  {return COMPARADORES;}
	
{entero} {yylval.tipo = 1;
	 	 return NUM;}	
		
{real} {yylval.tipo = 2;
	 	 return NUM;}			
	
{caracter} {yylval.tipo = 3;
	        return CARACTER;}
	
{cadena} {yylval.tipo = 4;
		  return CADENA;}
		 	 
{bool} {yylval.tipo = 5;
	    return BOOL;}

{iden}	{ strcpy(yylval.nombreId,yytext);
	      return ID;}
	 	
{comentarioSimple} ;

{linea}  { nLineas++;}

[ \t]	;

.	{return yytext[0];}

%%

int yywrap(){
    return 1;
}
