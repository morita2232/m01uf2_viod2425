#!/bin/bash


PORT="2022"

echo "Servidor de Dragon Magia Abuelita Miedo 2022"

echo "0. ESCUCHAMOS"

DATA=`nc -l -p $PORT`

HEADER=`echo $DATA | cut -d " " -f 1`
IP=`echo $DATA | cut -d " " -f 2`

if [ "$HEADER" != "DMAM" ]
then
	echo "ERROR 1: Cabecera incorrecta"
	echo "KO_HEADER" | nc $IP $PORT
	exit 1
fi

echo "La IP del cliente es: $IP"

echo "2. CHECK OK - ENVIANDO OK_HEADER"
echo "OK_HEADER" | nc $IP $PORT

DATA=`nc -l $PORT`

PREFIJO=`echo $DATA | cut -d " " -f 1`

NOMBRE_ARCHIVO=`echo $DATA | cut -d " " -f 2`

echo "5. COMPROBANDO FILE_NAME"

if [ "$PREFIJO" != "FILE_NAME" ]
then
	echo "ERROR 2: Nombre de archivo incorrecto"
	echo "KO_FILE_NAME" | nc $IP $PORT
	exit 2
fi

echo "6. CHECK OK - ENVIANDO OK_FILE_NAME"

echo "OK_FILE_NAME" | nc $IP $PORT

DATA=`nc -l $PORT`

echo "9. RECIBIMOS Y ALMACENAMOS DATOS"

echo "$DATA" > server/$NOMBRE_ARCHIVO


