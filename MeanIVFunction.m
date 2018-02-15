function MeanIVFunction(Rectangulo, MatrizNormalizada, Voltaje, Columnas, Filas, DistanciaColumnas)
Rectangulo = [Rectangulo(1)-0.5 Rectangulo(2)-0.5 (Rectangulo(3)) (Rectangulo(4))];
Rectangulo = Columnas.*Rectangulo./DistanciaColumnas(end) ;
Inicio = [round(Rectangulo(1)), round(Rectangulo(2))];
Final = [Inicio(1) + round(Rectangulo(3)), Inicio(2) + round(Rectangulo(4))];

m = 0;
Coordenadas = 0;
for i = 1:Columnas
    for j = 1:Filas
        if i>=Inicio(1) && j>=Inicio(2) && i<=Final(1) && j<=Final(2)
            m = m+1;

            Coordenadas(m) = sub2ind([Columnas, Filas], i, j);
        end
    end
end
mean = 0;

if length(Coordenadas)>1
length(Coordenadas)

for i = 1:length(Coordenadas)
    mean = mean + MatrizNormalizada(:,Coordenadas(i))/length(Coordenadas);
end
assignin('base','mean',[Voltaje, mean])
figure(23321)
hold on
Voltaje
plot(Voltaje, mean,'ro-')
%ylim([0 , 2])
end