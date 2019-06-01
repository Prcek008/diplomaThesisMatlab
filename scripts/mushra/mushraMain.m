function varargout = mushraMain(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mushraMain_OpeningFcn, ...
    'gui_OutputFcn',  @mushraMain_OutputFcn, ...
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

function mushraMain_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

try
    data = varargin{1};
end

% % data.scenarios = 'text';
% data.currentScenario = 1;
currentScenario = data.currentScenario;
data.currentFolder = [pwd,'\scenarios\',num2str(currentScenario),'\'];

try
    delete([data.currentFolder,'desktop.ini'])
end

data.isPlaying = 0;
data.lastPressed = [];
data.player = [];
tmp = dir(data.currentFolder);
tmp = {tmp.name};
data.samples = tmp(3:end);
data = randomize(data);
data.quality(currentScenario,:) = zeros(1,length(data.samples)-1);
set(handles.textHeader,'String',cellstr(['Vzorek ',num2str(currentScenario),'/',num2str(length(data.scenarios)),': ',char(data.scenarios(data.currentScenario))]));

disableSliders(data,handles);

set(handles.memory,'UserData',data);

function data = randomize(data)
data.randomOrder = randperm(length(data.samples)-1);
data.randomSampleOrder = [1,data.randomOrder+1];
data.samples = data.samples(data.randomSampleOrder);

function quality = unrandomize(quality,handles)
data = get(handles.memory,'UserData');
quality(data.randomOrder) = quality;

function varargout = mushraMain_OutputFcn(hObject, eventdata, handles)

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
    %     set(handles.textHeader,'String',char(data.samples(name)));
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

function data = samplePlayer(data,position)



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


function buttonSampleF_Callback(hObject, eventdata, handles)
playStop(7,handles)


function buttonSampleG_Callback(hObject, eventdata, handles)
playStop(8,handles)


function buttonSampleH_Callback(hObject, eventdata, handles)
playStop(9,handles)


function buttonSampleI_Callback(hObject, eventdata, handles)
playStop(10,handles)


function buttonSampleJ_Callback(hObject, eventdata, handles)
playStop(11,handles)


function buttonSampleK_Callback(hObject, eventdata, handles)
playStop(12,handles)


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


function sliderSampleF_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,6) = get(hObject,'Value');
set(handles.valueSampleF,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleF_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleG_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,7) = get(hObject,'Value');
set(handles.valueSampleG,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleG_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleH_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,8) = get(hObject,'Value');
set(handles.valueSampleH,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleH_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleI_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,9) = get(hObject,'Value');
set(handles.valueSampleI,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleI_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliderSampleJ_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,10) = get(hObject,'Value');
set(handles.valueSampleJ,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);


function sliderSampleJ_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sliderSampleK_Callback(hObject, eventdata, handles)
data = get(handles.memory,'UserData');
data.quality(data.currentScenario,11) = get(hObject,'Value');
set(handles.valueSampleK,'String',num2str(round(get(hObject,'Value'))))
set(handles.memory,'UserData',data);

function sliderSampleK_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function disableSliders(data,handles)


if length(data.samples) <= 10
    set(handles.sliderSampleJ,'visible','off')
    set(handles.buttonSampleJ,'visible','off')
    set(handles.valueSampleJ,'visible','off')
end

if length(data.samples) <= 11
    set(handles.sliderSampleK,'visible','off')
    set(handles.buttonSampleK,'visible','off')
    set(handles.valueSampleK,'visible','off')
end


function butonNext_Callback(hObject, eventdata, handles)

data = get(handles.memory,'UserData');
data.quality(data.currentScenario,:) = unrandomize(data.quality(data.currentScenario,:),handles);
numOfScenarios = size(data.scenarios);

if my_closereq

if data.currentScenario == numOfScenarios(2)
    close(gcf)
    msgbox('Konec')
    saveData(data);
else
    data.currentScenario = data.currentScenario + 1;
    close(gcf)
    mushraMain(data);
end

end

function saveData(data)

fileName = [pwd,'\results\',num2str(datenum(datetime)),'_',data.name,'.mat'];
dataToSave.name = data.name;
dataToSave.age = data.age;
dataToSave.quality = data.quality;
save(fileName,'dataToSave');


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
selection = questdlg('Jste si jistí, že chcete pokraèovat k další èásti testu?',...
    'Potvrzení',...
    'Ano','Ne','Ano');
switch selection,
    case 'Ano',
        bool = 1;
    case 'Ne'
        bool = 0;
end
