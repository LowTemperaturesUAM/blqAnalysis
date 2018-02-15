function varargout = ImageAnalysisIV(varargin)
% IMAGEANALYSISIV MATLAB code for ImageAnalysisIV.fig
%      IMAGEANALYSISIV, by itself, creates a new IMAGEANALYSISIV or raises the existing
%      singleton*.
%
%      H = IMAGEANALYSISIV returns the handle to a new IMAGEANALYSISIV or the handle to
%      the existing singleton*.
%
%      IMAGEANALYSISIV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEANALYSISIV.M with the given input arguments.
%
%      IMAGEANALYSISIV('Property','Value',...) creates a new IMAGEANALYSISIV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageAnalysisIV_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageAnalysisIV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageAnalysisIV

% Last Modified by GUIDE v2.5 03-Jul-2017 17:53:25



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageAnalysisIV_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageAnalysisIV_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ImageAnalysisIV is made visible.
function ImageAnalysisIV_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageAnalysisIV (see VARARGIN)

% Choose default command line output for ImageAnalysisIV
handles.output = hObject;
%handles.OffsetVoltaje.String
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageAnalysisIV wait for user response (see UIRESUME)
% uiwait(handles.PanelAnalisis);


% --- Outputs from this function are returned to the command line.
function varargout = ImageAnalysisIV_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);

% --- Executes on button press in LoadBlq.
function LoadBlq_Callback(hObject, eventdata, handles)
% hObject    handle to LoadBlq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TamanhoFuenteTitulos = 12;
handles.TamanhoFuenteTitulos = TamanhoFuenteTitulos;

TipoFuente = 'Arial';
handles.TipoFuente = TipoFuente;

  % Carga el blq
    
	[FileName, FilePath] = uigetfile('*.blq','Load blq');
        Struct.FileName = FileName;
        Struct.FilePath = FilePath;
        
        display('Pepe rulzzz');

        uiwait(ChooseMatrix) %Para poner en pausa el programa
        
        display('of course');
        
	[FileNameTopo, FilePathTopo] = uigetfile('*.img','Load topography');
        Struct.FileNameTopo = FileNameTopo;
        Struct.FilePathTopo = FilePathTopo;
        TopoProperties      = dir([FilePathTopo FileNameTopo]);
        TopoLineas          = sqrt((TopoProperties.bytes - 1032)/4);
            
	[SaveFolder] = uigetdir(FilePath,'Save Files of Analysis');
        Struct.SaveFolder = SaveFolder;
        
	[Campo, Temperatura, TamanhoRealFilas,TamanhoRealColumnas, ParametroRedFilas,ParametroRedColumnas, Filas, Columnas] = ...
        generalData2(TopoLineas, Struct);

        Struct.Campo                = Campo;
        Struct.Temperatura          = Temperatura;
        Struct.TamanhoRealFilas     = TamanhoRealFilas;
        Struct.TamanhoRealColumnas  = TamanhoRealColumnas;
        Struct.ParametroRedFilas    = ParametroRedFilas;
        Struct.ParametroRedColumnas = ParametroRedColumnas;
        
	if Filas ~= Columnas
        fprintf('¡ATENCIÓN! El número de filas y el de columnas no es igual. %s\n',FileName);
	end
        
	Date = datetime;
% 	[eleccionMatrices, ~] = customCurvesv2(SaveFolder, FileName);
    eleccionMatrices = hObject.UserData;
% ------------------------------------------------------------------------


% Loading data from BLQ file into matlab matrices
% ------------------------------------------------------------------------ 
    tic
	[Voltaje,...
        IdaIda,...
        IdaVuelta,...
        VueltaIda,...
        VueltaVuelta] = ReducedblqreaderV10([FilePath,FileName],Filas,Columnas, eleccionMatrices);
	toc
    Voltaje = Voltaje*1000; % Para ponerlo en mV
     
% Checking which current matricex exists and putting them in nA for simplcity
% ------------------------------------------------------------------------
        if exist('IdaIda',  'var')
            IdaIda       = IdaIda*1e9;
            display('Exists IdaIda');
        elseif exist('IdaVuelta',  'var')
            IdaVuelta    = IdaVuelta*1e9;
        elseif exist('VueltaIda',  'var')
            VueltaIda    = VueltaIda*1e9;
        elseif exist('VueltaVuelta',  'var')
            VueltaVuelta = VueltaVuelta*1e9;
        end

        display('Matrices: IdaIda IdaVuelta VueltaIda VueltaVuelta');
        display(['Cargadas:      ', num2str(eleccionMatrices(1)),...
                         '       ', num2str(eleccionMatrices(2)),...
                        '        ', num2str(eleccionMatrices(3)),...
                       '         ', num2str(eleccionMatrices(4))]);
    % ------------------------------------------------------------------------
    %
    % Checking if data matricex exist and initializing them otherwise for
    % program purposes
    % ------------------------------------------------------------------------
        if ~exist('IdaIda',  'var') 
            eleccionMatrices(1) = 0;
            IdaIda = 0;
        end
        if ~exist('IdaVuelta',  'var')
            eleccionMatrices(2) = 0;
            IdaVuelta = 0;
        end
        if ~exist('VueltaIda',  'var')
             eleccionMatrices(3) = 0;
             VueltaIda = 0;
        end
        if  ~exist('VueltaVuelta',  'var')
             eleccionMatrices(4) = 0;
             VueltaVuelta = 0;
        end
    % ------------------------------------------------------------------------
    %
    % Creating the tunneling current matrix (MatrizCorriente) adding the
    % different selected matrices and the Voltage array adding the offset
    % (VoltajeOffset)
    % ------------------------------------------------------------------------
        MatrizCorriente = ( eleccionMatrices(1)*IdaIda +...
                            eleccionMatrices(2)*IdaVuelta +...
                            eleccionMatrices(3)*VueltaIda +... 
                            eleccionMatrices(4)*VueltaVuelta)...
                            /length(find (eleccionMatrices ~=0)); 
     
        OffsetVoltajeValue = str2double(handles.OffsetVoltaje.String);
            VoltajeOffset = Voltaje + OffsetVoltajeValue;
        
        NumeroCurvasValue = str2double(handles.NumeroCurvas.String);
        
        i = 1+round(rand(NumeroCurvasValue,1)*(Columnas-1)); % Random index for curve selection
        j = 1+round(rand(NumeroCurvasValue,1)*(Filas-1));    % Random index for curve selection
        handles.IndiceCurvas_i = i;
        handles.IndiceCurvas_j = j;
        
        MatrizCorrienteTest = zeros(length(Voltaje),NumeroCurvasValue);
        
        for count = 1:NumeroCurvasValue
            MatrizCorrienteTest(:,count) = MatrizCorriente(:,(Filas*(j(count)-1)+ i(count)));
        end
        clear i j;
    % ------------------------------------------------------------------------
    
    NPuntosDerivadaValue = str2double(handles.NPuntosDerivada.String);
    
    IV = length(Voltaje);

    [MatrizConductanciaTest] = derivadorLeastSquaresPA(NPuntosDerivadaValue,MatrizCorrienteTest,Voltaje,1,NumeroCurvasValue);
    
    % Normalizing (or not) the data
% ------------------------------------------------------------------------
	remember = 0;
    if exist([[SaveFolder,'\'],FileName(1:length(FileName)-4),'.in'],'file')
        remember = dlmread( [[SaveFolder,'\'],FileName(1:length(FileName)-4),'.in']);
        remember
    end  
        
    if length(remember) ==11
        handles.NumeroCurvas.String = remember(7);
        handles.NPuntosDerivada.String = remember(8);
        handles.OffsetVoltaje.String = remember(9);
        handles.VoltajeNormalizacionInferiorText.String = remember(10);
        handles.VoltajeNormalizacionSuperiorText.String = remember(11);
        
    else
        
        if str2double(handles.VoltajeNormalizacionSuperiorText.String) == 0
            handles.VoltajeNormalizacionSuperiorText.String = num2str(0.9*max(Voltaje));
        end

        if str2double(handles.VoltajeNormalizacionInferiorText.String) == 0
            handles.VoltajeNormalizacionInferiorText.String = num2str(0.7*max(Voltaje));
        end
    end
    
    VoltajeNormalizacionSuperior = str2double(handles.VoltajeNormalizacionSuperiorText.String);
    VoltajeNormalizacionInferior = str2double(handles.VoltajeNormalizacionInferiorText.String);
        
	if handles.NormalizationFlag.Value
        
        [MatrizNormalizadaTest] = normalizacionPA(VoltajeNormalizacionSuperior,...
                                              VoltajeNormalizacionInferior,...
                                              VoltajeOffset,...
                                              MatrizConductanciaTest,...
                                              1,NumeroCurvasValue);
        ConductanciaTunel = 1;
	else
        MatrizNormalizadaTest = MatrizConductanciaTest; % units: uS
            ConductanciaTunel = mean(max(MatrizCorrienteTest))/max(Voltaje);
	end
% ------------------------------------------------------------------------  

    cla(handles.EjesCorriente);
    axes(handles.EjesCorriente);
    
% Diferencia con Imagenes
    
    hold(handles.EjesCorriente,'on');
    for ContadorCurvas = 1:NumeroCurvasValue
        plot(Voltaje,MatrizCorrienteTest(:,ContadorCurvas),'-','Parent',handles.EjesCorriente);
    end
    hold(handles.EjesCorriente,'off');
    handles.EjesCorriente.MinorGridLineStyle = ':';

    xlabel(handles.EjesCorriente,'Bias voltage (mV)',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    ylabel(handles.EjesCorriente,'Tunnel current (nA)',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    title(handles.EjesCorriente,'IV',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
        12        
    handles.EjesCorriente.XLim = [min(Voltaje),                  max(Voltaje)]
    handles.EjesCorriente.YLim = [mean(min(MatrizCorrienteTest)) mean(max(MatrizCorrienteTest))];
    box on; grid on;
    
    cla(handles.EjesConductancia);
    axes(handles.EjesConductancia);
    
    hold(handles.EjesConductancia,'on');
    for ContadorCurvas = 1:NumeroCurvasValue
        plot(Voltaje,MatrizNormalizadaTest(:,ContadorCurvas),'-','Parent',handles.EjesConductancia);
    end
    
    handles.EjesConductancia.MinorGridLineStyle = ':';
    handles.EjesConductancia.MinorGridColor = 'k';

    title(handles.EjesConductancia,'Conductance examples',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    xlabel(handles.EjesConductancia,'Bias voltage (mV)',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    handles.EjesConductancia.XLim = [min(Voltaje) max(Voltaje)];
    box on; grid on;
    
        if handles.NormalizationFlag.Value
            
            plot([VoltajeNormalizacionInferior,   VoltajeNormalizacionInferior], [0, 2*ConductanciaTunel],'b-',...
                'Parent',handles.EjesConductancia);
            plot([-VoltajeNormalizacionInferior, -VoltajeNormalizacionInferior], [0, 2*ConductanciaTunel],'b-',...
                'Parent',handles.EjesConductancia);
            plot([VoltajeNormalizacionSuperior,   VoltajeNormalizacionSuperior], [0, 2*ConductanciaTunel],'r-',...
                'Parent',handles.EjesConductancia);
            plot([-VoltajeNormalizacionSuperior, -VoltajeNormalizacionSuperior], [0, 2*ConductanciaTunel],'r-',...
                'Parent',handles.EjesConductancia);
            
            ylabel(handles.EjesConductancia,'Normalized conductance',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
                handles.EjesConductancia.YLim = [0, 2*ConductanciaTunel];
        else
            ylabel(handles.EjesConductancia,'Conductance \muS',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
                handles.EjesConductancia.YLim = [0, 2*ConductanciaTunel];
        end
        
    hold(handles.EjesConductancia,'off');
    fileID = fopen([[SaveFolder,'\'],FileName(1:length(FileName)-4),'.txt'],'w');
    if ~exist([[SaveFolder,'\'],FileName(1:length(FileName)-4),'.txt'],'file')
        %
    % Saving data from the experiment in a text file
    % ------------------------------------------------------------------------
        
        fprintf(fileID, 'Archivo analizado:\r\n');
        fprintf(fileID, '-------------------------------\r\n');
        fprintf(fileID, 'File Name      : %s \r\n',FileName(1:length(FileName)-4));
        fprintf(fileID, 'File Path      : %s \r\n',FilePath);
        fprintf(fileID, 'Date           : %s \r\n',char(Date));
        fprintf(fileID, '--     -----------------------------\r\n');
        fprintf(fileID, '\r\n');
        fprintf(fileID, 'Datos del Experimento\r\n');
        fprintf(fileID, '-------------------------------\r\n');
        fprintf(fileID, 'Campo          : %g T\r\n', Campo); 
        fprintf(fileID, 'Temperatura    : %g K\r\n', Temperatura) ;
        fprintf(fileID, 'Corriente Tunel: %g nA\r\n',mean(max(MatrizCorriente))); 
        fprintf(fileID, 'Tamaño Filas         : %g nA\r\n',TamanhoRealFilas);
        fprintf(fileID, 'Tamaño Columnas        : %g nA\r\n',TamanhoRealColumnas);
        fprintf(fileID, 'Parametro red Columnas : %g nA\r\n',ParametroRedColumnas);
         fprintf(fileID, 'Parametro red  Filas: %g nA\r\n',ParametroRedFilas);
        fprintf(fileID, '-------------------------------\r\n');
        fprintf(fileID, '\r\n');
        fprintf(fileID, '\r\n');
         fclose(fileID);
    end
    % Displaying info    
    % ------------------------------------------------------------------------

        fprintf('-------------------------\n');
        fprintf('Análisis de %s\n',     FileName);
        fprintf('-------------------------\n');
       

% Saving into Structure to pass to analysis
% ------------------------------------------------------------------------
   
    % Path and name
    % ---------------------------------------------
        Struct.FileName                     = FileName;
        Struct.FilePath                     = FilePath;
      
        Struct.fileID                       = fileID;
    
    % Fix data (raw data)
    % ---------------------------------------------
        Struct.Voltaje                      = Voltaje;
        Struct.IV                           = IV;
        Struct.MatrizNormalizadaTest        = MatrizNormalizadaTest;
        Struct.MatrizCorrienteTest          = MatrizCorrienteTest;
        Struct.MatrizCorriente              = MatrizCorriente;
        Struct.NPuntosImagen                = Filas*Columnas;
        Struct.Filas                        = Filas;
        Struct.Columnas                     = Columnas; 
    
    % Variable data (curve analysis)
    % ---------------------------------------------
        Struct.NumeroCurvas                 = NumeroCurvasValue;
        Struct.NPuntosDerivada              = NPuntosDerivadaValue;
        Struct.VoltajeNormalizacionInferior	= VoltajeNormalizacionInferior;
        Struct.VoltajeNormalizacionSuperior	= VoltajeNormalizacionSuperior;
        Struct.OffsetVoltaje                = OffsetVoltajeValue;
        Struct.NormalizationFlag            = handles.NormalizationFlag.Value;

    % Saving structure
    % ---------------------------------------------
        handles.Struct = Struct;

guidata(hObject, handles);



function NumeroCurvas_Callback(~, ~, ~)
% hObject    handle to NumeroCurvas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumeroCurvas as text
%        str2double(get(hObject,'String')) returns contents of NumeroCurvas as a double


% --- Executes during object creation, after setting all properties.
function NumeroCurvas_CreateFcn(hObject, ~, ~)
% hObject    handle to NumeroCurvas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NPuntosDerivada_Callback(~, ~, ~)
% hObject    handle to NPuntosDerivada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NPuntosDerivada as text
%        str2double(get(hObject,'String')) returns contents of NPuntosDerivada as a double


% --- Executes during object creation, after setting all properties.
function NPuntosDerivada_CreateFcn(hObject, ~, ~)
% hObject    handle to NPuntosDerivada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OffsetVoltaje_Callback(~, ~, ~)
% hObject    handle to OffsetVoltaje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OffsetVoltaje as text
%        str2double(get(hObject,'String')) returns contents of OffsetVoltaje as a double


% --- Executes during object creation, after setting all properties.
function OffsetVoltaje_CreateFcn(hObject, ~, ~)
% hObject    handle to OffsetVoltaje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DrawButton.
function DrawButton_Callback(hObject, ~, handles)
% hObject    handle to DrawButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TamanhoFuenteTitulos = 12;
handles.TamanhoFuenteTitulos = TamanhoFuenteTitulos;

TipoFuente = 'Arial';
handles.TipoFuente = TipoFuente;

Columnas = handles.Struct.Columnas;
Filas = handles.Struct.Filas;

% Getting new analysis parameters
% --------------------------------------
    NumeroCurvasValue = str2double(handles.NumeroCurvas.String);
        
    NPuntosDerivadaValue	= str2double(handles.NPuntosDerivada.String);
    
    VoltajeNormalizacionSuperior = str2double(handles.VoltajeNormalizacionSuperiorText.String);
    VoltajeNormalizacionInferior = str2double(handles.VoltajeNormalizacionInferiorText.String);
    
    OffsetVoltajeValue = str2double(handles.OffsetVoltaje.String);

% Loading voltage
% --------------------------------------    
    Voltaje = handles.Struct.Voltaje;
        Voltaje = Voltaje + OffsetVoltajeValue;

% Loading and redefining MatrizCorrienteTest
% --------------------------------------         
    MatrizCorriente = handles.Struct.MatrizCorriente;
    
        if handles.ChangeCurves.Value || NumeroCurvasValue ~= length(handles.IndiceCurvas_i)
            i = 1+round(rand(NumeroCurvasValue,1)*(Columnas-1)); % Random index for curve selection
            j = 1+round(rand(NumeroCurvasValue,1)*(Filas-1));    % Random index for curve selection
            handles.IndiceCurvas_i = i;
            handles.IndiceCurvas_j = j;
        else
            disp('Same curves');
        end
            
        MatrizCorrienteTest = zeros(length(Voltaje),NumeroCurvasValue);
        
        for count = 1:NumeroCurvasValue
            MatrizCorrienteTest(:,count) = MatrizCorriente(:,(Filas*(handles.IndiceCurvas_j(count)-1)+ handles.IndiceCurvas_i(count)));
        end
        clear i j;
    size( MatrizCorrienteTest)
    size(Voltaje)
    NumeroCurvasValue
    NPuntosDerivadaValue
    [MatrizConductanciaTest] = derivadorLeastSquaresPA(NPuntosDerivadaValue,MatrizCorrienteTest,Voltaje,1,NumeroCurvasValue);
   
    % Normalizing (or not) the data
% ------------------------------------------------------------------------
	if handles.NormalizationFlag.Value                            
        [MatrizNormalizadaTest] = normalizacionPA(VoltajeNormalizacionSuperior,...
                                              VoltajeNormalizacionInferior,...
                                              Voltaje,...
                                              MatrizConductanciaTest,...
                                              1,NumeroCurvasValue);
        ConductanciaTunel = 1;
    else
        MatrizNormalizadaTest = MatrizConductanciaTest; % units: uS
        ConductanciaTunel = mean(max(MatrizCorrienteTest))/max(Voltaje);
	end
% ------------------------------------------------------------------------  

    axes(handles.EjesCorriente);
    cla(handles.EjesCorriente);
    
    hold(handles.EjesCorriente,'on');
    hold on
    for ContadorCurvas = 1:NumeroCurvasValue
        plot(Voltaje,MatrizCorrienteTest(:,ContadorCurvas),'-');
    end
    hold off
    hold(handles.EjesCorriente,'off');
    handles.EjesCorriente.MinorGridLineStyle = ':';

    xlabel(handles.EjesCorriente,'Bias voltage (mV)',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    ylabel(handles.EjesCorriente,'Tunnel current (nA)',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    title(handles.EjesCorriente,'IV',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
                
    handles.EjesCorriente.XLim = [min(Voltaje),                  max(Voltaje)];
    handles.EjesCorriente.YLim = [mean(min(MatrizCorrienteTest)) mean(max(MatrizCorrienteTest))];
    box on; grid on;

    axes(handles.EjesConductancia);
    cla(handles.EjesConductancia);
    
    hold(handles.EjesConductancia,'on');
    for ContadorCurvas = 1:NumeroCurvasValue
        plot(Voltaje,MatrizNormalizadaTest(:,ContadorCurvas),'-','Parent',handles.EjesConductancia);
    end
    
    handles.EjesConductancia.MinorGridLineStyle = ':';
    handles.EjesConductancia.MinorGridColor = 'k';

    title(handles.EjesConductancia,'Conductance examples',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    xlabel(handles.EjesConductancia,'Bias voltage (mV)',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
    handles.EjesConductancia.XLim = [min(Voltaje) max(Voltaje)];
    
    box on; grid on;
    
        if handles.NormalizationFlag.Value
            
            plot([VoltajeNormalizacionInferior,   VoltajeNormalizacionInferior], [0, 2*ConductanciaTunel],'b-',...
                'Parent',handles.EjesConductancia);
            plot([-VoltajeNormalizacionInferior, -VoltajeNormalizacionInferior], [0, 2*ConductanciaTunel],'b-',...
                'Parent',handles.EjesConductancia);
            plot([VoltajeNormalizacionSuperior,   VoltajeNormalizacionSuperior], [0, 2*ConductanciaTunel],'r-',...
                'Parent',handles.EjesConductancia);
            plot([-VoltajeNormalizacionSuperior, -VoltajeNormalizacionSuperior], [0, 2*ConductanciaTunel],'r-',...
                'Parent',handles.EjesConductancia);
            
            ylabel(handles.EjesConductancia,'Normalized conductance',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
                handles.EjesConductancia.YLim = [0, 2*ConductanciaTunel];
                
        else
            
            ylabel(handles.EjesConductancia,'Conductance \muS',...
                    'FontSize',TamanhoFuenteTitulos,...
                    'FontName',TipoFuente);
                handles.EjesConductancia.YLim = [0, 2*ConductanciaTunel];
        end
        
        hold(handles.EjesConductancia,'off');


    % Variable data (analysis)
    % ---------------------------------------------
        handles.Struct.NumeroCurvas                 = NumeroCurvasValue;
        handles.Struct.NPuntosDerivada              = NPuntosDerivadaValue;
        handles.Struct.VoltajeNormalizacionInferior	= VoltajeNormalizacionInferior;
        handles.Struct.VoltajeNormalizacionSuperior	= VoltajeNormalizacionSuperior;
        handles.Struct.OffsetVoltaje                = OffsetVoltajeValue;

guidata(hObject, handles);


% --- Executes on button press in ImageAnalysis.
function ImageAnalysis_Callback(~, ~, handles)
% hObject    handle to ImageAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Date       = datetime;
SaveFolder = handles.Struct.SaveFolder;
FileName   = handles.Struct.FileName;
    
FileID = fopen([[SaveFolder,'\'],FileName(1:length(FileName)-4),'.txt'],'a');
        fprintf(FileID, '\r\n');
        fprintf(FileID, '\r\n');
        fprintf(FileID, 'Fecha análisis: %s \r\n',char(Date));
        fprintf(FileID, '-------------------------------\r\n');
        fprintf(FileID, 'Number of curves      : %g \r\n',handles.Struct.NumeroCurvas );
        fprintf(FileID, 'Deriv points          : %g \r\n',handles.Struct.NPuntosDerivada ); 
        fprintf(FileID, 'Offset                : %g mV\r\n', handles.Struct.OffsetVoltaje);
        fprintf(FileID, 'Normalize min         : %g mV\r\n',handles.Struct.VoltajeNormalizacionInferior);
        fprintf(FileID, 'Normalize max         : %g mV\r\n',handles.Struct.VoltajeNormalizacionSuperior); 
        fclose(FileID);

handles.Struct.datosIniciales = customCurvesv3(handles.Struct.SaveFolder, handles.Struct.FileName, handles.Struct);
assignin('base','Struct',handles.Struct);
evalin('base', 'AnalisisImagenesConductancia_PrevioIV;');




function VoltajeNormalizacionInferiorText_Callback(~, ~, ~)
% hObject    handle to VoltajeNormalizacionInferiorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoltajeNormalizacionInferiorText as text
%        str2double(get(hObject,'String')) returns contents of VoltajeNormalizacionInferiorText as a double


% --- Executes during object creation, after setting all properties.
function VoltajeNormalizacionInferiorText_CreateFcn(hObject, ~, ~)
% hObject    handle to VoltajeNormalizacionInferiorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VoltajeNormalizacionSuperiorText_Callback(~, ~, ~)
% hObject    handle to VoltajeNormalizacionSuperiorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoltajeNormalizacionSuperiorText as text
%        str2double(get(hObject,'String')) returns contents of VoltajeNormalizacionSuperiorText as a double


% --- Executes during object creation, after setting all properties.
function VoltajeNormalizacionSuperiorText_CreateFcn(hObject, ~, ~)
% hObject    handle to VoltajeNormalizacionSuperiorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function PanelAnalisis_WindowButtonDownFcn(~, ~, ~)
% hObject    handle to PanelAnalisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Down()


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function PanelAnalisis_WindowButtonUpFcn(~, ~, ~)
% hObject    handle to PanelAnalisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Up()


% --- Executes on mouse motion over figure - except title and menu.
function PanelAnalisis_WindowButtonMotionFcn(~, ~, ~)
% hObject    handle to PanelAnalisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrentPoint()


% --- Executes on button press in ChangeCurves.
function ChangeCurves_Callback(~, ~, ~)
% hObject    handle to ChangeCurves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ChangeCurves
