% ----------------------------------------
%   SIMETRIZAR TRANSFORMADAS DE FOURIER
% ----------------------------------------
% Ant�n - 21/04-2016
% ----------------------------------------
%
% DESCRIPCI�N:
% ------------------------------
% Simetrizaci�n de la 2D-FFT con respecto a un eje que se introduce a mano.
% La simetrizaci�n se hace con un promedio de las l�neas con respecto a ese
% eje. La funci�n devuelve una matriz orientada del mismo modo que la
% original.
%
% ENTRADAS:
% ------------------------------
% TransformadasEqualizados: CellArray creado con el escript de an�lisis que
%                           contiene las 2D-FFT que queremos simetrizar.
%
% IndiceMapaInicial:    �ndice del mapa en el cual se quiere seleccionar
%                       el eje de simetr�a dentro del cellArray '{k}'
%
% TamanhoX: Tama�o en nm de la imagen en la direcci�n X
%
% TamanhoY: Tama�o en nm de la imagen en la direcci�n Y
% ------------------------------
%
% Nota: Los tama�os se encuentran duplicados para facilitar el an�lisis de
% im�genes de distintos tama�os y puntos en X e Y sin tener que reescribir
% todo el c�digo.
%
% SALIDA:
% ------------------------------
% TransformadasSimetrizadas:    Contiene las matrices simetrizadas en el
%                               eje seleccionado y orientadas del mimo modo
%                               que las originales. Conservan tambi�n su
%                               tama�o en pixeles para simplificar el
%                               tratamiento en posteriores funciones pese a
%                               que las zonas de los bordes generadas con
%                               las distintas rotaciones no tienen sentido.
%

function [TransformadasSimetrizadas] = simetrizarFFT(TransformadasEqualizados,IndiceMapaInicial,TamanhoX,TamanhoY)

% Creamos el cellArray de salida que contendr� las matrices simetrizadas y
% que por conveniencia tendr�n el mismo tama�o que las originales aunque
% los puntos est�n interpolados.
% Los vectores Tamanho hacen falta para pasar de distancia a p�xeles

    [NumeroMapas, Lineas, Columnas] = size(TransformadasEqualizados);
    VectorTamanhoFFTX = linspace(0,Lineas/TamanhoX,Lineas); 
    VectorTamanhoFFTY = linspace(0,Columnas/TamanhoY,Columnas);

    TransformadasSimetrizadasAUX = TransformadasEqualizados;  
    
% Representaci�n para tomar el punto que marca el eje:

    figure
        pcolor(VectorTamanhoFFTX,VectorTamanhoFFTY,TransformadasSimetrizadasAUX{IndiceMapaInicial});
        axis square;
        shading interp;

% Al pulsar el bot�n en el Gui se toma un punto, considerando el otro el
% centro de la matriz (Filas/2,Columnas/2)

    [CoordenadaX, CoordenadaY] = ginput(1);

% Paso las input a pixeles para elegir el numero de puntos e el perfil
 
    [~, PixelXinicioFinal] = min(abs(CoordenadaX-VectorTamanhoFFTX));
	[~, PixelYinicioFinal] = min(abs(CoordenadaY-VectorTamanhoFFTY));

% C�lculo del �ngulo a partir de la tangente de la recta dada:

	PendienteEje = (PixelYinicioFinal - ceil(Lineas/2)) / (PixelXinicioFinal - ceil(Columnas/2));
	Angulo = atand(PendienteEje);

%   Control sobre el valor del �ngulo

        if Angulo == 90
            Angulo = Angulo + 0.001*rand;
        elseif Angulo == 180
            Angulo = Angulo + 0.001*rand;
        else
        end
        
% Rotamos todas las transformadas {IndiceMapa} el �ngulos correspondiente. Siempre
% colocando el punto seleccionado sobre OX+

	for IndiceMapa = 1:NumeroMapas  
        
        if Angulo >= 0;
        	MatrizRotada = imrotate(TransformadasSimetrizadasAUX{IndiceMapa},Angulo);
            
        elseif Angulo <0
            Angulo = 180 + Angulo;
        	MatrizRotada = imrotate(TransformadasSimetrizadasAUX{IndiceMapa},Angulo);
            
        else
            display('�Problemas con la rotaci�n!')
            
        end

%   Localizamos el centro de la matriz Rotada para hacer el zoom que nos
%   interesa guardar, del mismo tama�o en p�xeles que la matriz original

        [FilasMatrizRotada, ColumnasMatrizRotada] = size(MatrizRotada);
        CentroX = round(ColumnasMatrizRotada/2);
        CentroY = round(FilasMatrizRotada/2);

        MatrizRotadaZoom = MatrizRotada(CentroY-Lineas/2+1:CentroY+Lineas/2,CentroX-Columnas/2+1:CentroX+Columnas/2);
        MatrizSymetrizada = MatrizRotadaZoom;
        
%   Dado que el eje se pone en OX+, simetrizamos movi�ndonos en en n�mero de filas 
        
        for i = 1:Lineas/2
            MatrizSymetrizada(i,:) = (1/2)*( MatrizRotadaZoom(i,:) + MatrizRotadaZoom(Lineas-(i-1),:));
            MatrizSymetrizada(Lineas-(i-1),:) = MatrizSymetrizada(i,:);
        end
  
%   Invertimos la matriz antes de sacarla para ponerla en la orientaci�n
%   inicial y hacemos un zoom para conservar el n�mero de puntos.

        MatrizRotadaInversa = imrotate(MatrizSymetrizada,-Angulo);
        MatrizSalida = MatrizRotadaInversa(CentroY-Lineas/2+1:CentroY+Lineas/2,CentroX-Columnas/2+1:CentroX+Columnas/2);
        TransformadasSimetrizadasAUX{IndiceMapa} = MatrizSalida;
        
	end
    
% Asignamos el valor al CellArray de la salida
   
    TransformadasSimetrizadas = TransformadasSimetrizadasAUX;

end