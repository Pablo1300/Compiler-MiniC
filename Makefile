CompilerMiniC: lex.yy.c y.tab.c
	gcc -o CompilerMiniC lex.yy.c y.tab.c -ll	 

lex.yy.c: practica.l
	flex practica.l

y.tab.c: practica.y
	yacc -d practica.y
