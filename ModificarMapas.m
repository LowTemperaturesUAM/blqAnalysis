%% PONEMOS EL CONTRASTE A MANO EN LOS MAPAS DE CONDUCTANCIA Y EN LAS 2D-FFT

% ------------------------------
%   MODIFICAR SI ES NECESARIO
% ------------------------------
%     MinConductancia = CorteInferiorInicialConductancia;
%     MaxConductancia = CorteSuperiorInicialConductancia;
    
    MinConductancia = 0;
    MaxConductancia = 0.1;
    
    MinConductanciaFFT = 0;
    MaxConductanciaFFT = 100;
    
    
%   Defino una Gaussiana con ancho menor que el de las cosas que nos
%   interesa ver. Sigma son los píxeles que podemos filtrar sin matar las
%   cosas que nos interesan.
    
%     Sigma = 3;
%     x0 = floor(Columnas/2)+1;
%     	y0 = floor(Filas/2)+1;
%     x = (1:1:Columnas)';
%         y = (1:1:Filas)';
%     GaussianFilter = ones(Filas,Columnas);
% 
%     for i = 1:length(x)
%         GaussianFilter(:,i) = exp(-((x(i)-x0)/(sqrt(2)*Sigma)).^2)*exp(-((y-x0)/(sqrt(2)*Sigma)).^2); 
%     end
%     MatrizFiltroFFT1 = 1-GaussianFilter;
%     MatrizFiltroFFT1 = ones(Filas,Columnas);
    
% ------------------------------

MapasConductanciaEqualizados    = MapasConductancia;
TransformadasEqualizados        = Transformadas;
% TransformadasEqualizados = simetrizarFFT(Transformadas,25,512,512);

for k=1:length(Energia)
    
    MapasConductanciaEqualizados{k}(MapasConductanciaEqualizados{k} > MaxConductancia) = MaxConductancia;
    MapasConductanciaEqualizados{k}(MapasConductanciaEqualizados{k} < MinConductancia) = MinConductancia;
    
    % Quitar línea rara vertical en el centro
    for i=1:Filas
        TransformadasEqualizados{k}(i,(Filas/2)+1) = mean([TransformadasEqualizados{k}(i,Filas/2),TransformadasEqualizados{k}(i,(Filas/2)+2)]);
%         TransformadasEqualizados{k}(i,211) = mean([TransformadasEqualizados{k}(i,210),TransformadasEqualizados{k}(i,212)]);
%         TransformadasEqualizados{k}(i,164) = mean([TransformadasEqualizados{k}(i,163),TransformadasEqualizados{k}(i,165)]);
%         TransformadasEqualizados{k}(i,303) = mean([TransformadasEqualizados{k}(i,302),TransformadasEqualizados{k}(i,304)]);
%         TransformadasEqualizados{k}(i,350) = mean([TransformadasEqualizados{k}(i,349),TransformadasEqualizados{k}(i,351)]);
    end
    
%     TransformadasEqualizados{k} = TransformadasEqualizados{k}.*MatrizFiltroFFT1;
%     TransformadasEqualizados{k} = medfilt2(TransformadasEqualizados{k},[3,3]);
    TransformadasEqualizados{k} = imgaussfilt(TransformadasEqualizados{k},0.8);
    
    TransformadasRotadaAUX = imrotate(TransformadasEqualizados{k},17.48); 
        [FilasMatrizRotada, ColumnasMatrizRotada] = size(TransformadasRotadaAUX);
        CentroX = floor(ColumnasMatrizRotada/2);
        CentroY = floor(FilasMatrizRotada/2);
    MatrizRotadaZoom = TransformadasRotadaAUX(CentroY-Filas/2+1:CentroY+Filas/2,CentroX-Columnas/2+1:CentroX+Columnas/2);
        TransformadasEqualizados{k} = MatrizRotadaZoom;
        
        clear TransformadasRotadaAUX MatrizRotadaZoom ;
        clear CentroX CentroY FilasMatrizRotada ColumnasMatrizRotada;
    
    TransformadasEqualizados{k}(TransformadasEqualizados{k} > MaxConductanciaFFT) = MaxConductanciaFFT;
    TransformadasEqualizados{k}(TransformadasEqualizados{k} < MinConductanciaFFT) = MinConductanciaFFT;
    
end

%   Simetrizamos las transformadas con respecto a los ejes que decidimos

%         TransformadasSimetrizadas = TransformadasEqualizados;
%         TransformadasSimetrizadas = simetrizarFFT_Automatico(TransformadasSimetrizadas, 0);
%         TransformadasEqualizados  = TransformadasSimetrizadas;

%% REPRESENTATION AND CALLING GUI ANALYSIS
% ------------------------------------------------------------------------

FigPrueba = figure(179);
    set(FigPrueba,'color',[1 1 1]);

    k = ceil(length(Energia)/2);
        
    Sub1= subplot(1,2,1,'Parent',FigPrueba);
    	Sub1_h1 = imagesc(DistanciaColumnas,DistanciaFilas,MapasConductanciaEqualizados{k});
        	Sub1.YDir = 'normal';
            Sub1_h1.Parent = Sub1;
        	axis('square');
            title(Sub1,['Map at',' ',num2str(Energia(k)),' mV'],...
                'FontName',TipoFuente);
           colormap gray 
    Sub2 = subplot(1,2,2,'Parent',FigPrueba);
        Sub2_h1 = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasEqualizados{k});
            Sub2.YDir = 'normal';
            Sub2_h1.Parent = Sub2;
            axis('square');
            title(Sub2,['2D-FFT a',' ',num2str(Energia(k)),' meV'],...
                'FontName',TipoFuente);
            
     Sub1_h1.ButtonDownFcn =  ['Struct.k=',num2str(k),'; GuiAnalysisv2'];
     Sub2_h1.ButtonDownFcn =  ['Struct.k=',num2str(k),'; GuiAnalysisv2'];
      colormap gray      
   
% Creating structures to pass to GUI analysis
% ------------------------------------------------------------------------
    Struct.Energia                      = Energia;
    Struct.DistanciaColumnas            = DistanciaColumnas;
    Struct.DistanciaFilas               = DistanciaFilas;
    Struct.MatrizNormalizada            = MatrizNormalizadaCortada;
    Struct.Voltaje                      = Voltaje;
    Struct.TamanhoRealFilas             = TamanhoRealFilas;
    Struct.TamanhoRealColumnas          = TamanhoRealColumnas;
    Struct.ParametroRedFilas            = ParametroRedFilas;
    Struct.ParametroRedColumnas         = ParametroRedColumnas;
    Struct.MapasConductanciaEqualizados = MapasConductanciaEqualizados;
    Struct.DistanciaFourierColumnas     = DistanciaFourierColumnas;
    Struct.DistanciaFourierFilas        = DistanciaFourierFilas;
    Struct.TransformadasEqualizados     = TransformadasEqualizados;
    Struct.Filas                        = Filas;
    Struct.Columnas                     = Columnas;
    Struct.MaxCorteConductancia         = CorteSuperiorInicialConductancia;
    Struct.MinCorteConductancia         = CorteInferiorInicialConductancia;
% ------------------------------------------------------------------------