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
    case 'rbCodecXhe', codecNum = 6; profile = 'xhe'; subScore = [12,16]; subBitrate = [12,8]; % xhe
end

switch get(get(handles.buttongroupMethod,'SelectedObject'),'Tag')
    case 'rbMethodEaqual',  methodNum = 1; method = 'Advanced';
    case 'rbMethodPeaq',    methodNum = 2; method = 'Basic';
    case 'rbMethodPemoq',   methodNum = 3; method = 'Pemoq';
    case 'rbMethodVisqol',  methodNum = 4; method = 'Visqol';
end

set(handles.exportPlotButton,'UserData',[method,' ',profile]); % memory for a title

load('objectiveResults.mat','objectiveResults');
load('dataOut1.mat','dataOut')
listTestResults = dataOut;
load('dataOut2.mat','dataOut');
listTestResults = ([listTestResults,dataOut]/25); % from percents to ODG
listTestResults(1,:) = listTestResults(1,:)-4;
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
    name = 'Opus';
elseif strcmp(profile,'xhe')
    bitrate = 8:4:12;
    name = 'xHE AAC';
else
    disp('wrong profile')
end

if strcmp(profile,'xhe')
    temp = get(handles.pushbutton2,'UserData');
    set(handles.pushbutton2,'UserData',[8 9 10])
end

switch get(get(handles.buttonGroupDisplayAllMean,'SelectedObject'),'Tag')
    case 'rbDisplayAll'
        
        h1 = plot(bitrate,odg(get(handles.pushbutton2,'UserData'),:));
        legendEntry = {'capriccio.wav' 'cimrman.wav' 'dubstep.wav' 'freq3.wav' 'holmes.wav' 'pennylane.wav' 'refveg.wav' 'xhedemomixed.wav' 'xhedemomusic.wav' 'xhedemospeech.wav'};
        legend(handles.axes1,legendEntry(get(handles.pushbutton2,'UserData')),'Location','best')
        
    case 'rbDisplayMean'

        x = bitrate;
        y = mean(odg(get(handles.pushbutton2,'UserData'),:));
        e = std(odg(get(handles.pushbutton2,'UserData'),:));
        h1 = plot(x,y);
        hold on
        h2 = errorbar(x,y,e,'rx');        
        hold off
        legendEntry = {'Average of chosen s.'};
        legend(legendEntry,'Location','best');
end
hold on

% plot(subBitrate, listTestResults(1,subScore),'Xk')

if strcmp(method,'Visqol')
    ylim(handles.axes1,[1,5.5])
    ylabel(handles.axes1,'MOS-LQO')
    listTestResults(1,:) = listTestResults(1,:)+5;%ODG to MOS
else
    ylim(handles.axes1,[-4,0.5])
    ylabel(handles.axes1,'ODG')
end

if get(handles.cbSubjective,'Value')
    
    h2 = errorbar(subBitrate,listTestResults(1,subScore),listTestResults(2,subScore),'k*','LineWidth',1); % results of subjective tests
    pressed = get(handles.pushbutton2,'UserData');
    legend([h1',h2'],{legendEntry{pressed},'Subjective results'},'Location','best')
end

if strcmp(profile,'xhe')
    xlim([6,14])
end
xlabel(handles.axes1,'bitrate')

hold off

grid(handles.axes1, 'on')

data.legend = legend;
data.fileName = [pwd,'\objective\',profile,method,'.pdf'];

set(handles.data,'UserData',data)
set(groot,'defaultAxesLineStyleOrder','remove')
set(groot,'defaultAxesColorOrder','remove')
if strcmp(profile,'xhe')
set(handles.pushbutton2,'UserData',temp)
end

if get(handles.cbFixedBitrate,'Value')
    xlim([8,384])
end



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

data = get(handles.data,'UserData')
leg = data.legend;
fileName = data.fileName;
filter = {'*.pdf';'*.png';'*.jpg';'*.bmp'};
[file,path] = uiputfile(filter,'Save plot');

fignew = figure('Visible','off'); % Invisible figure
newAxes = copyobj(handles.axes1,fignew); % Copy the appropriate axes
set(newAxes,'Units','Normalized','Position',get(groot,'DefaultAxesPosition')); % The original position is copied too, so adjust it.


legend({'Avg of chosen s.','Standard deviation','Subjective tests results'},'Location','Best','FontSize',12)
set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading
titleName = get(handles.exportPlotButton,'UserData');
% title(newAxes,titleName);


width=800;
height=600;
paperwidth = 20;
paperheight = paperwidth * height/width;
x0=50;
y0=50;
set(gcf,'position',[x0,y0,width,height])
set(gcf, 'PaperPosition', [0 0 paperwidth paperheight]);
set(gcf, 'PaperSize', [paperwidth paperheight]);
% saveas(gcf,fileName)
saveas(gcf,[path,file])
delete(fignew);


function cbSubjective_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);
warndlg('Subjective tests were conducted only on samples: capriccio, holmes, pennylane, refveg, xhedemomixed, xhedemomusic, xhedemospeech. Displaying them doesn''t respect used choise of samples!')


% --- Executes on button press in rbCodecXhe.
function rbCodecXhe_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);


% --- Executes on button press in cbFixedBitrate.
function cbFixedBitrate_Callback(hObject, eventdata, handles)
pushbutton1_Callback(handles.pushbutton1, eventdata,handles);
