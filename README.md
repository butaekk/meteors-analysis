Simulación y Análisis Automatizado de Lluvias de Meteoros 
para la tarea 2bis.

El proyecto tiene dos scripts:

1) generate_meteors.sh
Genera entre 500 y 999 archivos con datos de meteoros. 
Los archivos quedan en la carpeta meteors/.

Para ejecutarlo: chmod +x generate_meteors.sh ./generate_meteors.sh

2) analyze_meteors.sh
Recorre los archivos generados, ordena los tiempos y calcula el
intervalo promedio entre meteoros. El resultado se guarda en stats.txt.

Para ejecutarlo: chmod +x analyze_meteors.sh ./analyze_meteors.sh

Estructura básica del proyecto:

° generate_meteors.sh
° analyze_meteors.sh 
° meteors/ 
° stats.txt

Nota: El proyecto es reproducible: si se borra la carpeta y 
se vuelve a ejecutar, se generan valores nuevos dentro del mismo rango.
