 function varargout = GuiAnalysisv2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',                          mfilename, ...
                   'gui_Singleton',                     gui_Singleton, ...
                   'gui_OpeningFcn',                    @GuiAnalysisv2_OpeningFcn, ...
                   'gui_OutputFcn',                     @GuiAnalysisv2_OutputFcn, ...
                   'gui_LayoutFcn',                     [] , ...
                   'gui_Callback',                      [],...
                   'gui_energySlider_Callback',         @energySlider_Callback,...
                   'energySlider_CreateFcn',            @energySlider_CreateFcn,...
                   'profileFFTPush_Callback',           @profileFFTPush_Callback,...
                   'profileRealPush_Callback',          @profileRealPush_Callback,...
                   'minValueRealSpace_Callback',        @minValueRealSpace_Callback,...
                   'minValueRealSpace_CreateFcn',       @minValueRealSpace_CreateFcn,...
                   'maxValueRealSpace_Callback',        @maxValueRealSpace_Callback,...
                   'maxValueRealSpace_CreateFcn',       @maxValueRealSpace_CreateFcn,...
                   'minValueFourierSpace_Callback',     @minValueFourierSpace_Callback,...
                   'minValueFourierSpace_CreateFcn',    @minValueFourierSpace_CreateFcn,...
                   'maxValueFourierSpace_Callback',     @maxValueFourierSpace_Callback,...
                   'maxValueFourierSpace_CreateFcn',    @maxValueFourierSpace_CreateFcn,...
                   'realSpaceImage_ButtonDownFcn',      @realSpaceImage_ButtonDownFcn,...
                   'SaveIMGPush_CreateFcn',             @SaveIMGPush_CreateFcn,...
                   'SaveIMGPush_Callback',              @SaveIMGPush_Callback,...
                   'figurePush_Callback',               @figurePush_Callback,...
                   'fourierSpaceImage_ButtonDownFcn',   @fourierSpaceImage_ButtonDownFcn,...
                   'figureFFTpush_Callback',            @figureFFTpush_Callback,...
                   'zoomPush_Callback',                 @zoomPush_Callback,...
                   'zoomFFTPush_Callback',              @zoomFFTPush_Callback,...
                   'zoomFFTPush_CreateFcn',             @zoomFFTPush_CreateFcn);
               
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); % Pepe, ¿Qué hace esto?
else
    gui_mainfcn(gui_State, varargin{:});
end

Struct = evalin('base','Struct');
global Energia
global DistanciaFilas
global DistanciaColumnas
global MapasConductanciaEqualizados
global DistanciaFourierFilas
global DistanciaFourierColumnas
global TransformadasEqualizados 
global TamanhoRealFilas
global TamanhoRealColumnas
global ParametroRedColumnas
global ParametroRedFilas
global Voltaje
global MatrizNormalizada
global kInicial
global Filas
global Columnas
global MaxCorteConductancia
global MinCorteConductancia
global SaveFolder
global TransformadasSimetrizadas

Energia                      = Struct.Energia;
DistanciaColumnas            = Struct.DistanciaColumnas;
DistanciaFilas               = Struct.DistanciaFilas;
MapasConductanciaEqualizados = Struct.MapasConductanciaEqualizados;
DistanciaFourierFilas        = Struct.DistanciaFourierFilas;
DistanciaFourierColumnas     = Struct.DistanciaFourierColumnas;
TransformadasEqualizados     = Struct.TransformadasEqualizados;
TamanhoRealFilas             = Struct.TamanhoRealFilas;
TamanhoRealColumnas          = Struct.TamanhoRealColumnas;
ParametroRedColumnas         = Struct.ParametroRedColumnas;
ParametroRedFilas            = Struct.ParametroRedFilas;
Voltaje                      = Struct.Voltaje;
MatrizNormalizada            = Struct.MatrizNormalizada;
kInicial                     = Struct.k;
Filas                        = Struct.Filas;
Columnas                     = Struct.Columnas;
MaxCorteConductancia         = Struct.MaxCorteConductancia;
MinCorteConductancia         = Struct.MinCorteConductancia;
SaveFolder                   = Struct.SaveFolder;


% End initialization code - DO NOT EDIT

% --- Executes just before GuiAnalysisv2 is made visible.
function GuiAnalysisv2_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiAnalysisv2 (see VARARGIN)
global Energia
global DistanciaColumnas
global DistanciaFilas
global MapasConductanciaEqualizados
global DistanciaFourierColumnas
global DistanciaFourierFilas
global TransformadasEqualizados 
global TransformadasSimetrizadas
global kInicial
global ParametroRedColumnas
global ParametroRedFilas
% Choose default command line output for GuiAnalysisv2
handles.output = hObject;

%Cargar colormap de la lista desplegable
nColor = handles.FFTColorMapPop.Value;
Strings = handles.FFTColorMapPop.String;
colorcillo = (strtrim(lower(Strings(nColor))));

aaa = colormap(feval(colorcillo{1}));
handles.Struct.Color = aaa;

%Iniciacion del Slider de Energia
k = kInicial;

%Iniciacion de la figura en el espacio real
cla (handles.realSpaceImage); %Clear axes
axes(handles.realSpaceImage); %Create Cartesian axes
    
ImagenReal = imagesc(DistanciaColumnas,DistanciaFilas,((MapasConductanciaEqualizados{k})));
    handles.realSpaceImage.YDir = 'normal';
    title(handles.realSpaceImage,['Mapa a',' ',num2str(Energia(k)),' meV']);
    axis square;
    axis([min(DistanciaColumnas) max(DistanciaColumnas) min(DistanciaColumnas) max(DistanciaColumnas)]);
    ImagenReal.HitTest = 'Off';
    colormap jet
    
    Ratio = (handles.realSpaceImage.XLim(2) - handles.realSpaceImage.XLim(1))/...
    (handles.realSpaceImage.YLim(2) - handles.realSpaceImage.YLim(1));
    handles.realSpaceImage.DataAspectRatio = [100,100*Ratio,1];
    
    handles.minValueRealSpace.Min = min(min(MapasConductanciaEqualizados{k}));
    handles.minValueRealSpace.Max = max(max(MapasConductanciaEqualizados{k}));
    handles.minValueRealSpace.Value = handles.minValueRealSpace.Min;
    
    handles.maxValueRealSpace.Min = min(min(MapasConductanciaEqualizados{k}));
    handles.maxValueRealSpace.Max = max(max(MapasConductanciaEqualizados{k}));
    handles.maxValueRealSpace.Value = handles.maxValueRealSpace.Max;
    
    %handles.MinRealValueTxt.String = num2str(round(hObject.Value, 4)); 
    handles.realSpaceImage.CLim = [handles.minValueRealSpace.Value handles.maxValueRealSpace.Value] ;

%Iniciacion de la figura en espacio reciproco
cla(handles.fourierSpaceImage); %Clear axes
axes(handles.fourierSpaceImage); %Create Cartesian axes
    
    if handles.SimetrizadaRadio.Value
    ImagenFourier = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasSimetrizadas{k});
    else
    ImagenFourier = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasEqualizados{k});
    end 
    handles.fourierSpaceImage.YDir = 'normal';
        ImagenFourier.HitTest = 'Off';
        title(handles.fourierSpaceImage,['2D-FFT a',' ',num2str(Energia(k)),' meV']);
        
        if handles.BrillouinBox.Value
            axis([-1/(2*ParametroRedColumnas) 1/(2*ParametroRedColumnas) -1/(2*ParametroRedFilas) 1/(2*ParametroRedFilas)]);
        else
        axis([min(DistanciaFourierColumnas) max(DistanciaFourierColumnas) min(DistanciaFourierFilas) max(DistanciaFourierFilas)]);
        %axis square;
        Ratio = (handles.fourierSpaceImage.XLim(2) - handles.fourierSpaceImage.XLim(1))/...
        (handles.fourierSpaceImage.YLim(2) - handles.fourierSpaceImage.YLim(1));
        handles.fourierSpaceImage.DataAspectRatio = [100,100*Ratio,1];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Brillouin zone
            %axis([-1/(2*ParametroRedColumnas) 1/(2*ParametroRedColumnas) -1/(2*ParametroRedFilas) 1/(2*ParametroRedFilas)]);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xlabel(handles.fourierSpaceImage,'Momentum (2\pi/a)');
      
        


    handles.MaxContrastFFTEdit.String = num2str(round(max(max(TransformadasEqualizados{k})),5));
    handles.MinContrastFFTEdit.String = num2str(round(min(min(TransformadasEqualizados{k})),5));   
    
    handles.minValueFourierSpace.Min = min(min(TransformadasEqualizados{k}));
    handles.minValueFourierSpace.Max = max(max(TransformadasEqualizados{k}));
    handles.minValueFourierSpace.Value = handles.minValueFourierSpace.Min;
    
    handles.maxValueFourierSpace.Min = min(min(TransformadasEqualizados{k}));
    handles.maxValueFourierSpace.Max = max(max(TransformadasEqualizados{k}));
    handles.maxValueFourierSpace.Value = handles.minValueFourierSpace.Max;
    
    handles.FourierSpaceImage.CLim = [handles.minValueFourierSpace.Value handles.maxValueFourierSpace.Value] ;
    
    % Update handles structure
    handles.MinEnergyTxt.String = [num2str(round(Energia(1), 2)), ' mV'];
    handles.MaxEnergyTxt.String = [num2str(round(Energia(end), 2)), ' mV'];
    
guidata(hObject, handles);

% UIWAIT makes GuiAnalysisv2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GuiAnalysisv2_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function energySlider_Callback(hObject, ~, handles)
% hObject    handle to energySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Energia
global DistanciaColumnas
global DistanciaFilas
global MapasConductanciaEqualizados
global DistanciaFourierColumnas
global DistanciaFourierFilas
global TransformadasEqualizados 
global TransformadasSimetrizadas
global ParametroRedFilas
global ParametroRedColumnas

k = round(get(hObject,'Value'));
handles.ValueEnergyTxt.String = [num2str(round(Energia(k), 2)), ' mV'];

%Real Space
cla (handles.realSpaceImage);
axes(handles.realSpaceImage);

ImagenReal = imagesc(DistanciaColumnas,DistanciaFilas,((MapasConductanciaEqualizados{k})));
handles.realSpaceImage.YDir = 'normal';
  
       
title(handles.realSpaceImage,['Mapa a',' ',num2str(Energia(k)),' meV']);
    cte3 = handles.minValueRealSpace.Value/abs(handles.minValueRealSpace.Max-handles.minValueRealSpace.Min);
    cte4 = handles.maxValueRealSpace.Value/abs(handles.maxValueRealSpace.Max-handles.maxValueRealSpace.Min);
    
    handles.minValueRealSpace.Min = min(min(MapasConductanciaEqualizados{k}));
    handles.minValueRealSpace.Max = max(max(MapasConductanciaEqualizados{k}));
    handles.maxValueRealSpace.Min = min(min(MapasConductanciaEqualizados{k}));
    handles.maxValueRealSpace.Max = max(max(MapasConductanciaEqualizados{k}));

    handles.minValueRealSpace.Value = cte3*abs(handles.minValueRealSpace.Max-handles.minValueRealSpace.Min);
    handles.maxValueRealSpace.Value = cte4*abs(handles.maxValueRealSpace.Max-handles.maxValueRealSpace.Min);   
    handles.realSpaceImage.CLim = [handles.minValueRealSpace.Value handles.maxValueRealSpace.Value] ;
    %handles.realSpaceImage.CLim = [handles.minValueRealSpace.Value handles.maxValueRealSpace.Value] ;       
% handles.realSpaceImage.CLim = [min(min(MapasConductanciaEqualizados{k})) max(max(MapasConductanciaEqualizados{k}))] ;
ImagenReal.ButtonDownFcn = @(hObject,eventdata)GuiAnalysisv2('realSpaceImage_ButtonDownFcn',hObject,eventdata,guidata(hObject));

%Fourier Space
cla (handles.fourierSpaceImage);
axes(handles.fourierSpaceImage);
if handles.SimetrizadaRadio.Value
 ImagenFourier = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasSimetrizadas{k});

else
ImagenFourier = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasEqualizados{k});
end
handles.fourierSpaceImage.YDir = 'normal';

if handles.BrillouinBox.Value
    axis([-1/(2*ParametroRedColumnas) 1/(2*ParametroRedColumnas) -1/(2*ParametroRedFilas) 1/(2*ParametroRedFilas)]);
% else
%     axis([min(DistanciaFourierColumnas) max(DistanciaFourierColumnas) min(DistanciaFourierFilas) max(DistanciaFourierFilas)]);
%     %axis square;
%     Ratio = (handles.fourierSpaceImage.XLim(2) - handles.fourierSpaceImage.XLim(1))/...
%     (handles.fourierSpaceImage.YLim(2) - handles.fourierSpaceImage.YLim(1));
%     handles.fourierSpaceImage.DataAspectRatio = [100,100*Ratio,1];
end
    
title(handles.fourierSpaceImage,['2D-FFT a',' ',num2str(Energia(k)),' meV']);

handles.MaxContrastFFTEdit.String = num2str(round(max(max(TransformadasEqualizados{k})),5));
handles.MinContrastFFTEdit.String = num2str(round(min(min(TransformadasEqualizados{k})),5));

    cte1 = handles.minValueFourierSpace.Value/abs(handles.minValueFourierSpace.Max-handles.minValueFourierSpace.Min);
    cte2 = handles.maxValueFourierSpace.Value/abs(handles.maxValueFourierSpace.Max-handles.maxValueFourierSpace.Min);
    
    handles.minValueFourierSpace.Min = min(min(TransformadasEqualizados{k}));
    handles.minValueFourierSpace.Max = max(max(TransformadasEqualizados{k}));
    %handles.minValueFourierSpace.Value = handles.minValueFourierSpace.Min;
    
    handles.maxValueFourierSpace.Min = min(min(TransformadasEqualizados{k}));
    handles.maxValueFourierSpace.Max = max(max(TransformadasEqualizados{k}));
    %handles.maxValueFourierSpace.Value = handles.minValueFourierSpace.Max;
   
    handles.minValueFourierSpace.Value = cte1*abs(handles.minValueFourierSpace.Max-handles.minValueFourierSpace.Min);
    handles.maxValueFourierSpace.Value = cte2*abs(handles.maxValueFourierSpace.Max-handles.maxValueFourierSpace.Min);   
    handles.fourierSpaceImage.CLim = [handles.minValueFourierSpace.Value handles.maxValueFourierSpace.Value] ;
  %handles.fourierSpaceImage.CLim = [handles.minValueFourierSpace.Value handles.maxValueFourierSpace.Value] ;
  
ImagenFourier.ButtonDownFcn = @(hObject,eventdata)GuiAnalysisv2('fourierSpaceImage_ButtonDownFcn',hObject,eventdata,guidata(hObject));
guidata(hObject,handles)

function energySlider_CreateFcn(hObject, ~, ~)
% hObject    handle to energySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    hObject.BackgroundColor = [.9 .9 .9];
end

global Energia;
k = ceil(length(Energia)/2);

    hObject.Max = length(Energia);
    hObject.Min = 1 ;
    hObject.SliderStep = [1/(length(Energia)-1), 1-1/(length(Energia)-1)];
    hObject.Value = k;
    guidata(hObject,handles)

    function profileFFTPush_Callback(~, ~, handles)
% hObject    handle to profileFFTPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

punteroT = handles.fourierSpaceImage.CurrentPoint;

global TransformadasEqualizados
global Energia
global Filas
global Columnas
global DistanciaFourierColumnas
global DistanciaFourierFilas
global SaveFolder
    
k = round(get(handles.energySlider,'Value'));

    if exist('handles.Struct.Puntero','var')
    	handles.Struct.PunteroFFT = [struct.Puntero; punteroT(1,1), punteroT(1,2)];
    else
        handles.Struct.PunteroFFT = [punteroT(1,1), punteroT(1,2)];
    end
    size(handles.Struct.PunteroFFT)
    
TransformadasEqualizadosf = zeros(Columnas,Filas,length(Energia));

    for i = 1:length(Energia)
        TransformadasEqualizadosf(:,:,i) = TransformadasEqualizados{i};
    end
    % Con esta vuelta de tuerca podemos usar las mismas funciones. Pasamos
    % los mapas de las FFT como ristras [length(Energia)xFilasxColumnas]
TransformadasEqualizadosfAUX = permute(TransformadasEqualizadosf,[3 2 1]);
TransformadasEqualizadosfAUX = reshape(TransformadasEqualizadosfAUX,[length(Energia),Filas*Columnas]);

perfilIVPA(TransformadasEqualizados{k}, Energia,TransformadasEqualizadosfAUX, DistanciaFourierColumnas, DistanciaFourierFilas,SaveFolder);

function profileRealPush_Callback(~, ~, handles)
% hObject    handle to profileRealPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DistanciaColumnas
global DistanciaFilas
global Voltaje
global MatrizNormalizada
global MapasConductanciaEqualizados
global SaveFolder

k = round(handles.energySlider.Value);
[DistanciaPerfil,PerfilActual, CurvasPerfil] = perfilIVPA(MapasConductanciaEqualizados{k}, Voltaje,MatrizNormalizada, DistanciaColumnas, DistanciaFilas,SaveFolder);

%   REPRESENTACION PERFIL
% ----------------------------
FigPerfil = figure(233);
    FigPerfil.Color = [1 1 1];
    EjePerfil = axes('Parent',FigPerfil,'FontSize',14,'FontName','Arial');
    hold(EjePerfil,'on');
        plot(DistanciaPerfil,PerfilActual,'k--','Parent',EjePerfil);
        scatter(DistanciaPerfil,PerfilActual,100,'Filled','CData',PerfilActual,...
            'Parent',EjePerfil);
    ylabel(EjePerfil,'Normalized conductance','FontSize',16);
    xlabel(EjePerfil,'Distance (nm)','FontSize',16);
    box on;
    hold(EjePerfil,'off');
   
FigSurfPerfil = figure('Color',[1 1 1]);
	FigSurfPerfil.Position = [367   286   727   590];
    EjeSurfPerfil = axes('Parent',FigSurfPerfil,'FontSize',16,'FontName','Arial',...
        'Position',[0.158351084541563 0.1952 0.651099711483654 0.769800000000001],...
        'CameraPosition',[0 0 5],...
        'YTick',[]);
    hold(EjeSurfPerfil,'on');
    surf(Voltaje,DistanciaPerfil,CurvasPerfil','Parent',EjeSurfPerfil,'MeshStyle','row',...
        'FaceColor','interp');
    xlabel(EjeSurfPerfil,'Bias voltage (mV)','FontSize',18,'FontName','Arial');
        EjeSurfPerfil.XLim = [min(Voltaje) max(Voltaje)];
    ylabel(EjeSurfPerfil,'Distance (nm)','FontSize',18,'FontName','Arial','Rotation',90);
        EjeSurfPerfil.YLim = [min(DistanciaPerfil), max(DistanciaPerfil)];
    EjeSurfPerfil.ZTick = [];
    hold(EjeSurfPerfil,'off');
    
    axes(handles.realSpaceImage);
    
function minValueRealSpace_Callback(hObject, ~, handles)
% hObject    handle to minValueRealSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    if hObject.Value > handles.maxValueRealSpace.Value
        hObject.Value = handles.maxValueRealSpace.Value - 0.1 ;
    end
    
    %round(hObject.Value, 4)
    handles.MinRealValueTxt.String = num2str(round(hObject.Value, 4)); 
   
    handles.realSpaceImage.CLim = [get(hObject,'Value'), get(handles.maxValueRealSpace,'Value')] ;
% --- Executes during object creation, after setting all properties.
function minValueRealSpace_CreateFcn(hObject,~,~)
% hObject    handle to minValueRealSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global MaxCorteConductancia;
    global MinCorteConductancia;
    
    set(hObject,'Max', MaxCorteConductancia)
    set(hObject,'Min', MinCorteConductancia)
handles.MinRealValueTxt.String = round(hObject.Value, 4); 
% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function maxValueRealSpace_Callback(hObject, ~, handles)
% hObject    handle to maxValueRealSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


    if hObject.Value < handles.minValueRealSpace.Value
        hObject.Value = handles.minValueRealSpace.Value +0.1;
    end
handles.MaxRealValueTxt.String = round(hObject.Value, 4); 
handles.realSpaceImage.CLim = [get(handles.minValueRealSpace,'Value'), get(hObject,'Value') ] ; 


% --- Executes during object creation, after setting all properties.
function maxValueRealSpace_CreateFcn(hObject, ~, ~)
% hObject    handle to maxValueRealSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    global MaxCorteConductancia;
    global MinCorteConductancia;
    
    set(hObject,'Max', MaxCorteConductancia)
    set(hObject,'Min', MinCorteConductancia)

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
handles.MaxRealValueTxt.String = round(hObject.Value, 4); 
hObject.Value = hObject.Max - 0.01;

% --- Executes on slider movement.
function minValueFourierSpace_Callback(hObject, ~, handles)
% hObject    handle to minValueFourierSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

 set(hObject,'Max', str2double((handles.MaxContrastFFTEdit.String)))
 set(hObject,'Min',str2double((handles.MinContrastFFTEdit.String)))

    handles.fourierSpaceImage.CLim = [get(hObject,'Value'), get(handles.maxValueFourierSpace,'Value')];  
 guidata(hObject,handles)

 % --- Executes during object creation, after setting all properties.
 function minValueFourierSpace_CreateFcn(hObject, ~, ~)
% hObject    handle to minValueFourierSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global TransformadasEqualizados
global kInicial

set(hObject,'Max', str2double((handles.MaxContrastFFTEdit.String)))
set(hObject,'Min',str2double((handles.MinContrastFFTEdit.String)))
 guidata(hObject,handles)
 
function maxValueFourierSpace_Callback(hObject, ~, handles)
% hObject    handle to maxValueFourierSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%     global TransformadasEqualizados
% 
%     k = round(handles.energySlider.Value);
%     set(handles.minValueFourierSpace,'Min', (min(min(TransformadasEqualizados{k}))))
%     set(handles.minValueFourierSpace,'Max',(max(max(TransformadasEqualizados{k}))))
%     set(handles.maxValueFourierSpace,'Min', (min(min(TransformadasEqualizados{k}))))
%     set(handles.maxValueFourierSpace,'Max',(max(max(TransformadasEqualizados{k}))))
% 
%     if handles.minValueFourierSpace.Value < hObject.Min || handles.minValueFourierSpace.Value > hObject.Max
%         handles.minValueFourierSpace.Value = hObject.Min;
%     end
% 
%     if handles.maxValueFourierSpace.Value < hObject.Min ||  handles.maxValueFourierSpace.Value > hObject.Max
%     	handles.maxValueFourierSpace.Value = hObject.Max;
%     end
% 
%     if hObject.Value < handles.minValueFourierSpace.Value
%     	hObject.Value = handles.minValueFourierSpace.Value +0.1;
%     end
set(hObject,'Max', str2double((handles.MaxContrastFFTEdit.String)))
set(hObject,'Min',str2num((handles.MinContrastFFTEdit.String)))

handles.MaxFftValueTxt.String = round(hObject.Value, 4);
%set(hObject,'Max', max(max(max(MapasConductanciaEqualizados{1}))))
handles.fourierSpaceImage.CLim = [get(handles.minValueFourierSpace,'Value'), get(hObject,'Value') ] ; 
% guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function maxValueFourierSpace_CreateFcn(hObject, ~, ~)
% hObject    handle to maxValueFourierSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global TransformadasEqualizados
global kInicial;

 k = kInicial;

 set(hObject,'Max', str2double((handles.MaxContrastFFTEdit.String)))
 set(hObject,'Min',str2double((handles.MinContrastFFTEdit.String)))
 guidata(hObject,handles)

function realSpaceImage_ButtonDownFcn(~, ~, ~)
% hObject    handle to realSpaceImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function SaveIMGPush_CreateFcn(~, ~, ~)
% hObject    handle to maxValueFourierSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

function SaveIMGPush_Callback(~, ~, handles)
% hObject    handle to realSpaceImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Energia;
    global Filas;
    global Columnas;
    global MapasConductanciaEqualizados;
    
    Struct          = evalin('base','Struct');
    k               = round(handles.energySlider.Value) ;
    FileNameTopo    = Struct.FileNameTopo   ;
    ReadFilePath    = [Struct.FilePathTopo, Struct.FileNameTopo ];
    SaveFolder      = Struct.SaveFolder ;
    writeIMG(Filas,Columnas, MapasConductanciaEqualizados{k}, ReadFilePath, ...
             [SaveFolder,'\',FileNameTopo(1:end-4),'Cond', num2str(Energia(k)),'Bias', '.img']);
  
% --- Executes on button press in figurePush.
function figurePush_Callback(~, ~, handles)
% hObject    handle to figurePush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k          = round(handles.energySlider.Value) ;
global MapasConductanciaEqualizados;
global DistanciaColumnas
global DistanciaFilas

FigExtra = figure;

    FigExtra.Color = [1 1 1];
    FigExtra_Ejes = axes('Parent',FigExtra,'Box','on');
    
    Mapa = MapasConductanciaEqualizados{k};

    Imagen = imagesc(DistanciaColumnas,DistanciaFilas,Mapa);
        Imagen.Parent = FigExtra_Ejes;
    	FigExtra_Ejes.YDir = 'normal';
        

        FigExtra_Ejes.FontSize = 14;
        
        axis([handles.realSpaceImage.XLim handles.realSpaceImage.YLim]);
        caxis([handles.minValueRealSpace.Value handles.maxValueRealSpace.Value]);
        
        Ratio = (handles.realSpaceImage.XLim(2) - handles.realSpaceImage.XLim(1))/...
        (handles.realSpaceImage.YLim(2) - handles.realSpaceImage.YLim(1));
   ax=gca; 
    ax.DataAspectRatio = [100,100*Ratio,1];
    
        colorbar;
        colormap(handles.Struct.Color)
        
Imagen.HitTest ='Off';

% --- Executes on mouse press over axes background.
function fourierSpaceImage_ButtonDownFcn(~, ~, ~)
% hObject    handle to fourierSpaceImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in figureFFTpush.
function figureFFTpush_Callback(~, ~, handles)
% hObject    handle to figureFFTpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k = round(handles.energySlider.Value) ;
global TransformadasEqualizados;
global TransformadasSimetrizadas;
global DistanciaFourierColumnas
global DistanciaFourierFilas;
global Energia;


FigExtra = figure;

    FigExtra.Color = [1 1 1];
    FigExtra_Ejes = axes('Parent',FigExtra,'Box','on');
  
 if handles.SimetrizadaRadio.Value
  Imagen = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasSimetrizadas{k});

 else
    Imagen = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasEqualizados{k});
 end
    Imagen.Parent = FigExtra_Ejes;
    	FigExtra_Ejes.YDir = 'normal';
        FigExtra_Ejes.FontSize = 14;
        
    axis square;
    axis([handles.fourierSpaceImage.XLim handles.fourierSpaceImage.YLim]);
    caxis([handles.minValueFourierSpace.Value handles.maxValueFourierSpace.Value]);
    colorbar
    colormap(handles.Struct.Color)
   title([num2str(Energia(k)), ' mV']); 
    
   Ratio = (handles.fourierSpaceImage.XLim(2) - handles.fourierSpaceImage.XLim(1))/...
        (handles.fourierSpaceImage.YLim(2) - handles.fourierSpaceImage.YLim(1));
   ax=gca; 
    ax.DataAspectRatio = [100,200*Ratio,1];
%    fig = gcf;
%       fig.Position = [540 100 400 400/Ratio];
%       fig.PaperPositionMode = 'auto'; 
    
Imagen.HitTest ='Off';

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Down();

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(~, ~, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        global TransformadasEqualizados
        global Energia
        global Filas
        global Columnas
        global DistanciaFourierFilas
        global DistanciaFourierColumnas
        global DistanciaColumnas
        global DistanciaFilas
        global Voltaje
        global MatrizNormalizada
        global MapasConductanciaEqualizados

[ax, btn, Movimiento] = Up();
    Ratio = (ax.XLim(2) - ax.XLim(1))/...
        (ax.YLim(2) - ax.YLim(1));
   PosicionAx = ax.Position;
   ax.UserData.Rectangle
%    if Ratio < 1
%         ax.Position = [PosicionAx(1), PosicionAx(2), PosicionAx(3)*Ratio PosicionAx(4)];
%    else
%        ax.Position = [PosicionAx(1), PosicionAx(2), PosicionAx(3) PosicionAx(4)/Ratio];
%    end
if strcmp(btn, 'alt') && Movimiento 
    Rectangle = ax.UserData.Rectangle;
 MeanIVFunction(Rectangle, MatrizNormalizada, Voltaje, Columnas, Filas, DistanciaColumnas)
end
    
if strcmp(btn, 'normal') && ~Movimiento
   
    if strcmp(ax.Tag,'realSpaceImage') 
        punteroT = handles.realSpaceImage.CurrentPoint;
        
        
        k = round(get(handles.energySlider,'Value'));

        if exist('Struct.Puntero','var');
            Struct.Puntero = [struct.Puntero; punteroT(1,1), punteroT(1,2)];
        else
            Struct.Puntero = [punteroT(1,1), punteroT(1,2)];
        end

        curvaUnicaPA(Struct.Puntero, MapasConductanciaEqualizados{k}, Voltaje,MatrizNormalizada, DistanciaColumnas,DistanciaFilas,true);
    
    elseif strcmp(ax.Tag,'fourierSpaceImage') && ~Movimiento
        punteroT = handles.fourierSpaceImage.CurrentPoint;

        k = round(get(handles.energySlider,'Value'));
        TransformadasEqualizadosf = zeros(Filas,Columnas,length(Energia));
        
        if exist('handles.Struct.Puntero','var')
            handles.Struct.PunteroFFT = [struct.Puntero; punteroT(1,1), punteroT(1,2)];
        else
            handles.Struct.PunteroFFT = [punteroT(1,1), punteroT(1,2)];
        end
        
        size(handles.Struct.PunteroFFT);
       
        for i = 1:length(Energia)
            TransformadasEqualizadosf(:,:,i) = TransformadasEqualizados{i};
        end
        % Con esta vuelta de tuerca podemos usar las mismas funciones. Pasamos
        % los mapas de las FFT como ristras [length(Energia)xFilasxColumnas]
        TransformadasEqualizadosfAUX = permute(TransformadasEqualizadosf,[3 2 1]);
        TransformadasEqualizadosfAUX = reshape(TransformadasEqualizadosfAUX,[length(Energia),Filas*Columnas]);
   
        curvaUnicaPA(handles.Struct.PunteroFFT, TransformadasEqualizados{k}, Energia, TransformadasEqualizadosfAUX, DistanciaFourierColumnas,DistanciaFourierFilas, false );    
    end
end

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CurrentPoint()

% --- Executes on button press in SavePngPush.
function SavePngPush_Callback(hObject, eventdata, handles)
% hObject    handle to SavePngPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TransformadasEqualizados;
global DistanciaFourierColumnas;
global DistanciaFourierFilas;
global Energia
global SaveFolder
global TransformadasSimetrizadas

[PathName] = uigetdir(SaveFolder);

if handles.AllCheck.Value
    for k= 1:size(TransformadasEqualizados,1)
    FigExtra = figure;
    FigExtra.Visible = 'off';
    FigExtra.Color = [1 1 1];
    FigExtra_Ejes = axes('Parent',FigExtra,'Box','on');
    if handles.SimetrizadaRadio.Value
        Imagen = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasSimetrizadas{k});

    else
        Imagen = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasEqualizados{k});
    end
    
    colormap(handles.Struct.Color);
    
    title([num2str(Energia(k)), ' mV']);    
    Imagen.Parent = FigExtra_Ejes;
    	FigExtra_Ejes.YDir = 'normal';
        FigExtra_Ejes.FontSize = 14;
        
        
   
    axis([handles.fourierSpaceImage.XLim handles.fourierSpaceImage.YLim]);
    cte1 = handles.minValueFourierSpace.Value/abs(handles.minValueFourierSpace.Max-handles.minValueFourierSpace.Min);
    cte2 = handles.maxValueFourierSpace.Value/abs(handles.maxValueFourierSpace.Max-handles.maxValueFourierSpace.Min);
    
    handles.minValueFourierSpace.Min = min(min(TransformadasEqualizados{k}));
    handles.minValueFourierSpace.Max = max(max(TransformadasEqualizados{k}));
    
    handles.maxValueFourierSpace.Min = min(min(TransformadasEqualizados{k}));
    handles.maxValueFourierSpace.Max = max(max(TransformadasEqualizados{k}));
   
    handles.minValueFourierSpace.Value = cte1*abs(handles.minValueFourierSpace.Max-handles.minValueFourierSpace.Min);
    handles.maxValueFourierSpace.Value = cte2*abs(handles.maxValueFourierSpace.Max-handles.maxValueFourierSpace.Min);   
    handles.fourierSpaceImage.CLim = [handles.minValueFourierSpace.Value handles.maxValueFourierSpace.Value] ;
    caxis([handles.fourierSpaceImage.CLim]);
    
    Ratio = (handles.fourierSpaceImage.XLim(2) - handles.fourierSpaceImage.XLim(1))/...
        (handles.fourierSpaceImage.YLim(2) - handles.fourierSpaceImage.YLim(1));
  %axis square
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Imagen.Parent.DataAspectRatio = [100,100*Ratio,1];
       ax=gca;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Personalizacion ticks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     ax.XTick = [handles.fourierSpaceImage.XLim(1) handles.fourierSpaceImage.XLim(1)*0.8 handles.fourierSpaceImage.XLim(1)*0.6 handles.fourierSpaceImage.XLim(1)*0.4 handles.fourierSpaceImage.XLim(1)*0.2 0 handles.fourierSpaceImage.XLim(2)*0.2 handles.fourierSpaceImage.XLim(2)*0.4 handles.fourierSpaceImage.XLim(2)*0.6 handles.fourierSpaceImage.XLim(2)*0.8 handles.fourierSpaceImage.XLim(2)];
%     ax.XTickLabel = {'-1' ' ' '-0.6' ' ' '-0.2' ' ' '0.2' ' ' '0.6' ' ' '1'}';
%     ax.XTickLabel = [];
%     ax.YTick = [handles.fourierSpaceImage.YLim(1) handles.fourierSpaceImage.YLim(1)*0.8 handles.fourierSpaceImage.YLim(1)*0.6 handles.fourierSpaceImage.YLim(1)*0.4 handles.fourierSpaceImage.YLim(1)*0.2 0 handles.fourierSpaceImage.YLim(2)*0.2 handles.fourierSpaceImage.YLim(2)*0.4 handles.fourierSpaceImage.YLim(2)*0.6 handles.fourierSpaceImage.YLim(2)*0.8 handles.fourierSpaceImage.YLim(2)];
%     ax.YTickLabel = {'-1','-0.8','-0.6','-0.4','-0.2','0','0.2','0.4','0.6','0.8','1'}';
%     ax.YTickLabel = [];
%     ax.LineWidth =2;
%     ax.FontWeight = 'bold';
%     ax.Visible = 'off';

%%%%%%%%%%%%%%%SIN BORDES%%%%%%%%%%%%%%
      ax.Position
      ax.OuterPosition
      ax.Position = ax.OuterPosition;
      fig = gcf;
      fig.Position = [540 100 400 400/Ratio];
      fig.PaperPositionMode = 'auto';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
      name = num2str(Energia(k));
    name = strrep(name,'.',',');
    print(FigExtra,[PathName,'/', name],'-dpng','-noui')  
  
    
    
    
    Imagen.HitTest ='Off';

    
    
    end
    helpdlg('Saved!!')
    
    
    
else
    
k = round(handles.energySlider.Value) ;
FigExtra = figure;
FigExtra.Visible = 'off';
    FigExtra.Color = [1 1 1];
    FigExtra_Ejes = axes('Parent',FigExtra,'Box','on');
    if handles.SimetrizadaRadio.Value
        Imagen = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasSimetrizadas{k});

    else
        Imagen = imagesc(DistanciaFourierColumnas,DistanciaFourierFilas,TransformadasEqualizados{k});
    end
    colormap(handles.Struct.Color);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %title([num2str(Energia(k)), ' mV']);    
        %Imagen.Parent = FigExtra_Ejes;
    	FigExtra_Ejes.YDir = 'normal';
        %FigExtra_Ejes.FontSize = 14;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
   
    axis([handles.fourierSpaceImage.XLim handles.fourierSpaceImage.YLim]);
    caxis([handles.fourierSpaceImage.CLim]);
    
        Ratio = (handles.fourierSpaceImage.XLim(2) - handles.fourierSpaceImage.XLim(1))/...
        (handles.fourierSpaceImage.YLim(2) - handles.fourierSpaceImage.YLim(1));
 
   Imagen.Parent.DataAspectRatio = [100,200*Ratio,1];
    ax=gca;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Personalizacion ticks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     ax.XTick = [handles.fourierSpaceImage.XLim(1) handles.fourierSpaceImage.XLim(1)*0.8 handles.fourierSpaceImage.XLim(1)*0.6 handles.fourierSpaceImage.XLim(1)*0.4 handles.fourierSpaceImage.XLim(1)*0.2 0 handles.fourierSpaceImage.XLim(2)*0.2 handles.fourierSpaceImage.XLim(2)*0.4 handles.fourierSpaceImage.XLim(2)*0.6 handles.fourierSpaceImage.XLim(2)*0.8 handles.fourierSpaceImage.XLim(2)];
%     ax.XTickLabel = {'-1' ' ' '-0.6' ' ' '-0.2' ' ' '0.2' ' ' '0.6' ' ' '1'}';
%     ax.XTickLabel = [];
%     ax.YTick = [handles.fourierSpaceImage.YLim(1) handles.fourierSpaceImage.YLim(1)*0.8 handles.fourierSpaceImage.YLim(1)*0.6 handles.fourierSpaceImage.YLim(1)*0.4 handles.fourierSpaceImage.YLim(1)*0.2 0 handles.fourierSpaceImage.YLim(2)*0.2 handles.fourierSpaceImage.YLim(2)*0.4 handles.fourierSpaceImage.YLim(2)*0.6 handles.fourierSpaceImage.YLim(2)*0.8 handles.fourierSpaceImage.YLim(2)];
%     ax.YTickLabel = {'-1','-0.8','-0.6','-0.4','-0.2','0','0.2','0.4','0.6','0.8','1'}';
%     ax.yTickLabel = [];
%     ax.LineWidth =2;
%     ax.FontWeight = 'bold';
%     ax.Visible = 'off';

%%%%%%%%%%%%%%%SIN BORDES%%%%%%%%%%%%%%
%       ax.Position = ax.OuterPosition;
%       fig = gcf;
%       fig.Position = [540 100 400 400/Ratio];
%       fig.PaperPositionMode = 'auto';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




    name = num2str(Energia(k));
    name = strrep(name,'.',',');
    print(FigExtra,[PathName,'/', name],'-dpng','-noui')
    
    
    
Imagen.HitTest ='Off';
end

% --- Executes on button press in AllCheck.
function AllCheck_Callback(hObject, eventdata, handles)
% hObject    handle to AllCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AllCheck



function MaxContrastFFTEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxContrastFFTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxContrastFFTEdit as text
%        str2double(get(hObject,'String')) returns contents of MaxContrastFFTEdit as a double


% --- Executes during object creation, after setting all properties.
function MaxContrastFFTEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxContrastFFTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinContrastFFTEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MinContrastFFTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinContrastFFTEdit as text
%        str2double(get(hObject,'String')) returns contents of MinContrastFFTEdit as a double


% --- Executes during object creation, after setting all properties.
function MinContrastFFTEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinContrastFFTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on MinContrastFFTEdit and none of its controls.
function MinContrastFFTEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to MinContrastFFTEdit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OkContrastButton.
function OkContrastButton_Callback(hObject, eventdata, handles)
% hObject    handle to OkContrastButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.maxValueFourierSpace,'Max', str2double((handles.MaxContrastFFTEdit.String)))
set(handles.minValueFourierSpace,'Min',str2num((handles.MinContrastFFTEdit.String)))
handles.minValueFourierSpace.Value = str2num((handles.MinContrastFFTEdit.String))*2
handles.maxValueFourierSpace.Value = str2num((handles.MaxContrastFFTEdit.String))/2
str2num((handles.MinContrastFFTEdit.String))
str2double((handles.MaxContrastFFTEdit.String))
str2num((handles.MinContrastFFTEdit.String))*2
str2num((handles.MaxContrastFFTEdit.String))/2
handles.maxValueFourierSpace.Value 
handles.maxValueFourierSpace.Max


 caxis([handles.minValueFourierSpace.Value handles.maxValueFourierSpace.Value]);
% --- Executes on button press in IVMeanRadio.
function IVMeanRadio_Callback(hObject, eventdata, handles)
% hObject    handle to IVMeanRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IVMeanRadio
 
 % --- Executes on selection change in FFTColorMapPop.
function FFTColorMapPop_Callback(hObject, eventdata, handles)
% hObject    handle to FFTColorMapPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FFTColorMapPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FFTColorMapPop

% Parula, Jet, Hot, Extreme, Spring, Summer, Autumn, Winter, Gray, 
%Bone, Copper, Pink, Red, Green, Blue.    
axes(handles.fourierSpaceImage);

Color = hObject.Value;
switch Color
    case 1      
        colormap parula
        handles.Struct.Color = colormap(parula);
    case 2
        colormap jet
        handles.Struct.Color = colormap(jet);
    case 3
        colormap hot
        handles.Struct.Color = colormap(hot);            
    case 4
            load Diverge
            colormap(Colo);
            handles.Struct.Color = colormap(Colo);    
    case 5
        colormap spring
        handles.Struct.Color = colormap(spring);    
    case 6
        colormap summer
        handles.Struct.Color = colormap(summer);
    case 7 
        colormap autumn
        handles.Struct.Color = colormap(autumn);        
    case 8
        colormap winter
        handles.Struct.Color = colormap(winter);        
    case 9
        colormap gray
        handles.Struct.Color = colormap(gray);    
    case 10
        colormap bone
        handles.Struct.Color = colormap(bone);
    case 11
        colormap copper
        handles.Struct.Color = colormap(copper);                
    case 12
        colormap pink
        handles.Struct.Color = colormap(pink);
    case 13
        c=linspace(0,1,255);
        a = linspace(0,0,255);
        c2 = [c' a' a'];
        colormap(c2)
        handles.Struct.Color = colormap(c2);
    case 14
        c=linspace(0,1,255);
        a = linspace(0,0,255);
        c2 = [ a' c' a'];
        colormap(c2)
        handles.Struct.Color = colormap(c2);
    case 15
        c=linspace(0,1,255);
        a = linspace(0,0,255);
        c2 = [ a' a' c'];
        colormap(c2)    
        handles.Struct.Color = colormap(c2);
end
    guidata(hObject,handles)




% --- Executes on button press in SimetrizadaRadio.
function SimetrizadaRadio_Callback(hObject, eventdata, handles)
% hObject    handle to SimetrizadaRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TransformadasSimetrizadas
global TransformadasEqualizados
if hObject.Value
            Angulo = 0;
           
        [TransformadasSimetrizadas] = ...
            simetrizarFFT_Automatico(TransformadasEqualizados,Angulo);
        1
else    
        
end
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of SimetrizadaRadio


% --- Executes on button press in BrillouinBox.
function BrillouinBox_Callback(hObject, eventdata, handles)
% hObject    handle to BrillouinBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BrillouinBox
