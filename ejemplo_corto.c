#define PI 3.1416
#define NUM 8
#define SALUDO "adios amigos"
//declaración de variables globales
int a;
int j;
int b;
int i;
float a; //---redefinición del identificador a
main(){
PI = 3.141595; //---no se puede modificar una cte
scanf(b);
if(PI>j && PI!=0){ //---vble j sin inicializar
printf("entra en el if");
}
j=PI*2; //---tipos incompatibles
i=0;
while(i<10) {
printf("Introduce el valor ");
printf(i);
scanf(j);
j = (j - b) * j;
printf(j);
i++;
}
printf(contLlamadas); //---variables sin declarar
printf(SALUDO);
}