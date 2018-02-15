function varargout = FFTFilters(varargin)
% FFTFILTERS MATLAB code for FFTFilters.fig
%      FFTFILTERS, by itself, creates a new FFTFILTERS or raises the existing
%      singleton*.
%
%      H = FFTFILTERS returns the handle to a new FFTFILTERS or the handle to
%      the existing singleton*.
%
%      FFTFILTERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FFTFILTERS.M with the given input arguments.
%
%      FFTFILTERS('Property','Value',...) creates a new FFTFILTERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FFTFilters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FFTFilters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FFTFilters

% Last Modified by GUIDE v2.5 20-Oct-2017 10:46:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FFTFilters_OpeningFcn, ...
                   'gui_OutputFcn',  @FFTFilters_OutputFcn, ...
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


% --- Executes just before FFTFilters is made visible.
function FFTFilters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FFTFilters (see VARARGIN)

% Choose default command line output for FFTFilters
handles.output = hObject;
handles.MaskFlag =0;
%Load Image
axes(handles.RealSpaceAxes);

Matriz = imread('F:\Data\Codigos\Matlab\QPI theor\Imagen1.jpg');

Matriz = Matriz(1:512,1:512,2);
handles.Matriz = Matriz;
imagesc(Matriz)
axis square
shading flat
%FFT
axes(handles.FourierSpaceAxes);
MatrixFFT = fft2df(Matriz);
handles.MatrixFFT = MatrixFFT;
imagesc(-256:256, -256:256,abs(MatrixFFT))
handles.FourierSpaceAxes.CLim = [50000 100000];

axis square
shading flat

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FFTFilters wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FFTFilters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ShapePopUp.
function ShapePopUp_Callback(hObject, eventdata, handles)
% hObject    handle to ShapePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ShapePopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ShapePopUp


% --- Executes during object creation, after setting all properties.
function ShapePopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShapePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function XRadioSlide_Callback(hObject, eventdata, handles)
% hObject    handle to XRadioSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
axes(handles.FourierSpaceAxes);

eraseObjects(handles.FourierSpaceAxes, 'rectangle') ;  
Shape = handles.ShapePopUp.String(handles.ShapePopUp.Value);
if handles.CenterCheck.Value
    drawShape(Shape,0,0,handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);
else
    eraseObjects(handles.FourierSpaceAxes, 'rectangle')  
  a = handles.ShapeCenter;
    drawShape(Shape,a(1),a(2),handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);
    drawShape(Shape,-a(1),-a(2),handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);

end
guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function XRadioSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XRadioSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function YRadioSlide_Callback(hObject, eventdata, handles)
% hObject    handle to YRadioSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axes(handles.FourierSpaceAxes);
ax = handles.FourierSpaceAxes;
eraseObjects(handles.FourierSpaceAxes, 'rectangle')  
Shape = handles.ShapePopUp.String(handles.ShapePopUp.Value);
if handles.CenterCheck.Value
    drawShape(Shape,0,0,handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);
else
    eraseObjects(handles.FourierSpaceAxes, 'rectangle')  
    a = handles.ShapeCenter;
    drawShape(Shape,a(1),a(2),handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);
    drawShape(Shape,-a(1),-a(2),handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);

end
   guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function YRadioSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YRadioSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AngleSlide_Callback(hObject, eventdata, handles)
% hObject    handle to AngleSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function AngleSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AngleSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[ax, btn,  Move] = Up();
if handles.MaskFlag 
    if strcmp(btn,'normal')
        Shape = handles.ShapePopUp.String(handles.ShapePopUp.Value);
        drawShape(Shape, ax.CurrentPoint(1),ax.CurrentPoint(4),...
        handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512)
         %La simétrica para que la fft este bien  hecha   
        drawShape(Shape, -ax.CurrentPoint(1),-ax.CurrentPoint(4),...
        handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512)
        
        handles.MaskFlag = 0;
        handles.ShapeCenter = [ax.CurrentPoint(1),ax.CurrentPoint(4)];
    end
end
    
   guidata(hObject,handles)

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrentPoint(); 
%disp('Current');

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Down();
%disp('Down');

% --- Executes on button press in CenterCheck.
function CenterCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CenterCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CenterCheck


% --- Executes on button press in CreateMaskButton.
function CreateMaskButton_Callback(hObject, eventdata, handles)
% hObject    handle to CreateMaskButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.FourierSpaceAxes);
ax = handles.FourierSpaceAxes;
eraseObjects(handles.FourierSpaceAxes, 'rectangle') 
Shape = handles.ShapePopUp.String(handles.ShapePopUp.Value);
if handles.CenterCheck.Value
     
    drawShape(Shape,0,0,handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512);
     handles.MaskFlag = 0;
  
else
    handles.MaskFlag = 1;
    
end

    guidata(hObject,handles);
    
   


% --- Executes on button press in FilterButton.
function FilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to FilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Shape =(handles.ShapePopUp.Value);
if handles.CenterCheck.Value
    disp('oli1')
    Mask = zeros(size(handles.MatrixFFT,1), size(handles.MatrixFFT,2));
    Mask = createMask(Mask, Shape, [0 0], [handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512]...
        , 0, handles.PassCheck.Value);
else 
    disp('oli2')
    Mask0 = zeros(size(handles.MatrixFFT,1), size(handles.MatrixFFT,2));
     
      Mask = createMask(Mask0, Shape, [ handles.ShapeCenter(1)  handles.ShapeCenter(2)], ...
          [handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512], 0, handles.PassCheck.Value);
    
      Mask = Mask + createMask(Mask0, Shape, [- handles.ShapeCenter(1), - handles.ShapeCenter(2)], ...
          [handles.XRadioSlide.Value*512, handles.YRadioSlide.Value*512], 0, handles.PassCheck.Value);
    
      Mask = Mask/2 >0;
       
end
%figure


 %imagesc(-256:256, -256:256,Mask)
 im= findobj(handles.FourierSpaceAxes, 'type', 'image');
 MatrixFFTFilter = Mask.*im.CData;
handles.FourierSpaceAxes.CLim
 MatrixShift = ifftshift(MatrixFFTFilter);
 RSMatrix = ifft2(MatrixFFTFilter);
 RSMatrix = ifftshift(RSMatrix);
 axes(handles.RealSpaceAxes)
 imagesc(abs(RSMatrix))
    axis square
    shading flat
   axes(handles.FourierSpaceAxes) 
    imagesc(-256:256, -256:256,abs(MatrixFFTFilter))
    handles.FourierSpaceAxes.CLim = [50000  100000];
    axis square
    shading flat


% --- Executes on button press in PassCheck.
function PassCheck_Callback(hObject, eventdata, handles)
% hObject    handle to PassCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PassCheck


% --- Executes on button press in RestartPush.
function RestartPush_Callback(hObject, eventdata, handles)
% hObject    handle to RestartPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.RealSpaceAxes);
Matriz =handles.Matriz;
imagesc(Matriz)
axis square
shading flat
%FFT
axes(handles.FourierSpaceAxes);
MatrixFFT = fft2df(Matriz);
imagesc(-256:256, -256:256,abs(MatrixFFT))
handles.FourierSpaceAxes.CLim = [50000 100000];