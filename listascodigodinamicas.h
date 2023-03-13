#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct simbolo{
    char nombre[30];
    int tipo; //1 - int, 2 - float, 3 - caracter, 4 - cadena, 5 - boolean
    int cte; //0 - NO, 1 - SI
    int inicializado; //0 - NO, 1 - SI
};

typedef struct simbolo tipoelementolista;

typedef  struct componente* lista;

struct componente
{
	tipoelementolista elemento;
	lista enlace;
};



void listaVacia(lista* l)
{
	*l=NULL;
}

int esVaciaLista(lista l)
{
	return (l==NULL);
}

void insertarLista(lista *l, tipoelementolista x)
{
	lista aux;

	aux=(struct componente *)malloc(sizeof(struct componente));
	if (aux==NULL)
	{
		printf("No hay memoria. No se puede realizar la insercion\n");
	}
	else
	{
		aux->elemento=x;
		aux->enlace=*l;
		*l=aux;
	}
}

void primero(lista l, lista *prim)
{
	if (l==NULL)
	{
		printf("La lista esta vacia");
	}
	else
	{
		*prim=l;
	}
}

void resto(lista l, lista *sigl)
{
	if (l==NULL)
	{
		printf("Lista vacia");
	}
	else
	{
		*sigl=l->enlace;
	}
}