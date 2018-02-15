% DESCRIPTION:
% -----------------------------------------------------------------------
% Loads the data from a blq file into different matrices in Matlab that
% contain the conductance curves for each point. From these curves it
% assembles conductance maps at different voltages and calculates the
% corresponding 2D-FFT.
% Data is then saved as a structure to be used by GuiAnalysis2 in a
% dynamical interface.
%
% -----------------------------------------------------------------------
% Miscelaneous
% ------------------------------------------------------------------------
    VersionScript = 'Pepe y Antón 08/05/2017';
% -----------------------------------------------------------------------  
%
% CONSTANTS:
% -----------------------------------------------------------------------
    Pi = 3.141592653589793;
% -----------------------------------------------------------------------
%
% CUSTOM OPTIONS:
% -----------------------------------------------------------------------
    TipoFuente          = 'Arial';
    TamahoFuenteEjes    = 14;
    TamahoFuenteTitulos = 16;
    TamanhoLinea        = 2;
    TamanhoPuntos       = 10;
% -----------------------------------------------------------------------

% Loading data from IVAnalysis_Imagenes:
% -----------------------------------------------------------------------
	FileName                            = Struct.FileName;
	FilePath                            = Struct.FilePath;
    
	IV                                  = Struct.IV;
	MatrizCorriente                     = Struct.MatrizCorriente;
        
	PuntosDerivada                      = Struct.NPuntosDerivada;
	Voltaje                             = Struct.Voltaje;
	VoltajeNormalizacionInferior        = Struct.VoltajeNormalizacionInferior;
	VoltajeNormalizacionSuperior        = Struct.VoltajeNormalizacionSuperior;

	CorteInferiorInicialConductancia    = Struct.datosIniciales.corteInferior;
	CorteSuperiorInicialConductancia    = Struct.datosIniciales.corteSuperior;
        
    DeltaEnergia                        = Struct.datosIniciales.DeltaEnergia;
    PasoMapas                           = Struct.datosIniciales.PasoMapas;
    Energia                             = (Struct.datosIniciales.EnergiaMin:PasoMapas:Struct.datosIniciales.EnergiaMax);
 
    Filas                               = Struct.Filas;
    Columnas                            = Struct.Columnas;
    TamanhoRealFilas                    = Struct.TamanhoRealFilas;
    TamanhoRealColumnas                 = Struct.TamanhoRealColumnas;
    ParametroRedFilas                   = Struct.ParametroRedFilas;
    ParametroRedColumnas                = Struct.ParametroRedColumnas;
    TamanhoPixelFilas                   = TamanhoRealFilas/Filas;
    TamanhoPixelColumnas                = TamanhoRealColumnas/Columnas;
% ------------------------------------------------------------------------

% Defining units in direct and reciprocal space
% ------------------------------------------------------------------------
	DistanciaColumnas = TamanhoPixelColumnas*(1:1:Columnas);
    DistanciaFilas = TamanhoPixelFilas*(1:1:Filas);
    
    DistanciaFourierColumnas = (1/TamanhoRealColumnas)*(1:1:Columnas);
    DistanciaFourierFilas = (1/TamanhoRealFilas)*(1:1:Filas);

% Centering reciprocal space units
% ------------------------------------------------------------------------
	DistanciaFourierColumnas = DistanciaFourierColumnas - DistanciaFourierColumnas(floor(Columnas/2)+1); 
        DistanciaFourierFilas = DistanciaFourierFilas - DistanciaFourierFilas(floor(Filas/2)+1);
        
% Changing reciprocal space units to 2\pi/a  
% ------------------------------------------------------------------------
%Struct.ParametroRed
	DistanciaFourierColumnas = DistanciaFourierColumnas*(Struct.ParametroRedColumnas);
    DistanciaFourierFilas = DistanciaFourierFilas*(Struct.ParametroRedFilas);

% Absolute units    
% ------------------------------------------------------------------------
    DistanciaFourierColumnas = DistanciaFourierColumnas/(Struct.ParametroRedColumnas);
    DistanciaFourierFilas = DistanciaFourierFilas/(Struct.ParametroRedFilas);
    
% Derivating the tunneling matrix
% ------------------------------------------------------------------------
    [MatrizConductancia] = derivadorLeastSquaresPA(PuntosDerivada,...
                                                   MatrizCorriente,...
                                                   Voltaje,...
                                                   Filas,Columnas);
% ------------------------------------------------------------------------

% Normalizing (or not) the data
% ------------------------------------------------------------------------
	if Struct.NormalizationFlag                           
        [MatrizNormalizada] = normalizacionPA(VoltajeNormalizacionSuperior,...
                                              VoltajeNormalizacionInferior,...
                                              Voltaje,...
                                              MatrizConductancia,...
                                              Filas,Columnas);
        ConductanciaTunel = 1;
    else
        MatrizNormalizada = MatrizConductancia; % units: uS
        ConductanciaTunel = mean(max(MatrizCorriente))/max(Voltaje);
	end
% ------------------------------------------------------------------------   

% Removing bad data points with the first cut
% ------------------------------------------------------------------------
    MatrizNormalizadaCortada = MatrizNormalizada;
    MatrizNormalizadaCortada(MatrizNormalizadaCortada < CorteInferiorInicialConductancia) = CorteInferiorInicialConductancia;
    MatrizNormalizadaCortada(MatrizNormalizadaCortada > CorteSuperiorInicialConductancia) = CorteSuperiorInicialConductancia;
% ------------------------------------------------------------------------   

%% DELETING DATA THAT IS NOT GOING TO BE USED
% ------------------------------------------------------------------------
% In large files (512x512x128x7x8) can save up to 1.83 GB of memory. Higly
% recommended for increase speed.

%     clear MatrizCorriente MatrizConductancia MatrizNormalizada;
           
%% CALCULATING CONDUCTANCE MAPS AND 2D-FFT
% ------------------------------------------------------------------------
% Considering conductance curves at each point creates conductance maps
% averaging points around a certain DeltaEnergia and its 2D-FFT map
fileID = Struct.fileID;

fprintf(fileID, 'Valores de Energia: de %g mV a %g mV en pasos de %g mV\r\n',...
                Energia(1), Energia(length(Energia)),PasoMapas);
fprintf(fileID, 'Delta de Energia  : %g mv\r\n', DeltaEnergia);
fprintf(fileID, '-------------------------------\r\n');
fprintf(fileID, '\r\n\r\n');

% Warning for empty matrices
% ------------------------------------------------------------------------
if abs(Voltaje(2) - Voltaje(1)) > 2*DeltaEnergia
    fprintf('AVISO: El paso de voltaje es MAYOR que el intervalo seleccionado. Es posible que aparezcan MATRICES en BLANCO.\n');
elseif abs(Voltaje(2) - Voltaje(1)) < 2*DeltaEnergia
    fprintf('El paso de voltaje es menor que el intervalo seleccionado.\n');
else
    fprintf('El paso de voltaje es justamente el intervalo seleccionado.\n');
end
% ------------------------------------------------------------------------

% Arrays to use in this part
% ------------------------------------------------------------------------
%   Indices:            IV index to average in each map.
%
%   MapasConductancia:  conductance map for each energy value in the
%                       corresponding conductance units.
%
%   Transformadas:      2D-FFT of the corresponding conductance map in the
%                       corresponding conductance units.
% ------------------------------------------------------------------------

    Indices = cell(length(Energia),1);
    MapasConductancia = cell(length(Energia),Filas,Columnas);
        MapasConductanciaAUX = cell(length(Energia),Filas,Columnas);
    Transformadas = cell(length(Energia),Filas,Columnas);
     choice = questdlg('Sweep direction?','Confirmation','X','Y','X');   
for k = 1:length(Energia)
    
    Indices{k} = find(Energia(k)- DeltaEnergia < Voltaje & Energia(k)+ DeltaEnergia > Voltaje);
    MapasConductanciaAUX{k} = mean(MatrizNormalizadaCortada(Indices{k},:),1);
        MapasConductancia{k} = reshape(MapasConductanciaAUX{k},[Columnas,Filas]);
        MapasConductancia{k} = MapasConductancia{k}';
    if strcmp(choice,'Y')
        MapasConductancia{k} = imrotate(MapasConductancia{k},-90);
        MapasConductancia{k} = fliplr(MapasConductancia{k} );
    end
    Transformadas{k} = fft2d(MapasConductancia{k});
        Transformadas{k} = Transformadas{k}/(TamanhoRealFilas*TamanhoRealColumnas);

end

clear k Indices DeltaEnergia MapasConductanciaAUX;


%% PROCESSING CONDUCTANCE MAPS AND 2D-FFT (Not mandaroty)
%
% Defining filter for the 2D-FFT (removing central point)
% ------------------------------------------------------------------------
    Sigma = 3;
    x0 = floor(Columnas/2)+1;
    	y0 = floor(Filas/2)+1;
    x = (1:1:Columnas)';
        y = (1:1:Filas)';
    GaussianFilter = ones(Filas,Columnas);

    for i = 1:length(x)
        GaussianFilter(:,i) = exp(-((x(i)-x0)/(sqrt(2)*Sigma)).^2)*exp(-((y-x0)/(sqrt(2)*Sigma)).^2); 
    end
    MatrizFiltroFFT1 = 1-GaussianFilter;
% ------------------------------------------------------------------------
    
% Limits for points in the 2D-FFT
% ------------------------------------------------------------------------
        MaxConductanciaFFT = 10;
        MinConductanciaFFT = 0;
% ------------------------------------------------------------------------

% Filtering conductance maps and 2D-FFT
% ------------------------------------------------------------------------
    MapasConductanciaEqualizados    = MapasConductancia;
    TransformadasEqualizados        = Transformadas;

for k=1:length(Energia)
    
    MapasConductancia{k} = medfilt2(MapasConductancia{k},[4,4]);
    
    TransformadasEqualizados{k} = TransformadasEqualizados{k}.*MatrizFiltroFFT1;
        TransformadasEqualizados{k}(TransformadasEqualizados{k} > MaxConductanciaFFT) = MaxConductanciaFFT;
        TransformadasEqualizados{k}(TransformadasEqualizados{k} < MinConductanciaFFT) = MinConductanciaFFT;
        TransformadasEqualizados{k} = medfilt2(TransformadasEqualizados{k},[4,4]);
end
% ------------------------------------------------------------------------
        
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
    Struct.MapasConductanciaEqualizados = MapasConductanciaEqualizados;
    Struct.DistanciaFourierColumnas     = DistanciaFourierColumnas;
    Struct.DistanciaFourierFilas        = DistanciaFourierFilas;
    Struct.TransformadasEqualizados     = TransformadasEqualizados;
    Struct.Filas                        = Filas;
    Struct.Columnas                     = Columnas;
    Struct.MaxCorteConductancia         = CorteSuperiorInicialConductancia;
    Struct.MinCorteConductancia         = CorteInferiorInicialConductancia;
% ------------------------------------------------------------------------
