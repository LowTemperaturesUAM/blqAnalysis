LineasPromedio = 3;
LongitudPerfil = 100;

Perfiles = zeros(LongitudPerfil,LineasPromedio);
PerfilesPromediados = zeros(length(Energia),LongitudPerfil);

for k=1:length(Energia)
    for i=1:LineasPromedio
    Perfiles(:,i) = TransformadasEqualizados{k}(1+Columnas/2:LongitudPerfil+Columnas/2,i+Filas/2);
    end
    PerfilesPromediados(k,:) = mean(Perfiles');
end

figure
imagesc(1:LongitudPerfil,Energia,PerfilesPromediados)
colormap jet