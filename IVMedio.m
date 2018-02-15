MeanConductance = mean(MatrizConductancia,2);
MeanConductanceNorm = mean(MatrizNormalizada,2);
MeanConductanceNormCor = mean(MatrizNormalizadaCortada,2);
figure
MatrizNormalizadaCortadaMe = MeanConductanceNorm;
MatrizNormalizadaCortadaMe(MatrizNormalizadaCortadaMe < CorteInferiorInicialConductancia) = CorteInferiorInicialConductancia;
    MatrizNormalizadaCortadaMe(MatrizNormalizadaCortadaMe > CorteSuperiorInicialConductancia) = CorteSuperiorInicialConductancia;
%plot(Voltaje, MeanConductance,'k')
hold on
RangoVoltaje = [-10 10];
Rango = (Voltaje > RangoVoltaje(1) & Voltaje < RangoVoltaje(2));
VoltajePlo = nonzeros(Voltaje.*(Rango));

MeanConductance = nonzeros(Rango.*MeanConductance);
MeanConductanceNorm = nonzeros(Rango.*MeanConductanceNorm);
MeanConductanceNormCor = nonzeros(Rango.*MeanConductanceNormCor);
MatrizNormalizadaCortadaMe = nonzeros(Rango.*MatrizNormalizadaCortadaMe);
subplot(2,2,1)
plot(VoltajePlo, MeanConductance, 'ko-')
subplot(2,2,2)
plot(VoltajePlo, MeanConductanceNorm, 'bo-')
subplot(2,2,3)
plot(VoltajePlo, MeanConductanceNormCor,'ro-')
subplot(2,2,4)
plot(VoltajePlo,  MatrizNormalizadaCortadaMe,'go-')

