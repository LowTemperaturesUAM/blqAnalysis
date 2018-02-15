% ----------------------------------------
%   SIMETRIZAR TRANSFORMADAS DE FOURIER
% ----------------------------------------
% Antón - 21/04-2016
% ----------------------------------------
%
% DESCRIPCIÓN:
% ------------------------------
% Simetrización de la 2D-FFT con respecto a un eje que se introduce a mano.
% La simetrización se hace con un promedio de las líneas con respecto a ese
% eje. La función devuelve una matriz orientada del mismo modo que la
% original.
%
% ENTRADAS:
% ------------------------------
% TransformadasEqualizados: CellArray creado con el escript de análisis que
%                           contiene las 2D-FFT que queremos simetrizar.
%
% IndiceMapaInicial:    Índice del mapa en el cual se quiere seleccionar
%                       el eje de simetría dentro del cellArray '{k}'
%
% TamanhoX: Tamaño en nm de la imagen en la dirección X
%
% TamanhoY: Tamaño en nm de la imagen en la dirección Y
% ------------------------------
%
% Nota: Los tamaños se encuentran duplicados para facilitar el análisis de
% imágenes de distintos tamaños y puntos en X e Y sin tener que reescribir
% todo el código.
%
% SALIDA:
% ------------------------------
% TransformadasSimetrizadas:    Contiene las matrices simetrizadas en el
%                               eje seleccionado y orientadas del mimo modo
%                               que las originales. Conservan también su
%                               tamaño en pixeles para simplificar el
%                               tratamiento en posteriores funciones pese a
%                               que las zonas de los bordes generadas con
%                               las distintas rotaciones no tienen sentido.
%

function [TransformadasSimetrizadas] = simetrizarFFT(TransformadasEqualizados,IndiceMapaInicial,TamanhoX,TamanhoY)

% Creamos el cellArray de salida que contendrá las matrices simetrizadas y
% que por conveniencia tendrán el mismo tamaño que las originales aunque
% los puntos estén interpolados.
% Los vectores Tamanho hacen falta para pasar de distancia a píxeles

    [NumeroMapas, Lineas, Columnas] = size(TransformadasEqualizados);
    VectorTamanhoFFTX = linspace(0,Lineas/TamanhoX,Lineas); 
    VectorTamanhoFFTY = linspace(0,Columnas/TamanhoY,Columnas);

    TransformadasSimetrizadasAUX = TransformadasEqualizados;  
    
% Representación para tomar el punto que marca el eje:

    figure
        pcolor(VectorTamanhoFFTX,VectorTamanhoFFTY,TransformadasSimetrizadasAUX{IndiceMapaInicial});
        axis square;
        shading interp;

% Al pulsar el botón en el Gui se toma un punto, considerando el otro el
% centro de la matriz (Filas/2,Columnas/2)

    [CoordenadaX, CoordenadaY] = ginput(1);

% Paso las input a pixeles para elegir el numero de puntos e el perfil
 
    [~, PixelXinicioFinal] = min(abs(CoordenadaX-VectorTamanhoFFTX));
	[~, PixelYinicioFinal] = min(abs(CoordenadaY-VectorTamanhoFFTY));

% Cálculo del ángulo a partir de la tangente de la recta dada:

	PendienteEje = (PixelYinicioFinal - ceil(Lineas/2)) / (PixelXinicioFinal - ceil(Columnas/2));
	Angulo = atand(PendienteEje);

%   Control sobre el valor del ángulo

        if Angulo == 90
            Angulo = Angulo + 0.001*rand;
        elseif Angulo == 180
            Angulo = Angulo + 0.001*rand;
        else
        end
        
% Rotamos todas las transformadas {IndiceMapa} el ángulos correspondiente. Siempre
% colocando el punto seleccionado sobre OX+

	for IndiceMapa = 1:NumeroMapas  
        
        if Angulo >= 0;
        	MatrizRotada = imrotate(TransformadasSimetrizadasAUX{IndiceMapa},Angulo);
            
        elseif Angulo <0
            Angulo = 180 + Angulo;
        	MatrizRotada = imrotate(TransformadasSimetrizadasAUX{IndiceMapa},Angulo);
            
        else
            display('¡Problemas con la rotación!')
            
        end

%   Localizamos el centro de la matriz Rotada para hacer el zoom que nos
%   interesa guardar, del mismo tamaño en píxeles que la matriz original

        [FilasMatrizRotada, ColumnasMatrizRotada] = size(MatrizRotada);
        CentroX = round(ColumnasMatrizRotada/2);
        CentroY = round(FilasMatrizRotada/2);

        MatrizRotadaZoom = MatrizRotada(CentroY-Lineas/2+1:CentroY+Lineas/2,CentroX-Columnas/2+1:CentroX+Columnas/2);
        MatrizSymetrizada = MatrizRotadaZoom;
        
%   Dado que el eje se pone en OX+, simetrizamos moviéndonos en en número de filas 
        
        for i = 1:Lineas/2
            MatrizSymetrizada(i,:) = (1/2)*( MatrizRotadaZoom(i,:) + MatrizRotadaZoom(Lineas-(i-1),:));
            MatrizSymetrizada(Lineas-(i-1),:) = MatrizSymetrizada(i,:);
        end
  
%   Invertimos la matriz antes de sacarla para ponerla en la orientación
%   inicial y hacemos un zoom para conservar el número de puntos.

        MatrizRotadaInversa = imrotate(MatrizSymetrizada,-Angulo);
        MatrizSalida = MatrizRotadaInversa(CentroY-Lineas/2+1:CentroY+Lineas/2,CentroX-Columnas/2+1:CentroX+Columnas/2);
        TransformadasSimetrizadasAUX{IndiceMapa} = MatrizSalida;
        
	end
    
% Asignamos el valor al CellArray de la salida
   
    TransformadasSimetrizadas = TransformadasSimetrizadasAUX;

end