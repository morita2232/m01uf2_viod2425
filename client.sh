#!/bin/bash


PORT="2022"

echo "Cliente de Dragon Magia Abuelita Miedo 2022"

echo "1. ENVIO DE CABECERA"


echo "DMAM" | nc 127.0.0.1 $PORT

DATA=`nc -l $PORT`

echo "3. COMPROBANDO OK_HEADER"

if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: El Header se envio incorrectamente"
	exit 1
fi

FILE_NAME="dragon.txt"

echo "4. CHECK OK - ENVIANDO FILE_NAME dragon.txt"
echo "FILE_NAME $FILE_NAME" | nc localhost $PORT

DATA=`nc -l $PORT`

echo "7. COMPROBANDO OK_FILE_NAME"

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 2: El nombre se envio incorrectamente"
	exit 2
fi

echo "8. CHECK OK - ENVIANDO CONTENIDO ARCHIVO"

cat client/$FILE_NAME | nc localhost $PORT

