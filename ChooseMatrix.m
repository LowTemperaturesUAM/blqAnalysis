function varargout = ChooseMatrix(varargin)
% CHOOSEMATRIX MATLAB code for ChooseMatrix.fig
%      CHOOSEMATRIX, by itself, creates a new CHOOSEMATRIX or raises the existing
%      singleton*.
%
%      H = CHOOSEMATRIX returns the handle to a new CHOOSEMATRIX or the handle to
%      the existing singleton*.
%
%      CHOOSEMATRIX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOOSEMATRIX.M with the given input arguments.
%
%      CHOOSEMATRIX('Property','Value',...) creates a new CHOOSEMATRIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChooseMatrix_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChooseMatrix_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChooseMatrix

% Last Modified by GUIDE v2.5 10-May-2017 00:10:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChooseMatrix_OpeningFcn, ...
                   'gui_OutputFcn',  @ChooseMatrix_OutputFcn, ...
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


% --- Executes just before ChooseMatrix is made visible.
function ChooseMatrix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChooseMatrix (see VARARGIN)

% Choose default command line output for ChooseMatrix
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChooseMatrix wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ChooseMatrix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CheckIdaIda.
function CheckIdaIda_Callback(hObject, eventdata, handles)
% hObject    handle to CheckIdaIda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckIdaIda
eleccionMatrices = [handles.CheckIdaIda.Value, handles.CheckIdaVuelta.Value, handles.CheckVueltaIda.Value, handles.CheckVueltaVuelta.Value];

% --- Executes on button press in CheckVueltaIda.
function CheckVueltaIda_Callback(hObject, eventdata, handles)
% hObject    handle to CheckVueltaIda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckVueltaIda
eleccionMatrices = [handles.CheckIdaIda.Value, handles.CheckIdaVuelta.Value, handles.CheckVueltaIda.Value, handles.CheckVueltaVuelta.Value];

% --- Executes on button press in CheckIdaVuelta.
function CheckIdaVuelta_Callback(hObject, eventdata, handles)
% hObject    handle to CheckIdaVuelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckIdaVuelta
eleccionMatrices = [handles.CheckIdaIda.Value, handles.CheckIdaVuelta.Value, handles.CheckVueltaIda.Value, handles.CheckVueltaVuelta.Value];

% --- Executes on button press in CheckVueltaVuelta.
function CheckVueltaVuelta_Callback(hObject, eventdata, handles)
% hObject    handle to CheckVueltaVuelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckVueltaVuelta
handles.figure1.UserData
eleccionMatrices = [handles.CheckIdaIda.Value, handles.CheckIdaVuelta.Value, handles.CheckVueltaIda.Value, handles.CheckVueltaVuelta.Value];

% --- Executes on button press in PushContinue.
function PushContinue_Callback(hObject, eventdata, handles)
% hObject    handle to PushContinue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%With this, it is possible to save in the UserData property of the
%OpenFIleButton of the other GUI the matrix selected.
h = findobj( 'tag', 'LoadBlq'); %Busco el objeto OpenFileBtn del programa IVAnalysis
h.UserData = [handles.CheckIdaIda.Value, handles.CheckIdaVuelta.Value, handles.CheckVueltaIda.Value, handles.CheckVueltaVuelta.Value];
%Guardo en el apartado UserData del boton los datos que necesito
close %Cierro la ventana
