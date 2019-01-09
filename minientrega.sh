#! /bin/bash 

# Practica de bash entrega-1.1 
# authors Carlos Rivas Pérez (y160168) Ignacio Llanos Díez-Hochleitner (z170197)

#Si se pide ayuda
if [ $@ = -h ] || [ $@ = --help ]; then
	echo minientrega.sh: Uso: minientrega.sh [identificador de práctica]
	echo minientrega.sh: Copia la practica de un directorio a otro comprobando cierta informacion de la practica
	exit 0
fi

#Si se llama con una entrada no valida, mas de un argumento o ninguno
if [ $# != 1 ]; then
	echo minientrega.sh: "Error(EX_USAGE)", uso incorrecto del mandato "success">&2
	echo minientrega.sh+ Se debe llamar con un solo argumento >&2
	exit 64
fi

#Si MINIENTREGA_CONF no es un directorio legible
if [ -z "$MINIENTREGA_CONF" ] || [ ! -d $MINIENTREGA_CONF ] || [ ! -r $MINIENTREGA_CONF ]; then
	echo minientrega.sh: Error, no se pudo realizar la entrega >&2
	echo minientrega.sh+ no es accesible el directorio $MINIENTREGA_CONF >&2
	exit 64
fi

#Si el directorio accesible no posee un ID_PRACTICA valido 
if [ ! -e $MINIENTREGA_CONF/$@ ] || [ ! -r $MINIENTREGA_CONF/$@ ]; then 
	echo minientrega.sh: Error, no se pudo realizar la entrega >&2
	echo minientrega.sh+ no es accesible el fichero $@ >&2
	exit 66
fi
source $MINIENTREGA_CONF/$@

#Si la fecha es valida. 
#Fecha valida si se encuentra en el formato corrercto: (año-mes-dia)
#Tambien debera estar separada por guiones y con el orden antes expuesto.
#Uso de un mandato dentro de date para conocer si el formato es el correcto
date -d $MINIENTREGA_FECHALIMITE &>/dev/null
if [ $? != 0 ];then
	echo minientrega.sh: Error, no se pudo realizar la entrega >&2
	echo minientrega.sh+ fecha incorrecta $MINIENTREGA_FECHALIMITE >&2
	exit 65
fi

FECHA_FORM_CORRECTO=$(date -d $MINIENTREGA_FECHALIMITE "+%Y-%m-%d" &2>/dev/null)

if [ $MINIENTREGA_FECHALIMITE != $FECHA_FORM_CORRECTO ]; then
	echo minientrega.sh: Error, no se pudo realizar la entrega >&2
	echo minientrega.sh+ fecha incorrecta $MINIENTREGA_FECHALIMITE >&2
	exit 65
fi

FECHA_ENTREGA=$(date "+%Y-%m-%d" &>/dev/null)

if [ "$MINIENTREGA_FECHALIMITE" \< "$FECHA_ENTREGA" ]; then
	echo minientrega.sh: Error, no se pudo realizar la entrega >&2
	echo minientrega.sh+ el plazo acabada el $MINIENTREGA_FECHALIMITE >&2
	exit 65
fi

#Si cada uno de los ficheros de MINIENTREGA_FICHEROS son accesibles
for i in $MINIENTREGA_FICHEROS;do
	if [ ! -e $i ] || [ ! -r $i ]; then 
		echo minientrega.sh: Error, no se pudo realizar la entrega >&2
		echo minientrega.sh+ no es accesible el fichero $i >&2
		exit 66
	fi
done

#Si el directorio $MINIENTREGA_DESTINO existe y se puede escribir
if [ ! -d $MINIENTREGA_DESTINO ] || [ ! -w $MINIENTREGA_DESTINO ]; then
	echo minientrega.sh: Error, no se pudo realizar la entrega >&2
	echo minientrega.sh+ no se pudo crear el subdirectorio de entrega en "destino" >&2
	exit 73
fi

#Bucle para copiar los archivos de los ficheros que se tienen que entregar
mkdir $MINIENTREGA_DESTINO/${USER}

for i in $MINIENTREGA_FICHEROS;do
	cp ./$i $MINIENTREGA_DESTINO/${USER}
done

exit 0
