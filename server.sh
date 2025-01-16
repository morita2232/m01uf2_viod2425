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

PREFIJO=`echo "$DATA" | cut -d " " -f 1`

NOMBRE_ARCHIVO=`echo "$DATA" | cut -d " " -f 2`

MD5_DE_CLIENTE=`echo "$DATA" | cut -d " " -f 3`

echo "5. COMPROBANDO FILE_NAME"

if [ "$PREFIJO" != "FILE_NAME" ]
then
	echo "ERROR 2: Nombre de archivo incorrecto"
	echo "KO_FILE_NAME" | nc $IP $PORT
	exit 2
fi

MD5_GENERADO=$(echo -n "$NOMBRE_ARCHIVO" | md5sum | cut -d ' ' -f 1)

if [ "$MD5_GENERADO" != "$MD5_DE_CLIENTE" ]
then
	echo "ERROR 3: El MD5 es incorrecto"
	echo "KO_FILE_NAME_MD5" | nc $IP $PORT
	exit 3
fi

echo "6. CHECK OK - ENVIANDO OK_FILE_NAME"

echo "OK_FILE_NAME" | nc $IP $PORT

DATA=`nc -l $PORT`

echo "9. RECIBIMOS Y ALMACENAMOS DATOS"

echo "$DATA" > server/$NOMBRE_ARCHIVO

echo "10. CHECK OK - ENVIANDO OK_ARCHIVO_SAVED"

echo "OK_ARCHIVO_SAVED" | nc $IP $PORT

DATA=`nc -l $PORT`

FILE_MD5_RECIBIDO=`echo $DATA | cut -d ' ' -f 2`

FILE_MD5_CALCULADO=$(md5sum server/$NOMBRE_ARCHIVO | cut -d ' ' -f 1)

if [ "$FILE_MD5_RECIBIDO" != "$FILE_MD5_CALCULADO" ]
then
	echo "ERROR 4: El MD5 se guardo de manera incorrecta"
	echo "KO_FILE_RECIBIDO_MD5" | nc $IP $PORT
	exit 4
fi

echo "13. CHECK OK - ENVIANDO OK_FILE_MD5"

echo "OK_FILE_MD5" | nc $IP $PORT

echo "EJECUTADO CORRECTAMENTE - GRACIAS!"
