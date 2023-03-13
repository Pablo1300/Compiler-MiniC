#define DATOS "Por favor, introduzca los siguientes datos"
#define DATOS "ERROR" //ERROR: Constante redeclarada
#define ANNO 2000
#define PI 3.1416
#define f false
#define l 'L'

int i;

main(){

  //Variables
  int dia, mes, anno;
  float suma= 2*PI;
  string animal; boolean gustos; boolean musica; char inicial;
  string genero; string frase;
  int puntos; //ERROR: Variable redeclarada
  
  //Inicializacion de variables
  inicial = 'E';
  inicial = "P";  //ERROR: Un char con doble comilla, incompatibilidad de tipos.
  musica= true;
  puntos=0;
  frase="Esto esta bien";
  frase="Esto esta mal"  //ERROR: Falta un ;
  
  //Visualizar datos
  printf(DATOS);
  printf(animal); //ERROR: variable sin inicializar
  printf(guitarra); //ERROR: Variable no declarada
  
  //Introduccion del dia de nacimiento
  printf("Introduce el dia de nacimiento:");
  scanf(dia);
  printf(dia);
  if(dia<1 || dia>31){
    printf("La cifra del dia debe estar comprendida entre 1 y 31");
  }
  
  //Introduccion del mes de nacimiento
  printf("Introduce el mes de nacimiento: ");
  scanf(error); //ERROR: Variable NO declarada
  if(mes<1 || mes>12){ 
    printf("La cifra del dia debe estar comprendida entre 1 y 12");
  }
  
  //Introduccion del anno de nacimiento
  printf("Introduce el anno de nacimiento: ");
  scanf(ANNO); //ERROR: Intento de modificar una costante
  scanf(anno);
  
  printf("Fecha: ", dia,"/", mes, "/", anno );

  //Operaciones
  suma=(dia+mes+anno)/50;
  suma="cuarenta"/50; //ERROR: Incompatibilidad de tipos
  error=(dia+mes+anno)/50;  //ERROR: Variable no declarada

  //Condicionales
  if(suma>=0 && suma<=24.5){
     printf("Sometimes it is the people no one imagines anything of who do the things that no one can imagine.");
  }else{
     if (suma>=24.6 && suma<animal){  //ERROR: Incompatibilidad de tipos
     printf("If a machine is expected to be infallible, it cannot also be intelligent.");
  }
  
  //Introduccion de otros datos
  printf("¿Te gustan los animales?");
  scanf(gustos);
  printf(gustos);
  
 
  if (gustos==0){ //ERROR: Incompatibilidad de tipos 
      //Introduccion del animal 
      printf("Nombre del animal");
      scanf(animal);
      
      puntos++;
      suma++;  //ERROR: incremento en float
  }
  
   if (musica==True){ 
   
     puntos = puntos + 10;
     
     if (PI!=DATOS){ //ERROR: Incompatibilidad de tipos
   
          printf("ERROR");
     
     }
     
   }
  
  while(puntos!=0){
	
    printf("Tienes buen gusto");
	puntos --;
	
  }
  
  for(i=0;i < puntos;i++){
  
  	 printf("Tienes buen gusto");
	 puntos --; 
  }
}
}