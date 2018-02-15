% CARGAR IMAGEN BLQ
% ----------------------------------------
% Pepe  06/07/2015
% Ant�n 13/07/2015 - Modificaci�n
% Ant�n 28/07/2015 - Modificaci�n
% Ant�n 31/03/2016 - Modificaci�n
% Ant�n 21/10/2016 - Modificaci�n: reordendo las matrices de vuelta
% ----------------------------------------
%
% Esta funci�n carga el fichero blq (filename) y lo guarda en una serie de
% matrices cuyos nombres corresponden a la ida/vuelta en topograf�a e
% Ida/Vuelta en espectroscop�a. Este formato viene dado por c�mo se
% estructura el archivo .blq en el que las l�neas se guardan seguidas y en el orden en
% que se toman. Para cada una de estas situaciones se almacenan dos
% matrices (una para voltaje y otra para corriente).
%
% ENTRADA:
%   Estructura "Total" creada con blqreaderV9 a partir de un arvhivo .blq
%   Numero de filas y columnas de la imagen
%
% SALIDA: 
%   Total: Estructura que contiene todos los datos.
%   voltaje: Matriz correspondiente a los voltajes (todos iguales)
%   matrices corriente: tienen los valores de corriente para los casos
%       especificados en sus nombres. La primera parte del nombre se
%       refiere a la direcci�n en topograf�a y la segunda a la direcci�n en
%       espectroscop�a. As� "idaVuelta" contiene los datos para ida en
%       topograf�a y vuelta en espectroscop�a
% ----------------------------------------.

function [Voltaje,IdaIda,IdaVuelta,VueltaIda,VueltaVuelta] = Matriz_Pepe_VPA(Total,Filas,Columnas)


%NPuntosTotal = length(Total)-1;   % # total de curvas en el archivo blq
IV = length(Total(1).data);     % # de puntos en cada curva IV
% Filas = sqrt(NPuntosTotal)/2;  % # de l�neas en la imagen del espacio real
% Columnas = NPuntosTotal/(4*Filas);

    fprintf('COPIANDO DATOS:');
% ------------------------------------------
% Las matrices de salida son:
    Voltaje      = zeros(IV,1);
    IdaIda       = zeros(IV,Filas*Columnas);
    IdaVuelta    = zeros(IV,Filas*Columnas);
    VueltaIda    = zeros(IV,Filas*Columnas);
    VueltaVuelta = zeros(IV,Filas*Columnas);
    display([IV,Filas*Columnas]);
    display(size(VueltaIda));

% Cargo las matrices como ristras de datos. Los �ndices van en el orden en
% que se toman los datos. As�:
%   IdaIda = [Total(1).data(:,2); Total(5).data(:,2); Total(9).data(:,2); ... ];

Voltaje(:,1)= Total(1).data; % Copia el voltaje del punto en ida de espectroscop�a (que se utilizar� luego para todas)

for j = 1:Filas
    
    for i = 1:Columnas
        
        Indice1 = 1+2*(i-1)+4*Columnas*(j-1)+1;
            IdaIda(:,i+(j-1)*Columnas)       = Total(Indice1).data;
        Indice2 = Indice1+1;
            IdaVuelta(:,i+(j-1)*Columnas)    = Total(Indice2).data;
        Indice3 = Indice1+2*Columnas;
            VueltaIda(:,i+(j-1)*Columnas)    = Total(Indice3).data;
        Indice4 = Indice2+2*Columnas;
            VueltaVuelta(:,i+(j-1)*Columnas) = Total(Indice4).data; 
     end
    
    fprintf('|'); % Control
    
end


% Reordeno las matrices de Vuelta* para que se puedan usar como las otras
% -----------------------------------------------
VueltaIdaAUX = VueltaIda;
VueltaVueltaAUX = VueltaVuelta;

for i = 1:Columnas
    VueltaIdaAUX(:,i:Columnas:end-(Columnas-i)) = VueltaIda(:,Columnas-(i-1):Columnas:end-(i-1));
    VueltaVueltaAUX(:,i:Columnas:end-(Columnas-i)) = VueltaVuelta(:,Columnas-(i-1):Columnas:end-(i-1));
end

    VueltaIda = VueltaIdaAUX;
        clear VueltaIdaAUX;
    VueltaVuelta = VueltaVueltaAUX;
        clear VueltaVueltaAUX;
% -----------------------------------------------

clear i j Indice1 Indice2 Indice3 Indice4;


% Como la vuelta en espetroscop�a est� tomada de valores de voltaje
% positivos a negativos les damos la vuelta para ponerlo igual que en las
% idas
    IdaVuelta = flipud(IdaVuelta);
    VueltaVuelta = flipud(VueltaVuelta);
% ------------------------------------------

fprintf('\n'); % Control
fprintf('Carga completa\n'); % Control
fprintf('-------------------------\n')
fprintf('Puntos en la topograf�a: %d x %d\n',Filas,Columnas);
fprintf('Puntos en la espectroscop�a: %d\n', IV);
fprintf('Voltaje m�ximo (sin multiplicador): %d\n', max(Voltaje));
fprintf('-------------------------\n')


clear nPuntosTotal n count
