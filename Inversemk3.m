function modelo_completo_con_video(filename, output_video_name)
    % --- PASO 1: Limpiar TODOS los frames ---
    datos_originales = readmatrix(filename);
    datos_limpios = limpiar_y_interpolar(datos_originales);
    
    % --- PASO 2: Visualizar primer frame (opcional) ---
    visualizar_primer_frame(datos_limpios);
    pause(2);  % Pausa breve para revisión
    
    % --- PASO 3: Crear video con TODOS los frames limpios a 120 fps ---
    crear_video_120fps(datos_limpios, output_video_name);
end

function datos_limpios = limpiar_y_interpolar(datos)
    % (Misma función de limpieza que antes)
    datos_limpios = datos;
    for j = 3:size(datos, 2)
        columna = datos(:, j);
        columna_limpia = medfilt1(columna, 5, 'omitnan', 'truncate');
        nan_indices = isnan(columna_limpia);
        if any(nan_indices)
            indices_normales = find(~nan_indices);
            if numel(indices_normales) >= 2
                columna_limpia = interp1(indices_normales, columna_limpia(indices_normales), ...
                                1:length(columna_limpia), 'spline', 'extrap');
            end
        end
        datos_limpios(:, j) = columna_limpia;
    end
end

function crear_video_120fps(T, video_name)
    % Configurar VideoWriter con perfil compatible
    try
        video = VideoWriter(video_name, 'MPEG-4'); % Intenta con MPEG-4 primero
    catch
        video = VideoWriter(video_name, 'Motion JPEG AVI'); % Fallback a AVI
        disp('Usando perfil Motion JPEG AVI (MPEG-4 no disponible)');
    end
    video.FrameRate = 120;  % 120 fps
    open(video);
    
    % Extraer todos los frames de cada marcador - Tren inferior

    LASI  = T(8:end, 10:12);   RASI  = T(8:end, 13:15);
    LPSI  = T(8:end, 16:18);   RPSI  = T(8:end, 19:21);
    LTHI  = T(8:end,191:193);  RTHI  = T(8:end,230:232);
    LKNE  = T(8:end,188:190);  RKNE  = T(8:end,227:229);
    LTIB  = T(8:end,204:206);  RTIB  = T(8:end,243:245);
    LANK  = T(8:end,201:203);  RANK  = T(8:end,240:242);
    LFoot = T(8:end,211:213);  RFoot = T(8:end,250:252);
    LToe  = T(8:end,263:265);  RToe  = T(8:end,270:272);
    LHEE  = T(8:end,217:219);  RHEE  = T(8:end,256:258);

    % Calcular SACRO como el promedio de LPSI y RPSI
    SACR = (LPSI + RPSI) / 2;


    % Extraer todos los frames de cada marcador - Tren superior
    CLAV = T(8:end, 36:38);   %STRN = T(8:end, 42:44);
    T10  = T(8:end, 39:41);
    LSHO = T(8:end, 51:53);   RSHO = T(8:end, 54:56);
    LELB = T(8:end,100:102);  RELB = T(8:end,149:151);
    LWRA = T(8:end,129:131);  LWRB = T(8:end,126:128);
    RWRA = T(8:end,178:180);  RWRB = T(8:end,175:177);
    LFIN = T(8:end,123:125);  RFIN = T(8:end,172:174);
    
    figure('Visible', 'off');  % Figura invisible para acelerar el proceso
    set(gcf, 'Position', [100, 100, 800, 600]);  % Tamaño del video
    
    for f = 1:size(LASI, 1)
        clf;
        hold on;
        grid on;
        axis equal;
        xlim([-50 150]); ylim([-5 150]); zlim([-150 150]);
        title(sprintf('Frame %d', f));
        
        % --- Dibujar el modelo (copia de tu código de graficar_todos_los_frames) ---
        % Pelvis
        plot3([LASI(f,1) RASI(f,1)], [LASI(f,2) RASI(f,2)], [LASI(f,3) RASI(f,3)], 'g');
        plot3([LASI(f,1) LPSI(f,1)], [LASI(f,2) LPSI(f,2)], [LASI(f,3) LPSI(f,3)], 'g');
        plot3([RASI(f,1) RPSI(f,1)], [RASI(f,2) RPSI(f,2)], [RASI(f,3) RPSI(f,3)], 'g');
        plot3([LPSI(f,1) RPSI(f,1)], [LPSI(f,2) RPSI(f,2)], [LPSI(f,3) RPSI(f,3)], 'g');
        % Conexión entre tren inferior (pelvis) y tren superior (tronco)
        plot3([SACR(f,1) T10(f,1)], [SACR(f,2) T10(f,2)], [SACR(f,3) T10(f,3)], 'k');
        % Conectar pelvis con muslos
        plot3([SACR(f,1) LKNE(f,1)], [SACR(f,2) LKNE(f,2)], [SACR(f,3) LKNE(f,3)], 'r');
        plot3([SACR(f,1) RKNE(f,1)], [SACR(f,2) RKNE(f,2)], [SACR(f,3) RKNE(f,3)], 'b');


        % Lado izquierdo - Tren inferior
        plot3([LASI(f,1) LTHI(f,1)], [LASI(f,2) LTHI(f,2)], [LASI(f,3) LTHI(f,3)], 'r');
        plot3([LTHI(f,1) LKNE(f,1)], [LTHI(f,2) LKNE(f,2)], [LTHI(f,3) LKNE(f,3)], 'r');
        plot3([LKNE(f,1) LTIB(f,1)], [LKNE(f,2) LTIB(f,2)], [LKNE(f,3) LTIB(f,3)], 'r');
        plot3([LTIB(f,1) LANK(f,1)], [LTIB(f,2) LANK(f,2)], [LTIB(f,3) LANK(f,3)], 'r');
        plot3([LANK(f,1) LFoot(f,1)], [LANK(f,2) LFoot(f,2)], [LANK(f,3) LFoot(f,3)], 'r');
        plot3([LFoot(f,1) LToe(f,1)], [LFoot(f,2) LToe(f,2)], [LFoot(f,3) LToe(f,3)], 'r');
        plot3([LFoot(f,1) LHEE(f,1)], [LFoot(f,2) LHEE(f,2)], [LFoot(f,3) LHEE(f,3)], 'r');
        plot3([LANK(f,1) LToe(f,1)], [LANK(f,2) LToe(f,2)], [LANK(f,3) LToe(f,3)], 'r');
        plot3([LToe(f,1) LHEE(f,1)], [LToe(f,2) LHEE(f,2)], [LToe(f,3) LHEE(f,3)], 'r');
        plot3([LKNE(f,1) LHEE(f,1)], [LKNE(f,2) LHEE(f,2)], [LKNE(f,3) LHEE(f,3)], 'r');


        % Lado derecho - Tren inferior
        plot3([RASI(f,1) RTHI(f,1)], [RASI(f,2) RTHI(f,2)], [RASI(f,3) RTHI(f,3)], 'b');
        plot3([RTHI(f,1) RKNE(f,1)], [RTHI(f,2) RKNE(f,2)], [RTHI(f,3) RKNE(f,3)], 'b');
        plot3([RKNE(f,1) RTIB(f,1)], [RKNE(f,2) RTIB(f,2)], [RKNE(f,3) RTIB(f,3)], 'b');
        plot3([RTIB(f,1) RANK(f,1)], [RTIB(f,2) RANK(f,2)], [RTIB(f,3) RANK(f,3)], 'b');
        plot3([RANK(f,1) RFoot(f,1)], [RANK(f,2) RFoot(f,2)], [RANK(f,3) RFoot(f,3)], 'b');
        plot3([RFoot(f,1) RToe(f,1)], [RFoot(f,2) RToe(f,2)], [RFoot(f,3) RToe(f,3)], 'b');
        plot3([RFoot(f,1) RHEE(f,1)], [RFoot(f,2) RHEE(f,2)], [RFoot(f,3) RHEE(f,3)], 'b');
        plot3([RANK(f,1) RToe(f,1)], [RANK(f,2) RToe(f,2)], [RANK(f,3) RToe(f,3)], 'b');
        plot3([RToe(f,1) RHEE(f,1)], [RToe(f,2) RHEE(f,2)], [RToe(f,3) RHEE(f,3)], 'b');
        plot3([RKNE(f,1) RHEE(f,1)], [RKNE(f,2) RHEE(f,2)], [RKNE(f,3) RHEE(f,3)], 'b')

        % Brazos izquierdos
        plot3([LSHO(f,1) LELB(f,1)], [LSHO(f,2) LELB(f,2)], [LSHO(f,3) LELB(f,3)], 'm');
        plot3([LELB(f,1) LWRA(f,1)], [LELB(f,2) LWRA(f,2)], [LELB(f,3) LWRA(f,3)], 'm');
        plot3([LWRA(f,1) LWRB(f,1)], [LWRA(f,2) LWRB(f,2)], [LWRA(f,3) LWRB(f,3)], 'm');
        plot3([LELB(f,1) LWRB(f,1)], [LELB(f,2) LWRB(f,2)], [LELB(f,3) LWRB(f,3)], 'm');
        plot3([LWRA(f,1) LFIN(f,1)], [LWRA(f,2) LFIN(f,2)], [LWRA(f,3) LFIN(f,3)], 'm');
        plot3([LWRB(f,1) LFIN(f,1)], [LWRB(f,2) LFIN(f,2)], [LWRB(f,3) LFIN(f,3)], 'm');

        % Brazos derechos
        plot3([RSHO(f,1) RELB(f,1)], [RSHO(f,2) RELB(f,2)], [RSHO(f,3) RELB(f,3)], 'c');
        plot3([RELB(f,1) RWRA(f,1)], [RELB(f,2) RWRA(f,2)], [RELB(f,3) RWRA(f,3)], 'c');
        plot3([RWRA(f,1) RWRB(f,1)], [RWRA(f,2) RWRB(f,2)], [RWRA(f,3) RWRB(f,3)], 'c');
        plot3([RELB(f,1) RWRB(f,1)], [RELB(f,2) RWRB(f,2)], [RELB(f,3) RWRB(f,3)], 'c');
        plot3([RWRA(f,1) RFIN(f,1)], [RWRA(f,2) RFIN(f,2)], [RWRA(f,3) RFIN(f,3)], 'c');
        plot3([RWRB(f,1) RFIN(f,1)], [RWRB(f,2) RFIN(f,2)], [RWRB(f,3) RFIN(f,3)], 'c');

        % Tronco
        plot3([T10(f,1) CLAV(f,1)], [T10(f,2) CLAV(f,2)], [T10(f,3) CLAV(f,3)], 'k');
        plot3([LSHO(f,1) LASI(f,1)], [LSHO(f,2) LASI(f,2)], [LSHO(f,3) LASI(f,3)], 'k');
        plot3([RSHO(f,1) RASI(f,1)], [RSHO(f,2) RASI(f,2)], [RSHO(f,3) RASI(f,3)], 'k');

        % Tronco y brazos 
        plot3([CLAV(f,1) T10(f,1)], [CLAV(f,2) T10(f,2)], [CLAV(f,3) T10(f,3)], 'k');
        plot3([CLAV(f,1) LSHO(f,1)], [CLAV(f,2) LSHO(f,2)], [CLAV(f,3) LSHO(f,3)], 'k');
        plot3([CLAV(f,1) RSHO(f,1)], [CLAV(f,2) RSHO(f,2)], [CLAV(f,3) RSHO(f,3)], 'k');

        % Conectar hombros con el tronco
        plot3([CLAV(f,1) LSHO(f,1)], [CLAV(f,2) LSHO(f,2)], [CLAV(f,3) LSHO(f,3)], 'k');
        plot3([CLAV(f,1) RSHO(f,1)], [CLAV(f,2) RSHO(f,2)], [CLAV(f,3) RSHO(f,3)], 'k');
        plot3([T10(f,1) LSHO(f,1)], [T10(f,2) LSHO(f,2)], [T10(f,3) LSHO(f,3)], 'k');
        plot3([T10(f,1) RSHO(f,1)], [T10(f,2) RSHO(f,2)], [T10(f,3) RSHO(f,3)], 'k');

        
        % Capturar el frame y añadirlo al video
        frame = getframe(gcf);
        writeVideo(video, frame);
    end
    
    close(video);
    disp(['Video guardado como: ', video_name]);
end

% --- Funciones auxiliares (opcionales) ---
function visualizar_primer_frame(T)
    % Extraer primer frame de cada marcador - Tren inferior
    LASI = T(8,10:12);  RASI = T(8,13:15);
    LPSI = T(8,16:18);  RPSI = T(8,19:21);
    LTHI = T(8,191:193); RTHI = T(8,230:232);
    LKNE = T(8,188:190); RKNE = T(8,227:229);
    LTIB = T(8,204:206); RTIB = T(8,243:245);
    LANK = T(8,201:203); RANK = T(8,240:242);
    LFoot = T(8,211:213); RFoot = T(8,250:252);
    LToe = T(8,263:265); RToe = T(8,270:272);
    LHEE = T(8,217:219); RHEE = T(8,256:258);
                         
    % Extraer primer frame de cada marcador - Tren superior
    CLAV = T(8,36:38);   %STRN = T(8,42:44);
    T10  = T(8,39:41);
    LSHO = T(8,51:53);   RSHO = T(8,54:56);
    LELB = T(8,100:102); RELB = T(8,149:151);
    LWRA = T(8,129:131); LWRB = T(8,126:128);
    RWRA = T(8,178:180); RWRB = T(8,175:177);
    LFIN = T(8,123:125); RFIN = T(8,172:174);
    % Calcular SACRO como el promedio de LPSI y RPSI
    SACR = (LPSI + RPSI) / 2;

    figure;
    hold on;
    grid on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Modelo computacional - Primer frame');

    plot3([LASI(1) RASI(1)], [LASI(2) RASI(2)], [LASI(3) RASI(3)], 'g');
    plot3([LASI(1) LPSI(1)], [LASI(2) LPSI(2)], [LASI(3) LPSI(3)], 'g');
    plot3([RASI(1) RPSI(1)], [RASI(2) RPSI(2)], [RASI(3) RPSI(3)], 'g');
    plot3([LPSI(1) RPSI(1)], [LPSI(2) RPSI(2)], [LPSI(3) RPSI(3)], 'g');
    
    % Lado izquierdo - Tren inferior
    plot3([LASI(1) LTHI(1)], [LASI(2) LTHI(2)], [LASI(3) LTHI(3)], 'r');
    plot3([LTHI(1) LKNE(1)], [LTHI(2) LKNE(2)], [LTHI(3) LKNE(3)], 'r');
    plot3([LKNE(1) LTIB(1)], [LKNE(2) LTIB(2)], [LKNE(3) LTIB(3)], 'r');
    plot3([LTIB(1) LANK(1)], [LTIB(2) LANK(2)], [LTIB(3) LANK(3)], 'r');
    plot3([LANK(1) LFoot(1)], [LANK(2) LFoot(2)], [LANK(3) LFoot(3)], 'r');
    plot3([LFoot(1) LToe(1)], [LFoot(2) LToe(2)], [LFoot(3) LToe(3)], 'r');
    plot3([LFoot(1) LHEE(1)], [LFoot(2) LHEE(2)], [LFoot(3) LHEE(3)], 'r');
    plot3([LANK(1) LToe(1)], [LANK(2) LToe(2)], [LANK(3) LToe(3)], 'r');
    plot3([LToe(1) LHEE(1)], [LToe(2) LHEE(2)], [LToe(3) LHEE(3)], 'r');
    plot3([LKNE(1) LHEE(1)], [LKNE(2) LHEE(2)], [LKNE(3) LHEE(3)], 'r');
    
    % Lado derecho - Tren inferior
    plot3([RASI(1) RTHI(1)], [RASI(2) RTHI(2)], [RASI(3) RTHI(3)], 'b');
    plot3([RTHI(1) RKNE(1)], [RTHI(2) RKNE(2)], [RTHI(3) RKNE(3)], 'b');
    plot3([RKNE(1) RTIB(1)], [RKNE(2) RTIB(2)], [RKNE(3) RTIB(3)], 'b');
    plot3([RTIB(1) RANK(1)], [RTIB(2) RANK(2)], [RTIB(3) RANK(3)], 'b');
    plot3([RANK(1) RFoot(1)], [RANK(2) RFoot(2)], [RANK(3) RFoot(3)], 'b');
    plot3([RFoot(1) RToe(1)], [RFoot(2) RToe(2)], [RFoot(3) RToe(3)], 'b');
    plot3([RFoot(1) RHEE(1)], [RFoot(2) RHEE(2)], [RFoot(3) RHEE(3)], 'b');
    plot3([RANK(1) RToe(1)], [RANK(2) RToe(2)], [RANK(3) RToe(3)], 'b');
    plot3([RToe(1) RHEE(1)], [RToe(2) RHEE(2)], [RToe(3) RHEE(3)], 'b');
    plot3([RKNE(1) RHEE(1)], [RKNE(2) RHEE(2)], [RKNE(3) RHEE(3)], 'b')
    
    % Tronco y brazos con hombros
    plot3([CLAV(1) T10(1)], [CLAV(2) T10(2)], [CLAV(3) T10(3)], 'k');
    plot3([CLAV(1) LSHO(1)], [CLAV(2) LSHO(2)], [CLAV(3) LSHO(3)], 'k');
    plot3([CLAV(1) RSHO(1)], [CLAV(2) RSHO(2)], [CLAV(3) RSHO(3)], 'k');
    
    % Brazos izquierdos
    plot3([LSHO(1) LELB(1)], [LSHO(2) LELB(2)], [LSHO(3) LELB(3)], 'm');
    plot3([LELB(1) LWRA(1)], [LELB(2) LWRA(2)], [LELB(3) LWRA(3)], 'm');
    plot3([LWRA(1) LWRB(1)], [LWRA(2) LWRB(2)], [LWRA(3) LWRB(3)], 'm');
    plot3([LELB(1) LWRB(1)], [LELB(2) LWRB(2)], [LELB(3) LWRB(3)], 'm');
    plot3([LWRA(1) LFIN(1)], [LWRA(2) LFIN(2)], [LWRA(3) LFIN(3)], 'm');
    plot3([LWRB(1) LFIN(1)], [LWRB(2) LFIN(2)], [LWRB(3) LFIN(3)], 'm');

    % Brazos derechos
    plot3([RSHO(1) RELB(1)], [RSHO(2) RELB(2)], [RSHO(3) RELB(3)], 'c');
    plot3([RELB(1) RWRA(1)], [RELB(2) RWRA(2)], [RELB(3) RWRA(3)], 'c');
    plot3([RWRA(1) RWRB(1)], [RWRA(2) RWRB(2)], [RWRA(3) RWRB(3)], 'c');
    plot3([RELB(1) RWRB(1)], [RELB(2) RWRB(2)], [RELB(3) RWRB(3)], 'c');
    plot3([RWRA(1) RFIN(1)], [RWRA(2) RFIN(2)], [RWRA(3) RFIN(3)], 'c');
    plot3([RWRB(1) RFIN(1)], [RWRB(2) RFIN(2)], [RWRB(3) RFIN(3)], 'c');

    % Conectar pelvis con muslos
    plot3([SACR(1) LKNE(1)], [SACR(2) LKNE(2)], [SACR(3) LKNE(3)], 'r');
    plot3([SACR(1) RKNE(1)], [SACR(2) RKNE(2)], [SACR(3) RKNE(3)], 'b');
    
    % Conectar el tronco de forma más natural
    plot3([T10(1) CLAV(1)], [T10(2) CLAV(2)], [T10(3) CLAV(3)], 'k');
    plot3([LSHO(1) LASI(1)], [LSHO(2) LASI(2)], [LSHO(3) LASI(3)], 'k');
    plot3([RSHO(1) RASI(1)], [RSHO(2) RASI(2)], [RSHO(3) RASI(3)], 'k');

    % Conexión entre tren inferior (pelvis) y tren superior (tronco)
    plot3([SACR(1) T10(1)], [SACR(2) T10(2)], [SACR(3) T10(3)], 'k');

    % Conectar hombros con el tronco
    plot3([CLAV(1) LSHO(1)], [CLAV(2) LSHO(2)], [CLAV(3) LSHO(3)], 'k');
    plot3([CLAV(1) RSHO(1)], [CLAV(2) RSHO(2)], [CLAV(3) RSHO(3)], 'k');
    plot3([T10(1) LSHO(1)], [T10(2) LSHO(2)], [T10(3) LSHO(3)], 'k');
    plot3([T10(1) RSHO(1)], [T10(2) RSHO(2)], [T10(3) RSHO(3)], 'k');
    view(3);
end
function analisis_articulaciones_pdf(filename, output_pdf_name)
    % --- PASO 1: Cargar y limpiar datos ---
    datos_originales = readmatrix(filename);
    datos_limpios = limpiar_y_interpolar(datos_originales);
    
    % --- PASO 2: Definir marcadores y articulaciones ---
    LASI  = datos_limpios(8:end, 10:12);   RASI  = datos_limpios(8:end, 13:15);
    LPSI  = datos_limpios(8:end, 16:18);   RPSI  = datos_limpios(8:end, 19:21);
    LKNE  = datos_limpios(8:end, 188:190); RKNE  = datos_limpios(8:end, 227:229);
    LANK  = datos_limpios(8:end, 201:203); RANK  = datos_limpios(8:end, 240:242);
    LTHI  = datos_limpios(8:end, 191:193); RTHI  = datos_limpios(8:end, 230:232);
    LFoot = datos_limpios(8:end, 211:213); RFoot = datos_limpios(8:end, 250:252);
    LSHO  = datos_limpios(8:end, 51:53);   RSHO  = datos_limpios(8:end, 54:56);
    LELB  = datos_limpios(8:end, 100:102); RELB  = datos_limpios(8:end, 149:151);
    
    % --- PASO 3: Calcular ángulos y crear gráficas ---
    fig = figure('Visible', 'off', 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);
    orient(fig, 'landscape');
    
    % Lista de articulaciones y planos a analizar
    articulaciones = {
        {'Rodilla Izq', LTHI, LKNE, LANK}, {'Rodilla Der', RTHI, RKNE, RANK};
        {'Cadera Izq', LASI, LTHI, LKNE},  {'Cadera Der', RASI, RTHI, RKNE};
        {'Tobillo Izq', LKNE, LANK, LFoot}, {'Tobillo Der', RKNE, RANK, RFoot};
        {'Hombro Izq', LSHO, LELB, LKNE},  {'Hombro Der', RSHO, RELB, RKNE};
        {'Pelvis', LASI, RASI, LPSI},       {}, % Solo pelvis (transversal)
    };
    
    planos = {'Sagital', 'Frontal', 'Transversal'};
    
    % Crear PDF
    for i = 1:size(articulaciones, 1)
        for j = 1:size(articulaciones, 2)
            if ~isempty(articulaciones{i,j})
                nombre_artic = articulaciones{i,j}{1};
                p1 = articulaciones{i,j}{2}; p2 = articulaciones{i,j}{3}; p3 = articulaciones{i,j}{4};
                
                for k = 1:length(planos)
                    % Calcular ángulo
                    angulo = calcular_angulo(p1, p2, p3, planos{k});
                    
                    % Graficar
                    clf(fig);
                    plot(angulo, 'LineWidth', 1.5);
                    title(sprintf('%s - Plano %s', nombre_artic, planos{k}), 'Interpreter', 'none');
                    xlabel('Frames'); ylabel('Ángulo (grados)');
                    grid on;
                    
                    % Añadir al PDF
                    exportgraphics(fig, output_pdf_name, 'Append', true);
                end
            end
        end
    end
    
    close(fig);
    disp(['PDF guardado como: ' output_pdf_name]);
end

% --- Función auxiliar: Cálculo de ángulos (igual que antes) ---
function angulo = calcular_angulo(p1, p2, p3, plano)
    v1 = p1 - p2;
    v2 = p3 - p2;
    
    switch lower(plano)
        case 'sagital'
            angulo = atan2d(v1(:,3), v1(:,2)) - atan2d(v2(:,3), v2(:,2));
        case 'frontal'
            angulo = atan2d(v1(:,3), v1(:,1)) - atan2d(v2(:,3), v2(:,1));
        case 'transversal'
            angulo = atan2d(v1(:,2), v1(:,1)) - atan2d(v2(:,2), v2(:,1));
    end
    angulo = mod(angulo + 360, 360);
end

modelo_completo_con_video('Nico_Chilena_008.xlsx', 'video_salida.mp4');
analisis_articulaciones_pdf('Nico_Chilena_008.xlsx', 'angulos_chilena.pdf');
