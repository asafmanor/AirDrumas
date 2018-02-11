function varargout = Gal(varargin)
% GAL MATLAB code for Gal.fig
%      GAL, by itself, creates a new GAL or raises the existing
%      singleton*.
%
%      H = GAL returns the handle to a new GAL or the handle to
%      the existing singleton*.
%
%      GAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAL.M with the given input arguments.
%
%      GAL('Property','Value',...) creates a new GAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gal

% Last Modified by GUIDE v2.5 11-Feb-2018 14:39:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gal_OpeningFcn, ...
                   'gui_OutputFcn',  @Gal_OutputFcn, ...
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


% --- Executes just before Gal is made visible.
function Gal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gal (see VARARGIN)

%dataset 1
handles.peaks = peaks(35);

%dataset 2
handles.membrane = membrane;

%dataset 3
[x,y] = meshgrid(-5:.5:8);
r = sqrt(x.^2 + y.^2) + eps;
sinc = sin(r)./r;
handles.sinc = sinc;

handles.currentData = handles.peaks;
surf(handles.currentData);

% Choose default command line output for Gal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popUpMenu.
function popUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to popUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');

switch str{val}
    case 'peaks'
        handles.currentData = handles.peaks;    
    case 'membrane'
        handles.currentData = handles.membrane;
    case 'sinc'
        handles.currentData = handles.sinc;
end

% Update handles structure
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popUpMenu


% --- Executes during object creation, after setting all properties.
function popUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Surf_pushButtom.
function Surf_pushButtom_Callback(hObject, eventdata, handles)
% hObject    handle to Surf_pushButtom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
surf(handles.currentData);


% --- Executes on button press in Mesh_pushButton.
function Mesh_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Mesh_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mesh(handles.currentData);


% --- Executes on button press in Contour_pushButton.
function Contour_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Contour_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contour(handles.currentData);
