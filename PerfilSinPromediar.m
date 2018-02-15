%LineasPromedio = 3;
LongitudPerfil = Filas;


Perfiles = zeros(length(Energia),LongitudPerfil);

for k=1:length(Energia)
    Perfiles(k,:) = TransformadasEqualizados{k}(:,Filas/2);
    %Perfiles(k,1:LongitudPerfil-1)= diff(Perfiles(k,:));
end

% mediaTotal = mean(mean(Perfiles));
% FlattenMatrix=Perfiles;
% for i = 1:length(Perfiles(:,1))
%                FlattenMatrix(:,i) = FlattenMatrix(:,i) - (mean(FlattenMatrix(:,i)) - mediaTotal);
% end

PerfilesFlatten=Flatten(Perfiles,[1,1]);

a=figure
%surf((ParametroRed/TamanhoReal)*(1:LongitudPerfil-1),Energia,Perfiles(:,1:LongitudPerfil-1))
imagesc(DistanciaFourierFilas,Energia,Perfiles);
axis([0 1/(2*ParametroRedFilas) min(Energia) max(Energia)]);
b=gca;
b.YDir='normal';
%b.CLim=[.8e-5 2e-5];
%b.CLim=[min(min(Perfiles)) max(max(Perfiles))];
colormap jet