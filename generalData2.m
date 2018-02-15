%Objetivo: Poder escribir de forma itneractiva valores generales del
%experimento: Campo, Temperatura y Corriente Tunel


function [Campo, Temperatura, TamanhoRealFilas,TamanhoRealColumnas, ParametroRedFilas,ParametroRedColumnas, Filas, Columnas] = generalData2(TopoLineas,Struct)
f = figure;
%Botones para elegir Datos generales de las medidas:
FileName = Struct.FileName;
SaveFolder = Struct.SaveFolder;
remember = exist([[SaveFolder,'\'],FileName(1:length(FileName)-4),'sample.ini'],'file');
remember
if remember; data1 = dlmread([[SaveFolder,'\'],FileName(1:length(FileName)-4),'sample.ini']);end
% Filas: Por defecto escribe el valor que obtiene del tamaño de la topo.
% Solo si es número redondo
txtFilas= uicontrol('Style','text',...
        'Position',[40 300 100 20],...
        'String', 'Filas:','HorizontalAlignment','left');
      
editFilas = uicontrol('Style','edit',...
        'Position',[100 300 100 20]);
    if round(TopoLineas) == TopoLineas
        editFilas.String = num2str(TopoLineas);
    end
% Columnas:Por defecto escribe el valor que obtiene del tamaño de la topo.
% Solo si es número redondo
txtColumnas= uicontrol('Style','text',...
        'Position',[230 300 100 20],...
        'String', 'Columnas:','HorizontalAlignment','left');
    
editColumnas = uicontrol('Style','edit',...
        'Position',[322 300 100 20]);
    
    if round(TopoLineas) == TopoLineas
        editColumnas.String = num2str(TopoLineas);
    end
%Campo:
txtCampo= uicontrol('Style','text',...
        'Position',[40 250 150 20],...
        'String', 'Campo (T):','HorizontalAlignment','left');

editCampo = uicontrol('Style','edit',...
        'Position',[140 250 100 20]); 
    if remember;11; editCampo.String = data1(3) ;end  
%temperatura:
txtTemperatura = uicontrol('Style','text',...
        'Position',[40 200 220 20],...
        'String', 'Temperatura (K):','HorizontalAlignment','left');

editTemperatura = uicontrol('Style','edit',...
        'Position',[180 200 100 20]);
     if remember;11; editTemperatura.String = data1(4) ;end  
% Tamaño Filas:
txtTamanhoRealFilas = uicontrol('Style','text',...
        'Position',[40 150 220 20],...
        'String', 'Tamaño real Filas (nm):','HorizontalAlignment','left');

editTamanhoRealFilas = uicontrol('Style','edit',...
        'Position',[230 150 100 20]);
    if remember;11; editTamanhoRealFilas.String = data1(5) ;end  
% Tamaño Columnas
txtTamanhoRealColumnas = uicontrol('Style','text',...
        'Position',[370 150 260 20],...
        'String', 'Tamaño real Columnas (nm):','HorizontalAlignment','left');
    
editTamanhoRealColumnas = uicontrol('Style','edit',...
        'Position',[592 150 100 20]);
        if remember;11; editTamanhoRealColumnas.String = data1(6) ;end  

% Parámetro de red Filas:
txtParametroRedFilas = uicontrol('Style','text',...
        'Position',[40 100 220 20],...
        'String', 'Parámetro de red Filas (nm):','HorizontalAlignment','left');
    

editParametroRedFilas = uicontrol('Style','edit',...
        'Position',[264 100 100 20]);
    if remember;11; editParametroRedFilas.String = data1(7) ;end  
% Parámetro de red Columnas:
txtParametroRedColumnas = uicontrol('Style','text',...
        'Position',[400 100 260 20],...
        'String', 'Parámetro de red Columnas (nm):','HorizontalAlignment','left');
    
editParametroRedColumnas = uicontrol('Style','edit',...
        'Position',[660 100 100 20]);
    if remember;11; editParametroRedColumnas.String = data1(8) ;end 
%Boton para continuar
 uicontrol('Position',[20 20 200 40],'String','Continue',...
              'Callback','uiresume(gcbf)');    
uiwait(gcf); 

Filas                   = str2double(editFilas.String);
Columnas                = str2double(editColumnas.String);
Temperatura             = str2double(editTemperatura.String);
Campo                   = str2double(editCampo.String);
TamanhoRealFilas        = str2double(editTamanhoRealFilas.String);
TamanhoRealColumnas     = str2double(editTamanhoRealColumnas.String);
ParametroRedFilas       = str2double(editParametroRedFilas.String);
ParametroRedColumnas    = str2double(editParametroRedColumnas.String);

data = [Filas Columnas Temperatura Campo TamanhoRealFilas TamanhoRealColumnas ...
    ParametroRedFilas ParametroRedColumnas];

fileID = fopen([[SaveFolder,'\'],FileName(1:length(FileName)-4),'sample.ini'],'w');
dlmwrite([[SaveFolder,'\'],FileName(1:length(FileName)-4),'sample.ini'],data)




close(f);
end