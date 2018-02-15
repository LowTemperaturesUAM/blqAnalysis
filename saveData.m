function [ ] = saveData(~,~,~,PixelXinicioFinal, PixelYinicioFinal,  voltajeCurvaUnica, conductanciaCurvaUnica)

savedData = [PixelXinicioFinal.*PixelYinicioFinal.*2, PixelXinicioFinal, PixelYinicioFinal ];

Struct = evalin('base','Struct');
FileName   = Struct.FileName;  
SaveFolder = Struct.SaveFolder;
SavedCurve = [voltajeCurvaUnica, conductanciaCurvaUnica];

%Con la expresion de abajo deberia funcionar, pero creo que a mi no me va
%por los espacios
%[saveFolder,FileName(1:length(FileName)-4),'.txt']

%El formato de guardar las IV es: NombreImagen'CurvaUnica'nº entonces con
%la funcion ls compruebo cuantos files que empiezen por el
%nombreImagen'CurvaUnica' hay si no hay ninguno le pongo nº = 1 si hay mas
%de 1 poues voy añadiendo

files = ls([SaveFolder,'\',FileName(1:length(FileName)-4), 'CurvaUnica', '*']);
if isempty(files)
    dlmwrite([[SaveFolder,'\'], FileName(1:length(FileName)-4), 'CurvaUnica',num2str(1),'.txt'], SavedCurve,'delimiter','\t');
else
    nOfFiles = length(files(:,1));
    dlmwrite([[SaveFolder,'\'], FileName(1:length(FileName)-4), 'CurvaUnica',num2str(nOfFiles +1),'.txt'], SavedCurve,'delimiter','\t');
end


         


