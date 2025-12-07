#!/bin/bash

# si existe la carpeta de intentos anteriores, la borro
if [ -d meteors ]; then
    rm -r meteors
fi

# creo carpeta nueva
mkdir meteors

# cantidad aleatoria entre 500 y 999
total=$(( 500 + RANDOM % 500 ))
echo "Generando $total meteoros..."

# los eventos deben ocurrir en una ventana de 2 dias ( 48h en segundos)
ventana=$(( 48 * 3600 ))

# archivo temporal para guardar offsets
filas_offsets="filas_offsets.txt"
> "$filas_offsets"

# genero offsets aleatorios para cada meteoro
for i in $(seq 1 "$total")
do
    echo $(( (RANDOM * RANDOM) % ventana )) >> "$filas_offsets"
done

# ordeno los offsets para que los eventos queden crecientes
sort -n "$filas_offsets" > offsets.txt
rm "$filas_offsets"

# timestamp inicial
inicio="2025-12-01 02:00:00"
inicio_ts=$(date -d "$inicio" +%s)
i=1

# recorro cada offset y genero su archivo
while read off
do
    # convierto a timestamp final
    ts=$(date -d "@$((inicio_ts + off))" +"%Y-%m-%d %H:%M:%S")

    # valores aleatorios según rango pedido
    dur=$(echo "scale=2; ($RANDOM%50)/10 + 0.1" | bc)
    alt=$(echo "scale=1; 10 + (($RANDOM % 801) / 10)" | bc)
    azi=$(( RANDOM % 360 ))

    # nombre del archivo
    nombre=$(printf "meteors/meteor_%03d.txt" "$i")

    # escribo los datos en formato correcto
    echo "$ts, $dur, $alt, $azi" > "$nombre"

    i=$(( i + 1 ))
done < offsets.txt

# borro archivo temporal final
rm offsets.txt

echo "Listo. Se generaron $total archivos en meteors/"
