%{
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "listascodigodinamicas.h"

extern int nLineas;

FILE *yyin;
FILE *yyout;

void yyerror(const char* msg) {
    fprintf(yyout, "%s Linea %d\n", msg, nLineas);
}

int yylex(void);


char nfe[20], nfs[20];

lista tablaSimbolos = NULL;

int nErrores = 0;
int tipoAsign;

lista buscarSimbolo(lista tablaSimbolos,char nombre[30]);
void compDeclaraciones(lista* tablaSimbolos, int tipo, int cte, int ini, char nombre[]);

%}
%union{
    char nombreId[30];
    int tipo; //1 - int, 2 - float, 3 - caracter, 4 - cadena, 5 - boolean
}

/*define los tokens*/
%token 	<nombreId> ID
%token  DEFINE
%token  <tipo> INT
%token  <tipo> FLOAT
%token  <tipo> CHAR
%token  <tipo> STRING
%token  <tipo> BOOLEAN
%type 	<tipo> valor
%type 	<tipo> tipo
%type 	<tipo> exp
%type 	<tipo> variosID
%token 	<tipo> NUM
%token  <tipo> CARACTER
%token  <tipo> CADENA
%token  <tipo> BOOL
%token  MAIN
%token  PRINTF
%token  SCANF
%token  IF
%token  ELSE
%token  WHILE
%token  FOR
%token  OPBOOLEANO
%token  OPNOT
%token  COMPARADORES

%left '+' '-'
%left '/' '*'
%left UNARIO

%start  programa



%%
programa:	declaracionesCtes declaracionesVbles declaracionMain

declaracionesCtes: /*vacia*/ 
				   | declaracionCte declaracionesCtes
				   | error {yyerror("\n Declaracion de constante. ");}
				   ;
declaracionCte: '#' DEFINE ID valor  {compDeclaraciones(&tablaSimbolos, $4, 1, 1, $3);};

valor: NUM {$$ = $1;}
		|CARACTER {$$ = $1;}
		|CADENA {$$ = $1;}
		|BOOL {$$ = $1;}
		;


declaracionesVbles: /*vacia*/ 
					| declaracionesVble declaracionesVbles
					| error {yyerror("\n ERROR Declaracion de variable");} 
					;
declaracionesVble: tipo ID ';' {compDeclaraciones(&tablaSimbolos, $1, 0, 0, $2);};

                  | tipo ID '=' exp ';' {lista buscado = buscarSimbolo(tablaSimbolos, $2);
    
    									//Comprobacion para saber si existe un identificador con el mismo nombre de antes
   										if (buscado != NULL){
    										fprintf(yyout, "\n ERROR lin: %d: identificador redeclarado %s",nLineas, buscado->elemento.nombre);
    										nErrores++;
										}
    									else{
                        
                      		    			//Comprobacion de tipos
                      						if ($1 == $4 || ($1 >= $4 && ($1 == 1 || $1 == 2))){
                          			
                      			    			//Simbolo auxiliar de la tabla 
    											tipoelementolista sim;
    	
        										//Se modifica la informacion
       										 	sim.tipo = $1;
        										sim.cte  = 0;
        										sim.inicializado = 1;
        										strcpy(sim.nombre, $2);
        
        										//Se añade simbolo a la tabla de simbolos
        										insertarLista(&tablaSimbolos, sim);
                      			    			
                      						}
                        					else {
                            					fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles en la asignación.",nLineas);
                            					nErrores++;
                            				}
                            			}
    								   };
    				| tipo variosID ';' {tipoAsign = $1;}
    								   
variosID: variosID ',' variosID
		 |ID {compDeclaraciones(&tablaSimbolos, tipoAsign, 0, 0, $1);}
		 |ID '=' exp ';' {compDeclaraciones(&tablaSimbolos, tipoAsign, 0, 0, $1);}
                  
tipo: INT {$$ = $1;}
	 |FLOAT {$$ = $1;}
	 |CHAR {$$ = $1;}
	 |STRING {$$ = $1;}
	 |BOOLEAN {$$ = $1;}
;



declaracionMain: MAIN '('')''{' declaracionesVbles instrucciones'}' | error {yyerror("\n ERROR Instruccion Main ");};


instrucciones: /*vacia*/
			   | instruccion instrucciones
			   ;
instruccion: insAsig | insVis | insLec | insIncDec | senIfElse | senWhile | senFor | error {yyerror("\n ERROR en una instruccion. ");}
			 ;


insAsig: ID '=' exp ';'  {
						  lista buscado = buscarSimbolo(tablaSimbolos, $1);
						  
						  //Comprobacion para saber que existe el identificador
                          if (buscado == NULL){
                 		  		fprintf(yyout, "\n ERROR lin: %d: Variable %s sin declarar.",nLineas, $1);
                 		  		nErrores++;
                          }
                          else{
                          
                          	    //Comprobacion para asegurarse de que se trate de una variable
                          		if (buscado->elemento.cte == 0){
                          		
                          		    //Comprobacion de tipos
                          			if (buscado->elemento.tipo == $3 || (buscado->elemento.tipo >= $3 && ($3 == 1 || $3 == 2))){
                          			
                          			    //La variable esta inicializada
                          			    buscado->elemento.inicializado = 1;
                          			}
                            		else {
                            			fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles en la asignación.",nLineas);
                            			nErrores++;
                            		}
                            	}
                            	else {
                            		fprintf(yyout, "\n ERROR lin: %d: Intento de modificación de la constante %s.",nLineas, buscado->elemento.nombre);
                            		nErrores++;
                            	}
                    	  }
						  }; 
exp: ID 	{  lista buscado = buscarSimbolo(tablaSimbolos, $1);

		       //Comprobacion para saber que existe el identificador
               if (buscado == NULL){
             	   fprintf(yyout, "\n ERROR lin: %d: Variable %s sin declarar.",nLineas, $1);
             	   nErrores++;
               }
               else{
                
                   //Comprobacion para saber si la variable ya esta inicializada
                   if (buscado->elemento.inicializado != 1){
             			fprintf(yyout, "\n ERROR lin: %d: Acceso a la variable %s sin inicializar.",nLineas, buscado->elemento.nombre);
             			nErrores++;
             	   }
             	   else {
             	   		$$ = buscado->elemento.tipo;
             	   }
               }
			 }; 
    |valor {$$ = $1;}
    |exp ope exp {//Comprobacion para saber que existe el identificador
               	  if ($1 > 2 && $3 > 2){
 				  	fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles valor no numerico.",nLineas);
 				  	nErrores++;
               	  }
               	  //Se pasa el tipo en cualquier caso para que el programa pueda seguir comprobando en otros casos
               	  $$ = $1;
    			 };
    |'(' exp ope exp')' {//Comprobacion para saber que existe el identificador
               			if ($2 > 2 && $4 > 2){
        					fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles valor no numerico.",nLineas);
        					nErrores++;
               			}
               			//Se pasa el tipo en cualquier caso para que el programa pueda seguir comprobando en otros casos
               			$$ = $2;
    				   };
    |'-' exp %prec UNARIO {//Comprobacion para saber que existe el identificador
               			   if ($2 > 2){
        						fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles valor no numerico.",nLineas);
        						nErrores++;
               			   }
               			   //Se pasa el tipo en cualquier caso para que el programa pueda seguir comprobando en otros casos
               			   $$ = $2;
    				      };
    
ope: '+' | '-' | '/' | '*'
   ;


insVis: PRINTF '(' datosMostrar ')' ';'  
		;
datosMostrar: exp
			 |exp ',' datosMostrar
             ;

insLec: SCANF '(' ID ')' ';' {  lista buscado = buscarSimbolo(tablaSimbolos, $3);
								
								//Comprobacion para ver si existe el identificador
								if (buscado == NULL){
                    				   fprintf(yyout, "\n ERROR lin: %d: Variable %s sin declarar.",nLineas, $3);
                    				   nErrores++;
                  			    }
                  			    else {
                  			    
                  			    	//Comprobacion para saber que NO se trata de una constante
                  			    	if(buscado->elemento.cte == 0){
                  			    	
                  			    		//Comprobacion para saber si la variable esta inicializada
                  			    		 if (buscado->elemento.inicializado == 0){
                     					 	
                     					 	//El elemento no esta inicializado, entonces se inicializa
                    					 	buscado->elemento.inicializado = 1;  	
                    					 }
                    				}
                    				else {
                    					 fprintf(yyout, "\n ERROR lin: %d: Intento de modificación de la constante %s.",nLineas, buscado->elemento.nombre);
                    					 nErrores++;
                    				}   			
                   				 }

							  }
							  ;

insIncDec: ID operadores ';' {  lista buscado = buscarSimbolo(tablaSimbolos, $1);
							  
							    //Comprobacion para saber que existe el identificador
                          	    if (buscado == NULL){
                 		  			  fprintf(yyout, "\n ERROR lin: %d: Variable %s sin declarar.",nLineas, $1);
                 		  			  nErrores++;
                          	    }
                          	    else {
                          	  
                          	 	      //Comprobacion para saber que NO se trata de una contante --> es una variable
                          	  		  if(buscado->elemento.cte == 0){
                          	  		
                          	  		      //Comprobacion de si esta la variable incializada
                          			  	  if (buscado->elemento.inicializado == 1){
                          				
                          				      //Comprobacion de tipos --> Tiene que ser un entero
                          					  if (buscado->elemento.tipo != 1){
                          					
                          					      //Si no es un entero error:
                            					  fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles en la asignación.",nLineas);       
                            					  nErrores++;                   				
                          					  }
                            			  }
                            			  else {
                            				  fprintf(yyout, "\n ERROR lin: %d: Acceso a la variable %s sin inicializar.",nLineas, buscado->elemento.nombre);
                            				  nErrores++;
                            			  }
                            		   }
                    				   else {
                    					      fprintf(yyout, "\n ERROR lin: %d: Intento de modificación de la constante %s.",nLineas, buscado->elemento.nombre);
                    					      nErrores++;
                    				   }
                    	  	      }
							  }
							  ;
operadores: '+''+' | '-''-' 
             ;

senIfElse: IF '(' expresionesBooleanas ')' '{' instrucciones '}'
		   | IF '(' expresionesBooleanas ')' '{' instrucciones '}' ELSE '{' instrucciones '}' 
		   
expresionesBooleanas: expresionBooleana
					  | OPNOT  expresionBooleana
					  | expresionBooleana OPBOOLEANO expresionesBooleanas
					  | OPNOT expresionBooleana OPBOOLEANO expresionesBooleanas
					  ;
					
expresionBooleana:  exp
				  |	OPNOT exp
				  | exp COMPARADORES exp {//Comprobacion de compatibilidad de tipos
                    	      				 if ($1 != $3 && ($1 > 2 || $3 > 2)){
                        	    			 	fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles en la asignación.",nLineas);
                        	    			 	nErrores++;
											 }
							 			    }
							 			    ;

senWhile: WHILE '(' expresionesBooleanas ')' '{' instrucciones '}' 
;

senFor: FOR '(' insAsig expresionesBooleanas ';' ID operadores ')' '{' instrucciones '}' {  lista buscado = buscarSimbolo(tablaSimbolos, $6);
							  
							    															//Comprobacion para saber que existe el identificador
                          	    															if (buscado == NULL){
                 		  			  															fprintf(yyout, "\n ERROR lin: %d: Variable %s sin declarar.",nLineas, $6);
                 		  			  															nErrores++;
                          	    															}
                          	    															else {
                          	  
                          	 	      															//Comprobacion para saber que NO se trata de una contante --> es una variable
                          	  		  															if(buscado->elemento.cte == 0){
                          	  		
                          	  		      															//Comprobacion de si esta la variable incializada
                          			  	  															if (buscado->elemento.inicializado == 1){
                          				
                          				      															//Comprobacion de tipos --> Tiene que ser un entero
                          					  															if (buscado->elemento.tipo != 1){
                          					
                          					      															//Si no es un entero error:
                            					  															fprintf(yyout, "\n ERROR lin: %d: Tipos incompatibles en la asignación.",nLineas); 
                            					  															nErrores++;                         				
                          					  															}
                            			  															}
                            			 									 						else {
                            				  															fprintf(yyout, "\n ERROR lin: %d: Acceso a la variable %s sin inicializar.",nLineas, buscado->elemento.nombre);
                            				  															nErrores++;
                            			  															}
                            		  						 									}
                    				   														else {
                    					     													 fprintf(yyout, "\n ERROR lin: %d: Intento de modificación de la constante %s.",nLineas, buscado->elemento.nombre);
                    					     													 nErrores++;
                    				   														}
                    	  	      														}
							  															}
							  															;

%%

int main()
{    
	yyin = fopen("ejemplo_errores.c", "r");
	yyout = fopen ("salida.txt", "w");
	yyparse();
	if (yyin != NULL && yyout!= NULL){
		yylex();
		fprintf(yyout,"\nNúmero de líneas: %d", nLineas);
		
		if(nErrores != 0){
			fprintf(yyout, "\nNúmero de errores semánticos: %d", nErrores);
		} else {
			fprintf(yyout, "\nTodo correcto.");
		}
	}
	else {printf("ERROR de apertura ");}
    
 
}

lista buscarSimbolo(lista tablaSimbolos, char nombre[30]) {

    lista sim = (lista)malloc(sizeof(struct componente));
    
    //Recorrido de la tabla de simbolos
    while (!esVaciaLista(tablaSimbolos)){
    
        //Se lee el primero
        primero(tablaSimbolos, &sim);
        
        //Se comprueban los nombres
        if (strcmp(nombre, sim->elemento.nombre) == 0){
        
            //Si hay coincidencias fin
			return sim;
        }
        
        //Se pasa al siguiente
        resto(tablaSimbolos, &tablaSimbolos);
    }
    return NULL;
}

void compDeclaraciones(lista* tablaSimbolos, int tipo, int cte, int ini, char nombre[]) {
	
	lista buscado = buscarSimbolo(*tablaSimbolos, nombre);
    
    //Comprobacion para saber si existe un identificador con el mismo nombre de antes
    if (buscado != NULL){
    	fprintf(yyout, "\n ERROR lin: %d: identificador redeclarado %s",nLineas, buscado->elemento.nombre);
    	nErrores++;
	}
    else{
    
        //Simbolo auxiliar de la tabla 
    	tipoelementolista sim;
    	
        //Se modifica la informacion
        sim.tipo = tipo;
        sim.cte  = cte;
        sim.inicializado = ini;
        strcpy(sim.nombre, nombre);
        
        //Se añade simbolo a la tabla de simbolos
        insertarLista(tablaSimbolos, sim);
   }
}