# Manual de Uso de Scripts para Análisis de Marcadores

Este manual describe el uso de dos scripts escritos en MATLAB que permiten obtener datos de posición tridimensional de marcadores corporales a partir de archivos .xlsx exportados desde software de captura de movimiento (por ejemplo, archivos .trc convertidos).

## Script 1: Inversemk3.m

Este script permite convertir los datos de un marcador específico en un vector columna, útil para posteriores cálculos de distancias, trayectorias o análisis cinemáticos.

### Función principal
```matlab
marker = convertir_vector(nombre_archivo, nombre_marcador);
```

### Parámetros
- `nombre_archivo`: Nombre del archivo Excel (.xlsx) que contiene los datos.
- `nombre_marcador`: Nombre del marcador en el archivo (por ejemplo, `'Nico:CLAV'`).

### Salida
- `marker`: Un vector columna con las posiciones XYZ concatenadas del marcador.

---

## Script 2: analytics.m

Este script consta de dos funciones:
1. `obtener_columnas_xyz`: Busca la posición de las columnas XYZ de un marcador específico en un archivo de datos.
2. `extraer_datos_marcador`: Extrae y muestra los datos numéricos de un marcador específico en forma de tabla.

### Uso de las funciones

#### Función `obtener_columnas_xyz`
```matlab
[x_col, y_col, z_col] = obtener_columnas_xyz(filename, nombre_marcador);
```
- Busca en la cabecera del archivo las columnas que contienen los datos XYZ de un marcador.
- También imprime una línea útil para copiar directamente en otros scripts.

#### Función `extraer_datos_marcador`
```matlab
datos = extraer_datos_marcador(filename, nombre_marcador);
```
- Extrae las columnas XYZ del marcador como una tabla.
- Reemplaza valores vacíos por cero.
- Muestra los primeros 10 valores para verificación.

### Dependencias
- Ambas funciones requieren que el archivo contenga:
  - Nombres de marcadores en la fila 2.
  - Tipo de dato (por ejemplo, `'Position'`) en la fila 4.
  - Datos desde la fila 8 en adelante.

---

## Recomendaciones
- Asegúrate de que el archivo Excel tenga el formato esperado.
- Usa nombres exactos de los marcadores (por ejemplo, `'Nico:RSHO'`).
- Si el marcador no se encuentra o no es de tipo `'Position'`, el sistema lo reportará.

---

## Ejemplo
```matlab
datos = extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:RFIN');
```
Muestra los datos de la mano derecha (RFIN) desde el archivo de captura de movimiento.

IMPORTANTE!!!
Los archivos que se suben en ambos código son los de tipo trc sin embargo lo ideal es subirlos excel antes y guardarlos como xlsx siguiendo los siguientes pasos:

Paso a paso: Convertir texto en columnas
Selecciona la columna A completa donde se encuentran los datos no organizados (generalmente la primera columna del archivo CSV abierto).

En la cinta de herramientas de Excel, ve a “Datos” → “Texto en columnas”.

Aparecerá el Asistente para convertir texto en columnas.

Haz clic en “Siguiente”.

En la sección de separadores, selecciona “Coma” (desmarca cualquier otra opción).

Haz clic en “Siguiente” de nuevo.

Configuración avanzada (importante para números decimales)
Haz clic en el botón “Avanzadas…”.

En la nueva ventana:

Asegúrate de que el separador decimal sea el punto (.).

Deja el separador de miles vacío (borra cualquier valor en ese campo).

Haz clic en “Aceptar”.

Finaliza el proceso
Finalmente, haz clic en “Finalizar” para aplicar los cambios.
Los datos ahora estarán organizados correctamente en columnas, listos para ser usados o analizados.

Contacto (judavea2003@hotmail.com)



