function [Distancia, Perfil, MatrizSurf] = perfilIVPA(ConductanceMap,Voltaje,NormMatrizDatos, VectorTamanhoX, VectorTamanhoY,SaveFolder)

    numero = 1;

% ENTRADAS:
% --------------------------------------------------
% ConductanceMap:   Mapa de conductancia Lineas x Columnas al voltaje que 
%                   se está pintando
%
% MatrizVoltaje:    La matriz Lineas x Columnas x IV que contiene los
%                   voltajes para cada una de las curvas
%
% MatrizNormalizadaCortada: Matriz Lineas x Columnas x IV con los valores
%                           de conductancia en cada punto
%
% TamanhoX: Tamaño en nm de la imagen en x
% TamanhoY: Tamaño en nm de la imagen en y
% ---------------------------------------------------

% Programa que hace perfiles de condcutancia y te da las curvas en cada
% punto. No siempre funciona bien, la idea es que constantemente avance un
% pixel en la direccion (x o y) que mas distancia haya entre el punto final
% e inicial y avance en la otra direccion (y o x) el numero de veces que
% necesita, repartidas entre las equitativamente a lo largo de la primera
% direccion (x e y)
%... Lo siento esta fatale xplicado! ^^'


[IV, ~] = size(NormMatrizDatos);
    Filas       = length(VectorTamanhoY);
    Columnas    = length(VectorTamanhoX);


% Dado que la imagen tiene en x e y la distancia como parámetro (y no los
% píxeles, debemos crear un vector auxiliar que nos ayude a convertir la
% distancia de nuevo a píxeles para encontrar las curvas que queremos
    
    % VectorTamanhoX = linspace(0,75.3,Filas) ;
    % VectorTamanhoY = linspace(0,75.3,Columnas);

% Al pulsar el botón en el Gui se toman dos puntos: inicio y final del perfil 

    [XinicioFinal,YinicioFinal] = ginput (2) %Dos Ginput

% Paso las input a pixeles para elegir el numero de puntos e el perfil
 
	PixelXinicioFinal = zeros(length(XinicioFinal),1);
    PixelYinicioFinal = zeros(length(YinicioFinal),1);
 
    for i = 1:length(XinicioFinal)
        [~, PixelXinicioFinal(i)] = min(abs(XinicioFinal(i)-VectorTamanhoX));
        [~, PixelYinicioFinal(i)] = min(abs(YinicioFinal(i)-VectorTamanhoY));
    end

% El numero de puntos sera el mayor numero entre los pixeles de X e Y.
% (Elección arbitraria en esta función). nPuntosPerfil es un escalar con el
% número de puntos que decidimos tomar en el perfil. En este caso, tantos
% como el eje que varía más.

nPuntosPerfil = max([abs(PixelXinicioFinal(2) - PixelXinicioFinal(1)), abs(PixelYinicioFinal(2) - PixelYinicioFinal(1))])
 abs(PixelXinicioFinal(2) - PixelXinicioFinal(1))
 abs(PixelYinicioFinal(2) - PixelYinicioFinal(1))
% Hago el perfil y me da valores en el mapa usando improfile. Devuelve las
% coordenadas que al venir de la imagen, están en unidades de distancia. y
% hay que pasarlas de nuevo a píxeles

    [CoordenadasX,CoordenadasY,~] = improfile(ConductanceMap,XinicioFinal, YinicioFinal,nPuntosPerfil);

    PixelX = zeros(length(CoordenadasX),1);
    PixelY = zeros(length(CoordenadasY),1);

    for i =1:length(CoordenadasX)
        [~, PixelX(i)] = min(abs(CoordenadasX(i)-VectorTamanhoX));
        [~, PixelY(i)] = min(abs(CoordenadasY(i)-VectorTamanhoY));
    end

% Aquí se pinta sobre la imagen del Gui los puntos correspondientes al
% perfil con un scatter.
    
    hold on
        scatter(CoordenadasX,CoordenadasY,10,'Filled','CData',summer(length(CoordenadasX)))
    hold off

    
% Utilizando los datos guardados en PixelX y PixelY accedemos a los puntos
% del mapa de conductancia para representar el perfil de conductancia al
% bias correspondiente a la imagen mostrada en el Gui.
    
 Perfil = zeros(length(PixelX),1);
 for i=1:length(PixelX)
      Perfil(i) = ConductanceMap(PixelY(i),PixelX(i));
 end

% Para la representación, volvemos a necesitar las unidades en distancia,
% por lo que creamos el vector distancia que corresponde al perfil. Se
% separa en X e Y para simplificar futuras modificaciones considerando
% distinto número de puntos en ambas direcciones. Revisar los índices si se
% llega a tal punto.

TamanhoX = abs(min(VectorTamanhoX))+ abs(max(VectorTamanhoX));
TamanhoY = abs(min(VectorTamanhoY))+ abs(max(VectorTamanhoY));

 
DistanciaX = (PixelX-PixelX(1))*(TamanhoX/Filas);
DistanciaY = (PixelY-PixelY(1))*(TamanhoY/Columnas);
Distancia = sqrt(DistanciaX.^2+DistanciaY.^2);
 
% Imagen donde se representa el perfil al bias seleccionado en la imagen en
% función de la distancia de los píxeles. Notar que no tiene por qué estar
% equiespaciado.

% FigPerfil = figure(233);
%     FigPerfil.Color = [1 1 1];
%     EjePerfil = axes('Parent',FigPerfil,'FontSize',14,'FontName','Arial');
%     hold(EjePerfil,'on');
%         plot(Distancia,Perfil,'g-','Parent',EjePerfil);
%         scatter(Distancia,Perfil,50,'Filled','CData',summer(length(Perfil)),...
%             'Parent',EjePerfil);
%     ylabel(EjePerfil,'Normalized conductance','FontSize',16);
%     xlabel(EjePerfil,'Distance (nm)','FontSize',16);
%     hold(EjePerfil,'off');
    
% Para representar las curvas del perfil, se crea un mapa de colores y una
% matriz (MatrizSurf) que simplificará la representación de datos y el
% guardado de estos en un archivo.
% figure (234)
MatrizSurf = zeros(IV,length(PixelX));
% color = summer(length(PixelX));

% Se representan las curvas del perfil superpuestas en una escala de
% colores que corresponde a éste.

IndiceCurva = zeros(length(PixelX),1);
    
    for contador = 1:length(PixelX)
        IndiceCurva(contador) = (PixelY(contador)-1)*Columnas + PixelX(contador);
        MatrizSurf(:,contador)= smooth(NormMatrizDatos(:,IndiceCurva(contador)));
    end
%      (MatrizSurf)
 
% Para la visualización de las curvas se puede usar un surf. Quizá fuera
% bueno poner una casilla que contenga una opción surf (o no) y otra de
% guardado (o no) de los datos.
% ------------------------------------------------------------------
figure(235)
 
imagesc(Voltaje,Distancia,MatrizSurf');
colormap jet
figure
% % Create figure
FigSurfPerfil = figure('Color',[1 1 1]);
% Create axes
EjeSurfPerfil = axes('Parent',FigSurfPerfil,'FontSize',16,'FontName','Arial',...
    'Position',[0.158351084541563 0.1952 0.651099711483654 0.769800000000001],...
    'CameraPosition',[0 0 5],...
    'YTick',[]);

hold(EjeSurfPerfil,'on');
FigSurfPerfil.Position = [367   286   727   590];

% Create surf
surf(Voltaje,Distancia,MatrizSurf','Parent',EjeSurfPerfil,'MeshStyle','row',...
    'FaceColor','interp');


% Create xlabel
xlabel(EjeSurfPerfil,'Bias voltage (mV)','FontSize',18,'FontName','Arial');
    EjeSurfPerfil.XLim = [min(Voltaje) max(Voltaje)];

% Create ylabel
ylabel(EjeSurfPerfil,'Distance (nm)','FontSize',18,'FontName','Arial','Rotation',90);
    EjeSurfPerfil.YLim = [min(Distancia), max(Distancia)];

% Create zlabel
EjeSurfPerfil.ZTick = [];
caxis([0 10]);
% ----------------------------------------------------------------    

% Guardando datos del surf. Usando dlmwrite no hace falta abrir el archivo,
% se crea automáticamente. El problema es que escrito así machaca los
% perfiles y hay que camibarle el nombre a mano aquí...

	dlmwrite([SaveFolder,'\','PerfilMatrizSurf',num2str(numero),'.txt'],   MatrizSurf,...
        'delimiter','\t')
	dlmwrite([SaveFolder,'\','PerfilDistancia',num2str(numero),'.txt'],    Distancia,...
        'delimiter','\t')
	dlmwrite([SaveFolder,'\','PerfilEnergia',num2str(numero),'.txt'],      Voltaje,...
        'delimiter','\t')
    dlmwrite([SaveFolder,'\','Perfil',num2str(numero),'.txt'],             [Distancia,Perfil,IndiceCurva],...
        'delimiter','\t')
    dlmwrite([SaveFolder,'\','PixelCurvas',num2str(numero),'.txt'],        [PixelY,PixelX],...
        'delimiter','\t')

end

