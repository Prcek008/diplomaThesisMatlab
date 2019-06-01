function varargout = chooseDialog(varargin)
% CHOOSEDIALOG MATLAB code for chooseDialog.fig
%      CHOOSEDIALOG, by itself, creates a new CHOOSEDIALOG or raises the existing
%      singleton*.
%
%      H = CHOOSEDIALOG returns the handle to a new CHOOSEDIALOG or the handle to
%      the existing singleton*.
%
%      CHOOSEDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOOSEDIALOG.M with the given input arguments.
%
%      CHOOSEDIALOG('Property','Value',...) creates a new CHOOSEDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chooseDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chooseDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chooseDialog

% Last Modified by GUIDE v2.5 12-Feb-2019 15:09:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @chooseDialog_OpeningFcn, ...
    'gui_OutputFcn',  @chooseDialog_OutputFcn, ...
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


% --- Executes just before chooseDialog is made visible.
function chooseDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chooseDialog (see VARARGIN)

% Choose default command line output for chooseDialog
% handles.output = [];



updateData(varargin{1},handles);

initData(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chooseDialog wait for user response (see UIRESUME)
uiwait(handles.figure1);

function initData(handles)
a = get(handles.button1,'UserData');
set(handles.cb1,'Value',a(1));
set(handles.cb2,'Value',a(2));
set(handles.cb3,'Value',a(3));
set(handles.cb4,'Value',a(4));
set(handles.cb5,'Value',a(5));
set(handles.cb6,'Value',a(6));
set(handles.cb7,'Value',a(7));
set(handles.cb8,'Value',a(8));
set(handles.cb9,'Value',a(9));
set(handles.cb10,'Value',a(10));


% --- Outputs from this function are returned to the command line.
function varargout = chooseDialog_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
a = 1:10;
a = a .* (get(handles.button1,'UserData'));
varargout{1} = a(a~=0);
% The figure can be deleted now
delete(handles.figure1);


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;



% --- Executes on button press in cb1.
function cb1_Callback(hObject, eventdata, handles)
% hObject    handle to cb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(1,handles)
% Hint: get(hObject,'Value') returns toggle state of cb1

function updateData(num,handles)

a = get(handles.button1,'UserData');
a(num) = not(a(num));
set(handles.button1,'UserData',a)


% --- Executes on button press in cb3.
function cb3_Callback(hObject, eventdata, handles)
% hObject    handle to cb3 (see GCBO)y
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(3,handles)
% Hint: get(hObject,'Value') returns toggle state of cb3


% --- Executes on button press in cb4.
function cb4_Callback(hObject, eventdata, handles)
% hObject    handle to cb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(4,handles)
% Hint: get(hObject,'Value') returns toggle state of cb4


% --- Executes on button press in cb5.
function cb5_Callback(hObject, eventdata, handles)
% hObject    handle to cb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(5,handles)
% Hint: get(hObject,'Value') returns toggle state of cb5


% --- Executes on button press in cb2.
function cb2_Callback(hObject, eventdata, handles)
% hObject    handle to cb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(2,handles)
% Hint: get(hObject,'Value') returns toggle state of cb2


% --- Executes on button press in cb6.
function cb6_Callback(hObject, eventdata, handles)
% hObject    handle to cb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(6,handles)
% Hint: get(hObject,'Value') returns toggle state of cb6


% --- Executes on button press in cb8.
function cb8_Callback(hObject, eventdata, handles)
% hObject    handle to cb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(8,handles)
% Hint: get(hObject,'Value') returns toggle state of cb8


% --- Executes on button press in cb9.
function cb9_Callback(hObject, eventdata, handles)
% hObject    handle to cb9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(9,handles)
% Hint: get(hObject,'Value') returns toggle state of cb9


% --- Executes on button press in cb10.
function cb10_Callback(hObject, eventdata, handles)
% hObject    handle to cb10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(10,handles)
% Hint: get(hObject,'Value') returns toggle state of cb10


% --- Executes on button press in cb7.
function cb7_Callback(hObject, eventdata, handles)
% hObject    handle to cb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateData(7,handles)
% Hint: get(hObject,'Value') returns toggle state of cb7


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
