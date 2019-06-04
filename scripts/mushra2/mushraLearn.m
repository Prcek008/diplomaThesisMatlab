function varargout = mushraLearn(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mushraLearn_OpeningFcn, ...
    'gui_OutputFcn',  @mushraLearn_OutputFcn, ...
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

function mushraLearn_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


fid = fopen('learn.txt');
text = fscanf(fid, '%c', Inf);
fclose(fid);
set(handles.grayBox,'String',text);

guidata(hObject, handles);

try
    data = varargin{1};
    data.saved = data;
end

data.currentScenario = 1;
data.currentFolder = [pwd,'\learn\',num2str(1),'\'];

try
    delete([data.currentFolder,'desktop.ini'])
end
currentScenario = 1;
data.isPlaying = 0;
data.lastPressed = [];
data.player = [];
tmp = dir(data.currentFolder);
tmp = {tmp.name};
data.samples = tmp(3:end);
data.quality(currentScenario,:) = zeros(1,length(data.samples)-1);
set(handles.textHeader,'String',cellstr('Zauèení'));
set(handles.memory,'UserData',data);

function varargout = mushraLearn_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

function playStop(name,handles)
data = get(handles.memory,'UserData');

if data.lastPressed ~= name
    data.isPlaying = 0;
end
data.lastPressed = name;
if data.isPlaying
    stop(data.player);
    data.isPlaying = 0;
else

    fileName = [data.currentFolder,char(data.samples(name))];
    data.fileName = fileName;
    [y, Fs] = audioread(data.fileName);
    positionStart = int64(get(handles.sliderStart,'Value')*floor(1+length(y))+1);
    positionEnd = int64(get(handles.sliderEnd,'Value')*floor(1+length(y))-1);
    y = y(positionStart:positionEnd,:);
    [a,~] = size(y);
    if a > 0
        data.player = audioplayer(y, Fs);
        play(data.player);
        data.isPlaying = 1;
    end
    
end
set(handles.memory,'UserData',data)



function buttonSampleRef_Callback(hObject, eventdata, handles)
playStop(1,handles)


function buttonSampleA_Callback(hObject, eventdata, handles)
playStop(2,handles)


function buttonSampleB_Callback(hObject, eventdata, handles)
playStop(3,handles)


function buttonSampleC_Callback(hObject, eventdata, handles)
playStop(4,handles)

function buttonSampleD_Callback(hObject, eventdata, handles)
playStop(5,handles)


function buttonSampleE_Callback(hObject, eventdata, handles)
playStop(6,handles)


function sliderSampleB_Callback(hObject, eventdata, handles)
data = get(handles.memory,'UserData');
data.quality(data.currentScenario,2) = get(hObject,'Value');
set(handles.valueSampleB,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleB_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleA_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,1) = get(hObject,'Value');
set(handles.valueSampleA,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleA_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleC_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,3) = get(hObject,'Value');
set(handles.valueSampleC,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleC_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleE_Callback(hObject, eventdata, handles)
data = get(handles.memory,'UserData');
data.quality(data.currentScenario,5) = get(hObject,'Value');
set(handles.valueSampleE,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleE_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleD_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,4) = get(hObject,'Value');
set(handles.valueSampleD,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleD_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function buttonNext_Callback(hObject, eventdata, handles)
data = get(handles.memory,'UserData');
if my_closereq
    close(gcf)
    mushraMain(data.saved);
end


function textHeader_ButtonDownFcn(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
% set(handles.textHeader,'String',data.scenarios(data.currentScenario));
display(data);

function textHeader_CreateFcn(hObject, eventdata, handles)


function sliderStart_Callback(hObject, eventdata, handles)
if get(hObject,'Value') > get(handles.sliderEnd,'Value')
    set(handles.sliderEnd,'Value',get(hObject,'Value'));
end


function sliderStart_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderEnd_Callback(hObject, eventdata, handles)
if get(hObject,'Value') < get(handles.sliderStart,'Value')
    set(handles.sliderStart,'Value',get(hObject,'Value'));
end


function sliderEnd_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function bool = my_closereq
selection = questdlg('Jste si jistí, že chcete pøejít k ostré èásti testu?',...
    'Potvrzení',...
    'Ano','Ne','Ano');
switch selection,
    case 'Ano',
        bool = 1;
    case 'Ne'
        bool = 0;
end



function buttonNext_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function buttonSampleE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonSampleE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function slider14_Callback(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider13_Callback(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
