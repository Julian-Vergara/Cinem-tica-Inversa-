function [x_col, y_col, z_col] = obtener_columnas_xyz(filename, nombre_marcador)
    % Leer los datos del archivo Excel
    T = readmatrix(filename, 'OutputType', 'char'); % Leer como caracteres
    
    % Leer los nombres de los marcadores en la fila 2
    marker_names = T(2, :);
    
    % Leer las indicaciones de si es rotación o posición en la fila 4
    marker_types = T(4, :);
    
    % Reemplazar los valores vacíos por 'NaN'
    marker_names(cellfun(@isempty, marker_names)) = {'NaN'};
    marker_types(cellfun(@isempty, marker_types)) = {'NaN'};
    
    % Inicializar
    x_col = NaN; y_col = NaN; z_col = NaN;

    for col = 1:length(marker_names)
        if strcmp(marker_names{col}, nombre_marcador) && strcmp(marker_types{col}, 'Position')
            x_col = col;
            y_col = col + 1;
            z_col = col + 2;
            break;
        end
    end

    if isnan(x_col)
        fprintf('Marcador %s no encontrado o no es de tipo "Position".\n', nombre_marcador);
    else
        % Extraer solo la parte final del nombre (por ejemplo, 'LASI' de 'Nico:LASI')
        nombre_simple = nombre_marcador;
        idx = strfind(nombre_marcador, ':');
        if ~isempty(idx)
            nombre_simple = nombre_marcador(idx(end)+1:end);
        end
        
        % Imprimir código de extracción de columnas
        fprintf('%s = T(8:end, %d:%d);\n', nombre_simple, x_col, z_col);
    end
end

function datos = extraer_datos_marcador(filename, nombre_marcador)
    
    % Cargar como numérico desde la fila 8 en adelante
    T_numerico = readmatrix(filename);
    
    % Obtener columnas XYZ del marcador
    [x_col, y_col, z_col] = obtener_columnas_xyz(filename, nombre_marcador);
    
    if isnan(x_col)
        fprintf('No se pudieron extraer datos para el marcador %s.\n', nombre_marcador);
        datos = [];
        return;
    end
    
    % Extraer los datos como columnas numéricas
    x_data = T_numerico(8:end, x_col);
    y_data = T_numerico(8:end, y_col);
    z_data = T_numerico(8:end, z_col);

    % Reemplazar NaN (celdas vacías) por 0
    x_data(isnan(x_data)) = 0;
    y_data(isnan(y_data)) = 0;
    z_data(isnan(z_data)) = 0;

    % Mostrar los primeros 10 datos para ver si todo está correcto
    datos = table(x_data, y_data, z_data);
    disp(datos(1:10, :));  % Muestra las primeras 10 filas
end

% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:CLAV');   % Clavícula (central)
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:STRN');   % Esternón
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:T10');    % Vértebra torácica T10
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:T12');    % Vértebra torácica T12
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:RSHO');   % Hombro derecho
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:LSHO');   % Hombro izquierdo
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:LELB');   % Codo izquierdo
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:RELB');   % Codo derecho
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:LWRA');   % Muñeca izquierda A
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:LWRB');   % Muñeca izquierda B
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:RWRA');   % Muñeca derecha A
% extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:RWRB');   % Muñeca derecha B
extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:RFIN');   % Mano derecha B
extraer_datos_marcador('Nico_Chilena_008.xlsx', 'Nico:LFIN');   % Mano derecha B

