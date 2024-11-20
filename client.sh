#!/bin/bash

if [ "$1" == "" ]
then
	echo "Debes indicar la direccion del servidor."
	echo "Ejemplo:"
	echo -e "\t$0 127.0.0.1"
	exit 1
fi

IP_SERVER=$1


IP=`ip a | grep "scope global" | xargs | cut -d " " -f 2 | cut -d "/" -f 1`

PORT="2022"

echo "Cliente de Dragon Magia Abuelita Miedo 2022"

echo "1. ENVIO DE CABECERA"


echo "DMAM $IP" | nc $IP_SERVER $PORT

DATA=`nc -l $PORT`

echo "3. COMPROBANDO OK_HEADER"

if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: El Header se envio incorrectamente"
	exit 1
fi

FILE_NAME="dragon.txt"

echo "4. CHECK OK - ENVIANDO FILE_NAME dragon.txt"
echo "FILE_NAME $FILE_NAME" | nc $IP_SERVER $PORT

DATA=`nc -l $PORT`

echo "7. COMPROBANDO OK_FILE_NAME"

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 2: El nombre se envio incorrectamente"
	exit 2
fi

echo "8. CHECK OK - ENVIANDO CONTENIDO ARCHIVO"

cat client/$FILE_NAME | nc $IP_SERVER $PORT

