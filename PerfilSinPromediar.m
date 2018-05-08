%LineasPromedio = 3;
LongitudPerfil = Filas;


Perfiles = zeros(length(Energia),LongitudPerfil);
Perfiles2 = zeros(length(Energia),LongitudPerfil);

for k=1:length(Energia)
    Perfiles(k,:) = TransformadasSimetrizadas{k}(:,Filas/2);
    Perfiles2(k,:) = TransformadasSimetrizadas{k}(:,1+Filas/2);
    %Perfiles(k,1:LongitudPerfil-1)= diff(Perfiles(k,:));
end

% mediaTotal = mean(mean(Perfiles));
% FlattenMatrix=Perfiles;
% for i = 1:length(Perfiles(:,1))
%                FlattenMatrix(:,i) = FlattenMatrix(:,i) - (mean(FlattenMatrix(:,i)) - mediaTotal);
% end
PerfilesPromedio = (Perfiles + Perfiles2)/2;
PerfilesFlatten=Flatten(Perfiles,[1,1]);

a=figure;
%surf((ParametroRed/TamanhoReal)*(1:LongitudPerfil-1),Energia,Perfiles(:,1:LongitudPerfil-1))
imagesc(DistanciaFourierFilas*2*ParametroRedFilas,Energia,PerfilesPromedio);
axis([0 1 min(Energia) max(Energia)]);
b=gca;
b.YDir='normal';
b.LineWidth = 2;
b.Position = b.OuterPosition;
b.CLim=[0e-5 100e-5];
%b.CLim=[min(min(Perfiles)) max(max(Perfiles))];
colormap gray