function varargout = mushraStart(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mushraStart_OpeningFcn, ...
                   'gui_OutputFcn',  @mushraStart_OutputFcn, ...
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

function mushraStart_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

fid = fopen('info.txt');
text = fscanf(fid, '%c', Inf);
fclose(fid);
set(handles.textInfo,'String',text);

function varargout = mushraStart_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function textAge_Callback(hObject, eventdata, handles)

function textAge_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function textName_Callback(hObject, eventdata, handles)

function textName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function buttonStart_Callback(~, eventdata, handles)

fid = fopen('scenarios.txt');
text = strsplit(fscanf(fid, '%c', Inf),'\n');
fclose(fid);

data.scenarios = text;
data.currentScenario = 1;
data.name = get(handles.textName,'String');
data.age = get(handles.textAge,'String');
mushraLearn(data);
close(mushraStart);

function textInfo_CreateFcn(hObject, eventdata, handles)

function textName_ButtonDownFcn(hObject, eventdata, handles)

set(handles.textName,'String','');

function textAge_ButtonDownFcn(hObject, eventdata, handles)

set(handles.textAge,'String','');
