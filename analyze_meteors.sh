#!/bin/bash

tiempos="tiempos.txt"
ordenados="fechas_seg.txt"
salida="stats.txt"

echo "Iniciando análisis de eventos de meteoros..."

# limpio archivos si quedaron
rm "$tiempos" 2>/dev/null
rm "$ordenados" 2>/dev/null
rm "$salida" 2>/dev/null

# reviso que la carpeta exista
if [ ! -d "meteors" ]; then
    echo "Error: El directorio 'meteors/' no existe."
    echo "Ejecuta primero: ./generate_meteors.sh"
    exit 1
fi

# convierto la fecha y hora de cada archivo a segundos
for archivo in meteors/*.txt
do
    if read -r linea < "$archivo"; then
        fecha_hora=$(echo "$linea" | cut -d',' -f1)
        date -d "$fecha_hora" +%s >> "$tiempos" 2>/dev/null
    fi
done

# cuento los eventos
eventos=$(wc -l < "$tiempos" 2>/dev/null || echo "0")

if [ "$eventos" -lt 2 ]; then
    echo "Error: Se necesitan al menos 2 eventos para calcular intervalos."
    rm "$tiempos" 2>/dev/null
    exit 1
fi

# ordeno los timestamps
sort -n "$tiempos" > "$ordenados"

# variables para intervalos
antes=0
count=0
total_interval=0

# calculo las diferencias entre cada tiempo
while read ts
do
    if [ "$antes" -ne 0 ]; then
        diff=$(( ts - antes ))
        total_interval=$(( total_interval + diff ))
        count=$(( count + 1 ))
    fi
    antes=$ts
done < "$ordenados"

# promedio usando bc para tener decimales
if [ "$count" -gt 0 ]; then
    promedio=$(echo "scale=2; $total_interval / $count" | bc)
else
    promedio="0.00"
fi

# guardo resultados como pide la rúbrica
{
    echo "Total events: $eventos"
    echo "Average time between meteors: $promedio seconds"
} > "$salida"

cat "$salida"
echo "Análisis completado. Resultados en: $salida"

# borro temporales
rm "$tiempos" 2>/dev/null
rm "$ordenados" 2>/dev/null
