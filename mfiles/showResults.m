function varargout = showResults(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @showResults_OpeningFcn, ...
    'gui_OutputFcn',  @showResults_OutputFcn, ...
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

function showResults_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

guidata(hObject, handles);

function varargout = showResults_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)

clc;
set(groot,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 0.5, 0],...
    'defaultAxesLineStyleOrder','-|--|:')

switch get(get(handles.buttongroupCodec,'SelectedObject'),'Tag') % radiobuttons
    case 'rbCodecMp2',  codecNum = 1; profile = 'mp2'; subScore = [1,9]; subBitrate = [128,96];
    case 'rbCodecLc',   codecNum = 2; profile = 'lc'; subScore = [8]; subBitrate = [64];
    case 'rbCodecHe',   codecNum = 3; profile = 'he'; subScore = [5,7]; subBitrate = [48,64];
    case 'rbCodecHev2', codecNum = 4; profile = 'hev2'; subScore = [3,6,15]; subBitrate = [32,48,64];
    case 'rbCodecOpus', codecNum = 5; profile = 'opus'; subScore = [2,4,10]; subBitrate = [24,32,12];
end

switch get(get(handles.buttongroupMethod,'SelectedObject'),'Tag')
    case 'rbMethodEaqual',  methodNum = 1; method = 'eaqual';
    case 'rbMethodPeaq',    methodNum = 2; method = 'peaq';
    case 'rbMethodPemoq',   methodNum = 3; method = 'pemoq';
    case 'rbMethodVisqol',  methodNum = 4; method = 'visqol';
end

set(handles.exportPlotButton,'UserData',[method,' ',profile]); % memory for a title

load('objectiveResults.mat','objectiveResults');
load('dataOut1.mat','dataOut');
listTestResults = dataOut;
load('dataOut2.mat','dataOut');
listTestResults = ([listTestResults,dataOut]/25)-4; % from percents to ODG
listTestResults(1,2) = (listTestResults(1,2)+listTestResults(1,13))/2; %average of opus @ 24
listTestResults(1,6) = (listTestResults(1,6)+listTestResults(1,14))/2; %average of hev2 @ 48

odg = cell2mat(objectiveResults{methodNum}(codecNum));


if(isempty(odg))
    display('Not measured!');
end

axes(handles.axes1)

if strcmp(profile,'lc')
    bitrate = 12:4:256;
    name = 'AAC_LC';
elseif strcmp(profile,'he')
    bitrate = 16:4:128;
    name = 'HE_AAC_v1';
elseif strcmp(profile,'hev2')
    bitrate = 12:4:64;
    name = 'HE_AAC_v2';
elseif strcmp(profile,'mp2')
    bitrate = [56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384];
    name = 'MPEG_Layer_II';
elseif strcmp(profile,'opus')
    bitrate = 8:4:128;
    name = 'opus';
else
    disp('wrong profile')
end

switch get(get(handles.buttonGroupDisplayAllMean,'SelectedObject'),'Tag')
    case 'rbDisplayAll'
        
        plot(bitrate,odg(get(handles.pushbutton2,'UserData'),:))
        legendEntry = {'capriccio.wav','cimrman.wav','dubstep.wav','holmes.wav','pennylane.wav','refglo.wav','refpia.wav','refsax.wav','refveg.wav','rickroll.wav '};
        legend(handles.axes1,legendEntry(get(handles.pushbutton2,'UserData')),'Location','southeast')
        
    case 'rbDisplayMean'
        
        plot(bitrate,mean(odg(get(handles.pushbutton2,'UserData'),:)))
        legend(handles.axes1,'mean value of chosen samples','Location','southeast')
        %
        
end
hold on

% plot(subBitrate, listTestResults(1,subScore),'Xk')



if strcmp(method,'visqol')
    ylim(handles.axes1,[0.5,5])
    ylabel(handles.axes1,'MOS-LQO')
    listTestResults(1,:) = listTestResults(1,:)+5;%ODG to MOS
else
    ylim(handles.axes1,[-4,0.5])
end

if get(handles.cbSubjective,'Value')
    
    errorbar(subBitrate,listTestResults(1,subScore),listTestResults(2,subScore)/25,'k*','LineWidth',1); % results of subjective tests
    
end

xlabel(handles.axes1,'bitrate')
ylabel(handles.axes1,'ODG')

hold off

grid(handles.axes1, 'on')
set(groot,'defaultAxesLineStyleOrder','remove')
set(groot,'defaultAxesColorOrder','remove')


function pushbutton2_Callback(hObject, eventdata, handles)

a = chooseDialog(get(handles.pushbutton2,'UserData'));
set(handles.pushbutton2,'UserData',a)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);

function rbCodecMp2_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbCodecLc_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbCodecHe_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbCodecHev2_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbCodecOpus_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbMethodPeaq_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbMethodEaqual_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbMethodPemoq_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbMethodVisqol_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbDisplayAll_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function rbDisplayMean_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);

function figure1_ButtonDownFcn(hObject, eventdata, handles)


function exportPlotButton_Callback(hObject, eventdata, handles)
filter = {'*.svg';'*.png';'*.jpg';'*.bmp'};
[file,path] = uiputfile(filter,'Save plot');

fignew = figure('Visible','off'); % Invisible figure
newAxes = copyobj(handles.axes1,fignew); % Copy the appropriate axes
set(newAxes,'Units','Normalized','Position',get(groot,'DefaultAxesPosition')); % The original position is copied too, so adjust it.
set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading
titleName = get(handles.exportPlotButton,'UserData');
title(newAxes,titleName);
% savefig(fignew,'test.fig');
saveas(gcf,[path,file])
delete(fignew);


function cbSubjective_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);
