function varargout = ImageCapture(varargin)
% IMAGECAPTURE M-file for ImageCapture.fig
%      IMAGECAPTURE, by itself, creates a new IMAGECAPTURE or raises the existing
%      singleton*.
%
%      H = IMAGECAPTURE returns the handle to a new IMAGECAPTURE or the handle to
%      the existing singleton*.
%
%      IMAGECAPTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGECAPTURE.M with the given input arguments.
%
%      IMAGECAPTURE('Property','Value',...) creates a new IMAGECAPTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageCapture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageCapture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageCapture
% 
% Last Modified by GUIDE v2.5 29-Oct-2020 15:53:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ImageCapture_OpeningFcn, ...
    'gui_OutputFcn',  @ImageCapture_OutputFcn, ...
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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ImageCapture_OpeningFcn(hObject, eventdata, handles, varargin)

addpath(fullfile(pwd, 'utils'));

fileName = fullfile(pwd, 'previousSettings.mat');
if exist(fileName,'file')==2
    load(fileName, 'expoSettings','fluidTimeSettings', 'flowRateSettings');
    handles.sbexpo = expoSettings(1);
    handles.sgexpo = expoSettings(2);
    handles.srexpo = expoSettings(3);
    handles.sirexpo = expoSettings(4);
    
    handles.washTime = fluidTimeSettings(1);
    handles.hybridTime = fluidTimeSettings(2);
    handles.imgTime = fluidTimeSettings(3);
    handles.cleavageTime = fluidTimeSettings(4);
    
    handles.washFr = flowRateSettings(1);
    handles.hybridFr = flowRateSettings(2);
    handles.imgFr = flowRateSettings(3);
    handles.cleavageFr = flowRateSettings(4);
else
    disp('Failed to load previous run settings!')
    handles.sbexpo = 0.05;
    handles.sgexpo = 0.5;
    handles.srexpo = 1;
    handles.sirexpo = 2;
    
    handles.washTime = 300;
    handles.hybridTime = 360;
    handles.cleavageTime = 420;
    handles.imgTime = 100;
    
    handles.washFr = 0;
    handles.hybridFr = 0;
    handles.imgFr = 0;
    handles.cleavageFr = 0;
    
end

% Choose default command line output for ImageCapture
handles.stage_calibration = 0;
handles.Zlimit = 382000;
res = get(0,'screensize');
handles.resX = res(3);
handles.resY = res(4);
clear res

handles.blue_check = 0;
handles.green_check = 0;
handles.red_check = 0;
handles.ir_check = 0;

handles.ETupper= [0.5 0.5 2 3];
handles.ETlower = [0.01 0.01 0.5 1.5];

handles.threeDstepSize = 0;
handles.planeNum = 1;
handles.des_FM = 0;


handles.output = hObject;
handles.List = [];

handles.microscope = 'None';
handles.filter = 'None';
handles.stage = 'None';
handles.light = 'None';
handles.camera = 'None';

handles.hist = get(handles.histogram_checkbox, 'Value');

%set(handles.figure1, 'Position', [(resX/2)-(682/2) (resY/2)-(613/2) 682 613])
%set(handles.figure1, 'Position', [0 0 700 700])


loading = figure('Position',[(handles.resX/2)-(200/2) (handles.resY/2)-(80/2),200,80],'Color',[0.9204,0.9087,0.8424],'MenuBar','none');
uicontrol('Style','text','String','Connecting...','Position',[20,40,100,25]);
movegui(loading,'center');


handles.height = 2160;
handles.width = 2560;
handles.FOV_width = [0 831 276];
handles.FOV_height = [0 702 233];
handles.FOVx = handles.FOV_width(3);
handles.FOVy = handles.FOV_height(3);
handles.umPERpixel = round(handles.FOVx/handles.width,3);
handles.scale = round(200*handles.umPERpixel);


set(handles.text93,'Visible','Off');
set(handles.hybrid_round_edit,'Visible','Off');
set(handles.text95,'Visible','Off');
set(handles.hybridization_fluid_edit,'Visible','Off');
set(handles.threeD_pushbutton,'Visible','Off');

handles.isBlueOn = false;
handles.isGreenOn = false;
handles.isRedOn = false;
handles.isIROn = false;

handles.hybridization_rounds = 1;
handles.hybridization_fluid = 0;
handles.startRun = 1;

set(handles.startFromEdit,'String',num2str(handles.startRun));

delete(loading);

% Update handles structure
guidata(hObject, handles);
end


function varargout = ImageCapture_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
end


function figure1_CloseRequestFcn(hObject, eventdata, handles)
expoSettings = [handles.sbexpo, handles.sgexpo, handles.srexpo, handles.sirexpo];
fluidTimeSettings = [handles.washTime, handles.hybridTime, handles.imgTime, handles.cleavageTime];
flowRateSettings = [handles.washFr, handles.hybridFr, handles.imgFr, handles.cleavageFr];
bp = str2double(get(handles.blue_edit,'String'));
gp = str2double(get(handles.green_edit,'String'));
rp = str2double(get(handles.red_edit,'String'));
irp = str2double(get(handles.ir_edit,'String'));
powerSettings = [bp, gp, rp, irp];

fileName = fullfile(pwd, 'previousSettings.mat');
save(fileName, 'expoSettings', 'fluidTimeSettings', 'flowRateSettings', 'powerSettings');

% clean up before closing
% close microscope
if isfield(handles,'ti2')
    try
        Disconnect(handles.ti2);
    catch
        'Error in closing the microscope!'
    end
end

%clean up and shut down laser
if isfield(handles,'sblue')
    try
        fprintf(handles.sblue,'?LOf')
        fclose(handles.sblue);
        delete(handles.sblue);
    catch
        'Error closing blue laser serial port!'
    end
end
if isfield(handles,'sgreen')
    try
        fprintf(handles.sgreen,'l0')
        fclose(handles.sgreen);
        delete(handles.sgreen);
    catch
        'Error closing green laser serial port!'
    end
end
if isfield(handles,'sred')
    try
        fprintf(handles.sir,'?LOf')
        fclose(handles.sred);
        delete(handles.sred);
    catch
        'Error closing red laser serial port!'
    end
end
if isfield(handles,'sir')
    try
        fprintf(handles.sir,'?LOf')
        fclose(handles.sir);
        delete(handles.sir);
    catch
        'Error closing IR laser serial port!'
    end
end

% clean up before closing stage
if isfield(handles,'s2')
    s2 = handles.s2;
    handles = rmfield(handles,'s2');
    try
        fclose(s2)
        delete(s2)
    catch
        'Error in closing the stage serial port!'
    end
end

if isfield(handles,'MVP')
    try
        fclose(handles.MVP);
        delete(handles.MVP);
    catch
        'Error closing MVP'
    end
end

if isfield(handles,'MVP2')
    try
        fclose(handles.MVP2);
        delete(handles.MVP2);
    catch
        'Error closing MVP2'
    end
end

if isfield(handles,'MVP3')
    try
        
        fclose(handles.MVP3);
        delete(handles.MVP3);
    catch
        'Error closing MVP3'
    end
end
    
try
    [rc_close] = AT_Close(handles.AndorNeoParamHandle);
    [rc_finalize] = AT_FinaliseLibrary();
catch
%     'Error in closing the Camera'
end

if(~isempty(instrfind))
    fclose(instrfind);
    delete(instrfind);
end

delete(hObject);
end


%%% system parameters %%%
function lampvoltage_text_CreateFcn(hObject, eventdata, handles)
end


function lampvoltage_edit_Callback(hObject, eventdata, handles)
Lamp = get(handles.lampvoltage_edit,'string');
set(handles.ti2,'iDIA_LAMP_Pos', str2double(Lamp))
end


function lampvoltage_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function zpos_edit_Callback(hObject, eventdata, handles)
set(handles.ti2,'iZLimit',342000)
zpos = str2double(get(handles.zpos_edit,'string'));
set(handles.ti2,'iZPOSITION', zpos)
end


function zpos_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function nosepiece_popupmenu_Callback(hObject, eventdata, handles)
nose = get(handles.nosepiece_popupmenu,'Value');
set(handles.ti2,'iNOSEPIECE',nose);
switch nose
    case 1
        set(handles.ti2,'iDIA_LAMP_Pos',30);
    case 2
        set(handles.ti2,'iDIA_LAMP_Pos',50);
    case 3
        set(handles.ti2,'iDIA_LAMP_Pos',120);
end
        
handles.FOVx = handles.FOV_width(nose);
handles.FOVy = handles.FOV_height(nose);
handles.umPERpixel = round(handles.FOVx/handles.width,3);
handles.scale = round(200*handles.umPERpixel);
guidata(hObject, handles);
end


function nosepiece_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function escape_pushbutton_Callback(hObject, eventdata, handles)
if get(handles.ti2,'iZEscape') == 0
    status = 1;
else
    status = 0;
end
set(handles.ti2,'iZEscape',status);
end


function microscoperefresh_pushbutton_Callback(hObject, eventdata, handles)
lamp = get(handles.ti2, 'iDIA_LAMP_POS');
set(handles.lampvoltage_edit, 'String', num2str(lamp))

zpos = get(handles.ti2, 'iZPOSITION');
set(handles.zpos_edit, 'String', num2str(zpos))

nosEpos = get(handles.ti2, 'iNOSEPIECE');
set(handles.nosepiece_popupmenu, 'Value', nosEpos)
end


%%% camera %%%
function temperature_edit_Callback(hObject, eventdata, handles)
[rc,temperature] = AT_GetFloat(handles.AndorNeoParamHandle,'SensorTemperature');
set(handles.temperature_edit,'String',num2str(temperature));
end


function temperature_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function gain_edit_Callback(hObject, eventdata, handles)
depth = str2double(get(handles.gain_edit,'String'));
switch depth
    case 11
        [rc] = AT_SetEnumIndex(handles.AndorNeoParamHandle, 'BitDepth', 0);
    case 16
        [rc] = AT_SetEnumIndex(handles.AndorNeoParamHandle, 'BitDepth', 1);
end
[rc,id] = AT_GetEnumIndex(handles.AndorNeoParamHandle, 'BitDepth');
[rc,bit] = AT_GetEnumStringByIndex(handles.AndorNeoParamHandle, 'BitDepth', id, 100);
set(handles.gain_edit, 'String', bit);
end


function gain_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function preampgain_edit_Callback(hObject, eventdata, handles)
preamp = get(handles.gain_edit,'String');
switch preamp
    case 'x1'
        [rc] = AT_SetEnumIndex(handles.AndorNeoParamHandle, 'PreAmpGain', 0);
    case 'x2'
        [rc] = AT_SetEnumIndex(handles.AndorNeoParamHandle, 'PreAmpGain', 1);
    case 'x10'
        [rc] = AT_SetEnumIndex(handles.AndorNeoParamHandle, 'PreAmpGain', 2);
    case 'x30'
        [rc] = AT_SetEnumIndex(handles.AndorNeoParamHandle, 'PreAmpGain', 3);
end
[rc,id] = AT_GetEnumIndex(handles.AndorNeoParamHandle, 'PreAmpGain');
[rc,gain] = AT_GetEnumStringByIndex(handles.AndorNeoParamHandle, 'PreAmpGain', id, 100);
set(handles.gain_edit, 'String', gain);
guidata(hObject, handles);
end


function preampgain_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function exposuretime_edit_Callback(hObject, eventdata, handles)
exptime_str = get(handles.exposuretime_edit,'String');
if ~isnan(str2double(exptime_str))== 1
    exp_time = str2double(exptime_str);
    [rc] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime', exp_time);
    set(handles.exposuretime_edit, 'String', num2str(exp_time));
else
    disp('Error! Invalid camera exposure time');
end
guidata(hObject, handles);
end


function exposuretime_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function liveview_pushbutton_Callback(hObject, eventdata, handles)
exposure = str2double(get(handles.exposuretime_edit,'String'));
gain = str2double(get(handles.gain_edit,'String'));

[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'SimplePreAmpGainControl','12-bit (high well capacity)');
[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'PixelEncoding','Mono12');
[rc, imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc, height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
[rc, width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
[rc, stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
disp('Starting acquisition...');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
buf2 = zeros(height,width);
histvec = zeros(1,4095);

X = width/1.5;
Y = height/1.5;
figure('MenuBar', 'none','ToolBar', 'none', 'Name', 'LiveView')
set(gca,'units','pixels'); % set the axes units to pixels
x = get(gca,'position'); % get the position of the axes
set(gcf,'units','pixels'); % set the figure units to pixels
y = get(gcf,'position'); % get the figure position
set(gcf,'position',[y(1) y(2) x(3) x(4)])% set the position of the figure to the length and width of the axes
set(gca,'units','normalized','position',[0 0 1 1]) % set the axes units to pixels
set(gcf, 'OuterPosition', [(handles.resX/2)-(X/2) (handles.resY/2)-(Y/2) (X-22) Y])

%figure
h = imshow(buf2, [0 4095]);
if(handles.hist)
    figure('MenuBar', 'none','ToolBar', 'none', 'Name', 'Histogram');
    h2 = plot(histvec);
    histfig = true;
else
    h2 = 0;
    histfig = false;
end
while(ishandle(h))
    handles.liveView = 1;
    tic
    [rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
    [rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,900000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    buf2 = imrotate(buf2, 90);
    size(buf2)
    handles.buf2 = buf2*16;

    if(histfig && ~handles.hist)
        close('Histogram')
        histfig = false;
    end
    if(histfig)
        histvec = hist(double(buf2(:)),4095);
    end
    
    guidata(hObject, handles);
    FM = fmeasure(buf2, 'GRAS', []);%%%%
    
    %add crosshair
    
    buf2((height/2-2):(height/2+2), (width/2-25):(width/2+25)) = 0;
    buf2((height/2-25):(height/2+25),(width/2-2):(width/2+2)) = 0;
%     %add edgelines for stage/camera alignment
%     %Horizontal
    buf2((height/2-2):(height/2+2), 1:50)=0;
    buf2((height/2-2):(height/2+2), width-50:width)=0;
    buf2(1:4, 1:50) = 0;
    buf2(1:4, width-50:width)=0;
    buf2(height-2:height, 1:50)=0;
    buf2(height-2:height, width-50:width)=0;
    
%     %Vertical
    buf2(1:50,(width/2-2):(width/2+2))=0;
    buf2(height-50:height,(width/2-2):(width/2+2))=0;
    buf2(1:50,1:4)=0;
    buf2(1:50, width-2:width)=0;
    buf2(height-50:height, 1:4)=0;
    buf2(height-50:height, width-2:width)=0;

    disp(['FOCUS: ', num2str(FM)])
    %disp(['RATIO: ', num2str(ratio)])
    if(ishandle(h))
        set(h,'CData',buf2);
    end
    if(ishandle(h2) && histfig)
        set(h2, 'ydata', histvec)
    end
    %set(h,'CData',buf2);
    drawnow;
    
end

if(histfig && ishandle(h))
    histfig = false;
    close('Histogram')
end

disp('Acquisition complete');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
handles.liveview = 0;
guidata(hObject, handles);
end


function saveimage_pushbutton_Callback(hObject, eventdata, handles)
[rc,exposure] = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
buf2 = handles.buf2;
pause(exposure);
set(handles.ti2, 'iSHUTTER_EPI',0);
set(handles.epishutter_pushbutton,'String','EPIShutter_On');

[slide_number,pathName] = uiputfile('*.TIFF','Save image as:');
imwrite(buf2,[pathName,slide_number],'Compression','none');
figure; imshow(buf2); axis image; colormap gray;
end


function refresh_pushbutton_Callback(hObject, eventdata, handles)
[rc1, T] = AT_GetFloat(handles.AndorNeoParamHandle, 'SensorTemperature');
set(handles.temperature_edit, 'String', num2str(T));
end


function histogram_checkbox_Callback(hObject, eventdata, handles)
if( get(handles.histogram_checkbox,'Value')==1 )
    handles.hist = true;
else
    handles.hist = false;
end
guidata(hObject, handles);
end


function focus_pushbutton_Callback(hObject, eventdata, handles)
resX = handles.resX;
resY = handles.resY;
[rc, height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
[rc, width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
X = width/1.5;
Y = height/1.5;
figure('MenuBar', 'none','ToolBar', 'none', 'Name', 'PreView');
set(gca,'units','pixels'); % set the axes units to pixels
x = get(gca,'position'); % get the position of the axes
set(gcf,'units','pixels'); % set the figure units to pixels
y = get(gcf,'position'); % get the figure position
set(gcf,'position',[y(1) y(2) x(3) x(4)])% set the position of the figure to the length and width of the axes
set(gca,'units','normalized','position',[0 0 1 1]) % set the axes units to pixels
set(gcf, 'OuterPosition', [(handles.resX/2)-(X/2) (handles.resY/2)-(Y/2) (X-22) Y])
handles.preview = imshow( zeros(height, width, 'uint16'), [0 65535] );

lamp = get(handles.ti2, 'iDIA_LAMP_POS');
sb_status = strcmp(get(handles.blue_pushbutton, 'String'),'Off');
sg_status = strcmp(get(handles.green_pushbutton, 'String'),'Off');
sr_status = strcmp(get(handles.red_pushbutton, 'String'), 'Off');
sir_status = strcmp(get(handles.ir_pushbutton, 'String'),'Off');
if sb_status==1||sg_status==1||sr_status==1||sir_status==1
    disp('Fluorescent autofocus');
    zpos = get(handles.ti2,'iZPOSITION');
  
    [rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
    [rc,handles.imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
    [rc,handles.height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
    [rc,handles.width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
    [rc,handles.stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
    
    autofocusImgTiling(handles);
    e           % what is this? 
else 
    exposure = AT_GetFloat(handles.AndorNeoParamHandle, 'ExposureTime');
    [rc,handles.imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
    [rc,handles.height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
    [rc,handles.width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
    [rc,handles.stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
    [rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
    autofocusZyla(handles.AndorNeoParamHandle,handles, handles.ti2, 150, 'GRAS', handles.preview, lamp, exposure);
    [rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
end

guidata(hObject, handles);
end


function exposure_pushbutton_Callback(hObject, eventdata, handles)
sb_status = strcmp(get(handles.blue_pushbutton, 'String'),'Off');
sg_status = strcmp(get(handles.green_pushbutton, 'String'),'Off');
sr_status = strcmp(get(handles.red_pushbutton, 'String'), 'Off');
sir_status = strcmp(get(handles.ir_pushbutton, 'String'),'Off');

[rc,handles.imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc,handles.height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
[rc,handles.width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
[rc,handles.stride] = AT_GetInt(handles.AndorNeoParamHandle,'AOIStride');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
if sb_status == 1|| sg_status == 1|| sr_status == 1||sir_status == 1
    autoExposureControl_speed(handles.AndorNeoParamHandle, handles, handles.ETlower,handles.ETupper);
else
    disp('Brightfield exposure');
    autoexposure_brightfield(handles.AndorNeoParamHandle,handles,handles.ti2)
end
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
[rc,ET] = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
set(handles.exposuretime_edit, 'String', num2str(ET));

guidata(hObject, handles);
end


%%% stage controls %%%
function xpos_edit_Callback(hObject, eventdata, handles)
X = get(handles.xpos_edit,'String');
fprintf(handles.s2, ['!mor x ',X]);
end


function xpos_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ypos_edit_Callback(hObject, eventdata, handles)
Y = get(handles.ypos_edit,'String');
fprintf(handles.s2, ['!mor y ',Y]);
end


function ypos_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% function position_pushbutton_Callback(hObject, eventdata, handles)
% s2 = handles.s2;
% fprintf(s2, '!clearpos');
% 
% handles.Ax = 0;
% handles.Ay = 0;
% handles.Bx = 0;
% handles.By = 0;
% handles.XposFlat = 0;
% handles.YposFlat = 0;
% 
% handles.List = [];
% set(handles.listindex_edit,'String',num2str(1));
% disp('--------Ax--------Ay--------Bx--------By')
% disp(handles.List)
% disp('----------------------------------------')
% 
% set(handles.upperleft_text,'String','!!!!...Top Left Unset...!!!!','FontSize',15)
% set(handles.lowerright_text,'String','!!!!...Bottom Right Unset...!!!!','FontSize',15)
% %set(handles.text55,'String','!!!!...Flatfield Unset...!!!!','FontSize',15)
% guidata(hObject, handles);
% 
% end


function calibrate_pushbutton_Callback(hObject, eventdata, handles)
button = questdlg('Are you sure you want to calibrate the stage?','Calibrate?','Begin','Cancel','Cancel');
if(strcmp(button, 'Begin'))
    handles.stage_calibration = 1;
    
    set(handles.ti2, 'iZEscape', 1);
    
    s2 = handles.s2;
    fprintf(handles.s2, '?pos');
    flatpos = fscanf(handles.s2);
    
    %interpret and save location
    C = strsplit(flatpos);
    IXpos = str2double(C(1));
    IYpos = str2double(C(2));
    
    disp('Searching for Limits...')
    
    fprintf(s2, '?readsw');
    limits = fscanf(s2);
    fprintf(s2, '!speed -10 -10');
    
    while( strcmp( limits(1), '0' ) || strcmp( limits(2), '0' ))
        fprintf(s2, '?readsw');
        limits = fscanf(s2);
        pause(0.01);
    end
    
    fprintf(s2, '!a');
    fprintf(handles.s2, '?pos');
    flatpos = fscanf(handles.s2);
    
    %interpret and save location
    C = strsplit(flatpos);
    OXpos = str2double(C(1));
    OYpos = str2double(C(2));
    
    XD = abs(IXpos - OXpos);
    YD = abs(IYpos - OYpos);
    
    fprintf(s2, '!clearpos');
    fprintf(s2, ['!moa ',num2str(XD),' ', num2str(YD)]);
    
    fprintf(s2, '?isvel x');
    vel = fscanf(s2);
    while( ~(vel==0) )
        fprintf(s2, '?isvel x');
        vel = str2double(fscanf(s2));
        pause(0.01);
    end
    
    set(handles.ti2, 'iZEscape', 0);
    
    disp('Stage Calibrated')
end
guidata(hObject,handles);
end


function measure_pushbutton_Callback(hObject, eventdata, handles)
s2 = handles.s2;
fprintf(s2, '!a');
end


%%% lasers %%%
function blue_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.blue_edit,'String'))) == 1
    percent = str2double(get(handles.blue_edit,'String'));
    p = percent/100;
    val = floor(p*4095);
    h = dec2hex(val);
    fprintf(handles.sblue, ['?SLP',h])
else
    disp('Error while editing blue laser power!');
end
end


function blue_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function blue_pushbutton_Callback(hObject, eventdata, handles)
if(handles.isBlueOn)
    set(handles.blue_pushbutton,'String','On')
    fprintf(handles.sblue, '?LOf')
    handles.isBlueOn = false;
else
    set(handles.blue_pushbutton,'String','Off')
    fprintf(handles.sblue, '?LOn')
    handles.isBlueOn = true;
end
guidata(hObject, handles);
end


function green_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.green_edit,'String')))==1
    percent = str2double(get(handles.green_edit,'String'));
    p = percent/100;
    val = p*0.5;
    fprintf(handles.sgreen, [ 'p ',num2str(val) ])
end
end


function green_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function green_pushbutton_Callback(hObject, eventdata, handles)
if(handles.isGreenOn)
    set(handles.green_pushbutton,'String','On')
    fprintf(handles.sgreen, 'l0')
    handles.isGreenOn = false;
else
    set(handles.green_pushbutton,'String','Off')
    fprintf(handles.sgreen, 'l1')
    handles.isGreenOn = true;
end
guidata(hObject, handles);
end


function red_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.red_edit,'String')))==1
    percent = str2double(get(handles.red_edit,'String'));
    p = percent/100;
    val = floor(p*4095);
    h = dec2hex(val);
    fprintf(handles.sred, ['?SLP',h])
else
    disp('Error while editing red laser power!');
end
end


function red_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function red_pushbutton_Callback(hObject, eventdata, handles)
if(handles.isRedOn)
    set(handles.red_pushbutton,'String','On')
    fprintf(handles.sred, '?LOf')
    handles.isRedOn = false;
else
    set(handles.red_pushbutton,'String','Off')
    fprintf(handles.sred, '?LOn')
    handles.isRedOn = true;
end
guidata(hObject, handles);
end


function ir_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.ir_edit,'String')))==1
    percent = str2double(get(handles.ir_edit,'String'));
    p = percent/100;
    val = floor(p*4095);
    h = dec2hex(val);
    fprintf(handles.sir, ['?SLP',h])
else
    disp('Error while editing IR laser power!');
end
end


function ir_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ir_pushbutton_Callback(hObject, eventdata, handles)
if(handles.isIROn)
    set(handles.ir_pushbutton,'String','On')
    fprintf(handles.sir, '?LOf')
    handles.isIROn = false;
else
    set(handles.ir_pushbutton,'String','Off')
    fprintf(handles.sir, '?LOn')
    handles.isIROn = true;
end
guidata(hObject, handles);
end


function shutter_pushbutton_Callback(hObject, eventdata, handles)
if strcmp(get(handles.shutter_pushbutton,'String'),'Shutter_On')==1
    set(handles.ti2,'iTURRET1SHUTTER',1);
    set(handles.shutter_pushbutton,'String','Shutter_Off');
else
    set(handles.ti2,'iTURRET1SHUTTER',0);
    set(handles.shutter_pushbutton,'String','Shutter_On');
end
end


function epishutter_pushbutton_Callback(hObject, eventdata, handles)
if strcmp(get(handles.epishutter_pushbutton,'String'),'EPIShutter_On')==1
    set(handles.ti2,'iSHUTTER_EPI',1);
    set(handles.epishutter_pushbutton,'String','EPIShutter_Off');
else
    set(handles.ti2,'iSHUTTER_EPI',0);
    set(handles.epishutter_pushbutton,'String','EPIShutter_On');
end
end


function filter_popupmenu_Callback(hObject, eventdata, handles)
filter_index = get(handles.filter_popupmenu,'Value');
set(handles.ti2,'iTURRET1POS',filter_index);
end


function filter_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function blue_checkbox_Callback(hObject, eventdata, handles)
check = get(handles.blue_checkbox,'Value');
if check == 1
    handles.blue_check = 473;
else
    handles.blue_check = 0;
end
guidata(hObject, handles);
end


function green_checkbox_Callback(hObject, eventdata, handles)
check = get(handles.green_checkbox,'Value');
if check == 1
    handles.green_check = 561;
else
    handles.green_check = 0;
end
guidata(hObject, handles);
end


function red_checkbox_Callback(hObject, eventdata, handles)
check = get(handles.red_checkbox,'Value');
if check == 1
    handles.red_check = 647;
else
    handles.red_check = 0;
end
guidata(hObject, handles);
end


function ir_checkbox_Callback(hObject, eventdata, handles)
check = get(handles.ir_checkbox,'Value');
if check == 1
    handles.ir_check = 750;
else
    handles.ir_check = 0;
end
guidata(hObject, handles);
end


%%% directory control %%%
function slidename_edit_Callback(hObject, eventdata, handles)
end


function slidename_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function tilename_edit_Callback(hObject, eventdata, handles)
end


function tilename_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function dirselect_pushbutton_Callback(hObject, eventdata, handles)
handles.dname2 = uigetdir;
set(handles.selecteddir_text,'String',handles.dname2,'FontSize',10,'ForegroundColor',[0,0,1])
% Update handles structure
guidata(hObject, handles);
end


%%% ROI control %%%
function upperleft_pushbutton_Callback(hObject, eventdata, handles)
if handles.stage_calibration == 0
    questdlg('Please calibrate stage!','require stage calibration','Okay','Close','Okay') ;
else
    fprintf(handles.s2, '?pos');
    Bpos = fscanf(handles.s2);
    FOVx = handles.FOVx;
    FOVy = handles.FOVy;
    %interpret and save location
    C = strsplit(Bpos);
    handles.Ax = str2double(C(1))-(FOVx/2);
    handles.Ay = str2double(C(2))-(FOVy/2);
    
    set(handles.upperleft_text,'String',['(',num2str(handles.Ax),'um, ',num2str(handles.Ay),'um)'],'FontSize',15,'ForegroundColor',[0,0,1])
    guidata(hObject, handles);
end
end


function lowerright_pushbutton_Callback(hObject, eventdata, handles)

fprintf(handles.s2, '?pos');
Bpos = fscanf(handles.s2);

FOVx = handles.FOVx;
FOVy = handles.FOVy;
overlap = 10;
%interpret and save location
C = strsplit(Bpos);
handles.Bx = str2double(C(1))+(FOVx/2);
handles.By = str2double(C(2))+(FOVy/2);

% #Tiles
AOIx = handles.Ax - handles.Bx;
AOIy = handles.Ay - handles.By;
Xnum = ceil( (AOIx - overlap) / (FOVx - overlap) );
Ynum = ceil( (AOIy - overlap) / (FOVy - overlap) );
handles.Xnum = Xnum;
handles.Ynum = Ynum;

set(handles.roisize_text,'String',['(',num2str(AOIx),'um x ',num2str(AOIy),'um) - ',num2str(AOIx*AOIy/1000000),'mm2 (',num2str(Xnum),'x',num2str(Ynum),') - ',num2str(Xnum*Ynum),' Tiles'],'FontSize',10)
%display the location to UI
set(handles.lowerright_text,'String',['(',num2str(handles.Bx),'um, ',num2str(handles.By),'um)'],'FontSize',15,'ForegroundColor',[0,0,1])

guidata(hObject, handles);
end


function listindex_edit_Callback(hObject, eventdata, handles)
end


function listindex_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function saveroi_pushbutton_Callback(hObject, eventdata, handles)
index = str2double(get(handles.listindex_edit,'String'));

templist = handles.List;
templist(index, :) = [handles.Ax handles.Ay handles.Bx handles.By];
handles.List = templist;

Nindex = index+1;
set(handles.listindex_edit,'String',num2str(Nindex));

disp('--------Ax--------Ay--------Bx--------By')
disp(handles.List)
disp('----------------------------------------')
guidata(hObject, handles);
end


function removeroi_pushbutton_Callback(hObject, eventdata, handles)
index = str2double(get(handles.listindex_edit,'String'));

templist = handles.List;
templist(index, :) = [];
handles.List = templist;

disp('--------Ax--------Ay--------Bx--------By')
disp(handles.List)
disp('----------------------------------------')
guidata(hObject, handles);
end


function clearroi_pushbutton_Callback(hObject, eventdata, handles)
handles.Ax = 0;
handles.Ay = 0;
handles.Bx = 0;
handles.By = 0;
handles.XposFlat = 0;
handles.YposFlat = 0;

handles.List = [];
set(handles.listindex_edit,'String',num2str(1));
disp('--------Ax--------Ay--------Bx--------By')
disp(handles.List)
disp('----------------------------------------')

set(handles.upperleft_text,'String','!!!!...Top Left Unset...!!!!','FontSize',15,'ForegroundColor',[1,0,0]);
set(handles.lowerright_text,'String','!!!!...Bottom Right Unset...!!!!','FontSize',15,'ForegroundColor',[1,0,0]);
guidata(hObject, handles);
end


function loadroi_pushbutton_Callback(hObject, eventdata, handles)
[handles.Lname, handles.Lpath] = uigetfile('*.xlsx');

set(handles.roiloaded_text,'String',handles.Lname)
% Update handles structure
guidata(hObject, handles);
xOffset = -1000;
yOffset = -100;

handles.List = readRegions(handles.Lpath, handles.Lname);

handles.List(:,1) = handles.List(:,1) + xOffset;
handles.List(:,3) = handles.List(:,3) + xOffset;
handles.List(:,2) = handles.List(:,2) + yOffset;
handles.List(:,4) = handles.List(:,4) + yOffset;

guidata(hObject, handles);
disp('--------Ax--------Ay--------Bx--------By')
disp(handles.List)
disp('----------------------------------------')
end


function saveroi_checkbox_Callback(hObject, eventdata, handles)
end


%%% Acquisition %%%
function rawfield_pushbutton_Callback(hObject, eventdata, handles)
[rc,isImaging] = AT_GetBool(handles.AndorNeoParamHandle,'CameraAcquiring');
if(isImaging)
     return
end

check_laser = [handles.blue_check handles.ir_check handles.red_check handles.green_check];
for check = 1:numel(check_laser)
    if check_laser(check) > 0
        result = 1;
        break
    else
        result = 0;
    end
end
       
if result == 1 
    [hObject, eventdata, handles] = MERFISH_speed(hObject, eventdata, handles);
else
    questdlg('Please select lasers!','Unselected Lasers','Okay!','Fine!','Fine!');
end
end 


function flatfield_pushbutton_Callback(hObject, eventdata, handles)
% %Saves the current location as the flatfield image location
% %!!!This must be set AFTER the first tile has been selected and set the
% %origin!!!
wavelength = [473 647 750];
current_expo = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'SimplePreAmpGainControl','12-bit (high well capacity)');
[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'PixelEncoding','Mono12');
[rc, imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc, height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
[rc, width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
[rc, stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');

for i = 1:3
    switch_laser(handles,wavelength(i))
    switch wavelength(i)
        case 473
            exposure = handles.sbexpo;
        case 647
            exposure = handles.srexpo;
        case 750
            exposure = handles.sirexpo;
    end
    set(handles.ti2,'iSHUTTER_EPI',0);

    [rc]= AT_SetFloat(handles.AndorNeoParamHandle,'ExposureTime',exposure);
    [rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
    [rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,100000);
    if exposure > 0.5
        pause(exposure);
    end
    [rc,dark] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    
    set(handles.ti2,'iSHUTTER_EPI',1);
    [rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
    [rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,100000);
    if exposure > 0.5
        pause(exposure);
    end
    [rc,flat] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    flatfield_capture(:,:,i) = imrotate((flat-dark),90)*16;

    fileName = fullfile(pwd, 'CurrentFlatfields', [num2str(wavelength(i)), '.TIFF']);
    imwrite(flatfield_capture(:,:,i), fileName);
end
set(handles.ti2,'iSHUTTER_EPI',0);
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
switch_laser(handles,0);
[rc] = AT_SetFloat(handles.AndorNeoParamHandle,'ExposureTime',current_expo);

disp('Done')
guidata(hObject, handles);
end


function saturationpercentile_edit_Callback(hObject, eventdata, handles)
end


function saturationpercentile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function darkfield_pushbotton_Callback(hObject, eventdata, handles)
set(handles.ti2, 'iTURRET1SHUTTER',0)
set(handles.ti2,'iLIGHTPATH',1);
fileName = fullfile(pwd, 'CurrentDarkfields', 'DarkField.tif');
[rc,imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc,height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight')
[rc,width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth')
[rc, stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
[rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
[rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,900000);
[rc,dark] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
dark = imrotate(dark, 90);
figure,imshow(dark);
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
set(handles.ti2,'iLIGHTPATH',3);
set(handles.ti2,'iTURRET1SHUTTER',1);
imwrite(dark, fileName);
end


function mean_val_pushbutton_Callback(hObject, eventdata, handles)
[rc,imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc,height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight')
[rc,width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth')
[rc, stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
[rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
[rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,100000);
[rc,darkcapture] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
set(handles.ti2,'iSHUTTER_EPI',1);
[rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
[rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,100000);
[rc,capture] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
capture = capture - darkcapture;
capture = sort(capture(:));
mean_val = mean2(capture(5529600-5530:5529600))

[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
set(handles.ti2,'iSHUTTER_EPI',0);
end


%%% Fluid Control %%%
function valve_popupmenu_Callback(hObject, eventdata, handles)
% index = get(handles.valve_popupmenu,'Value');
% switch index
%     case 1
%         handles.current_mvp = handles.MVP;
%     case 2
%         handles.current_mvp = handles.MVP2;
%     case 3
%         handles.current_mvp = handles.MVP3;
% end
end


function valve_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function direction_popupmenu_Callback(hObject, eventdata, handles)
dir = get(handles.direction_popupmenu,'Value');
end


function direction_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function vpos_popupmenu_Callback(hObject, eventdata, handles)
index = get(handles.valve_popupmenu,'Value');
pos = get(handles.vpos_popupmenu,'Value');
dir = get(handles.direction_popupmenu,'Value');
switch dir
    case 1
        valve_dir = '0';
    case 2
        valve_dir = '1';
end

switch index
    case 1
        fprintf(handles.MVP,['aLP',valve_dir,num2str(pos),'R']);
    case 2        
        fprintf(handles.MVP2,['aLP',valve_dir,num2str(pos),'R']);
    case 3        
        fprintf(handles.MVP3,['aLP',valve_dir,num2str(pos),'R']);
end
end


function vpos_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function hy_pushbutton_Callback(hObject, eventdata, handles)
    disp('Hybridizing');
    handles = MERFISH_hybridization(handles, handles.mega, handles.MVP, handles.MVP2, handles.MVP3, 1, handles.washTime, handles.washFr, handles.hybridTime, handles.hybridFr, handles.imgTime, handles.imgFr);
    disp('Complete');       
    guidata(hObject, handles);
end


function hybrid_setup_pushbutton_Callback(hObject, eventdata, handles)
[handles.hyblue, handles.hygreen, handles.hyred, handles.hyir] = UI_2hybridization(handles.hyblue, handles.hygreen, handles.hyred);
guidata(hObject, handles);
end


function bleach_pushbutton_Callback(hObject, eventdata, handles)
bleaching = zeros(1,10);
time = [2 4 6 8 10 12 14 16 18 20]';
set(handles.ti2, 'iSHUTTER_EPI',1);
[rc,imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc,height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
[rc,width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
[rc, stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
for i = 1:10
    [rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
    [rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,100000);
    [rc,capture] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    pause(2);
    val = mean2(capture);
    bleaching(i) = val;
end
set(handles.ti2,'iSHUTTER_EPI',0);
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
f = fit(time(:),bleaching(:),'exp1')
figure, plot(f)
end


function prime_fluid_pushbutton_Callback(hObject, eventdata, handles)

% TODO: prime fluid

disp('Completed priming process');
mvp_init(handles.MVP, handles.MVP2, handles.MVP3);
end


%%% Image tiling setup %%%
function setExpo_pushbutton_Callback(hObject, eventdata, handles)
[handles.sbexpo, handles.sgexpo, handles.srexpo, handles.sirexpo] = set_exposure(handles.sbexpo, handles.sgexpo,handles.srexpo,handles.sirexpo);
guidata(hObject, handles);
end


function hybrid_round_edit_Callback(hObject, eventdata, handles)
handles.hybridization_rounds = str2double(get(handles.hybrid_round_edit, 'String'));
guidata(hObject,handles);
end


function hybrid_round_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function hybridization_fluid_edit_Callback(hObject, eventdata, handles)
handles.hybridization_fluid = str2double(get(handles.hybridization_fluid_edit,'String'));
guidata(hObject,handles);
end


function hybridization_fluid_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function focus_checkbox_Callback(hObject, eventdata, handles)
handles.Isfocus = get(handles.focus_checkbox,'Value');
end


function fluidic_checkbox_Callback(hObject, eventdata, handles)
is_fluidic = get(handles.fluidic_checkbox,'Value');
handles.isfluidic = get(handles.fluidic_checkbox,'Value');
switch is_fluidic
    case 1
        set(handles.focus_checkbox,'Value',1);
        set(handles.text93,'Visible','On');
        set(handles.hybrid_round_edit,'Visible','On');
        set(handles.text95,'Visible','On');
        set(handles.hybridization_fluid_edit,'Visible','On');
    case 0
        set(handles.focus_checkbox,'Value',0);
        set(handles.text93,'Visible','Off');
        set(handles.hybrid_round_edit,'Visible','Off');
        set(handles.text95,'Visible','Off')
        set(handles.hybridization_fluid_edit,'Visible','Off');
        handles.hybridization_rounds = 1;
        handles.hybridization_fluid = 1;
        guidata(hObject,handles);
        set(handles.hybrid_round_edit, 'String','1');
        set(handles.hybridization_fluid_edit,'String','1');
        
end
guidata(hObject,handles);
end


function threeD_pushbutton_Callback(hObject, eventdata, handles)
set(handles.ti2,'iLIGHTPATH',4);
[rc] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime',handles.sbexpo);
switch_laser(handles,473);
[rc,handles.imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
[rc,handles.height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
[rc,handles.width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
[rc,handles.stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
[rc_ExposureTime, exposure] = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'SimplePreAmpGainControl','12-bit (high well capacity)');
[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
set(handles.ti2,'iSHUTTER_EPI',1);
autofocusImgTiling(handles);

[rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');

handles.focusPos = get(handles.ti2,'iZPOSITION');

[handles.planeNum,handles.Zmax,handles.Zmin] = UI_2hybridization(handles.ti2);

set(handles.ti2,'iSHUTTER_EPI',0);
if handles.Zmax > handles.Zlimit
    handles.Zmax =  handles.Zlimit;
end

handles.z_upperRange = handles.Zmax - handles.focusPos;
handles.z_lowerRange = handles.focusPos - handles.Zmin;
ratio = handles.z_upperRange/(handles.z_upperRange + handles.z_lowerRange);
handles.upperPlaneNum = round(ratio * handles.planeNum);
handles.lowerPlaneNum = handles.planeNum - handles.upperPlaneNum;
if handles.lowerPlaneNum == 0
    handles.lowerPlaneNum = 1;
    handles.upperPlaneNum = handles.upperPlaneNum - 1;
elseif handles.upperPlaneNum == 0
    handles.upperPlaneNum = 1;
    handles.lowerPlaneNum = handles.lowerPlaneNum - 1;
end
handles.upperStepSize = handles.z_upperRange / handles.upperPlaneNum;
handles.lowerStepSize = handles.z_lowerRange / handles.lowerPlaneNum;
disp(['upper plane number', num2str(handles.upperPlaneNum)]);
disp(['lower plane number', num2str(handles.lowerPlaneNum)]);
disp(['upper stepsize:',num2str(handles.upperStepSize)]);
disp(['lower stepsize:',num2str(handles.lowerStepSize)]);

guidata(hObject, handles);
end


function three_dimensional_checkbox_Callback(hObject, eventdata, handles)
isThreeD = get(handles.three_dimensional_checkbox,'Value');
if isThreeD == 1
    set(handles.threeD_pushbutton, 'Visible','On');
else
    set(handles.threeD_pushbutton,'Visible','Off');
end
end


function initialization_checkbox_Callback(hObject, eventdata, handles)
if get(handles.initialization_checkbox,'Value') == 1
    fprintf(handles.MVP,'aLXR');
    fprintf(handles.MVP2,'aLXR');
    fprintf(handles.MVP3,'aLXR');
    pause(8);

    set(handles.valve_popupmenu,'Enable','on');
    set(handles.direction_popupmenu,'Enable','on');
    set(handles.vpos_popupmenu,'Enable','on');
else
    set(handles.valve_popupmenu,'Enable','off');
    set(handles.direction_popupmenu,'Enable','off');
    set(handles.vpos_popupmenu,'Enable','off');
end
end


%%% Quit Matlab %%%
function exit_pushbutton_Callback(hObject, eventdata, handles)
exit
end


%%% Adding scale bar %%%
function scale_pushbutton_Callback(hObject, eventdata, handles)
[filename,filepath] = uigetfile({'*.TIFF';'*.bmp'},'select image..');
this_img = imread([filepath,filename]);
this_img(handles.height-50:handles.height-40,handles.width-250:handles.width-50)= 65535;
 text = [num2str(handles.scale),'um'];
 color = 'white';
 box_color = 'black';
 location = [2370 2060];
 this_img = insertText(this_img,location,text,'FontSize',25,'BoxColor',box_color,'BoxOpacity',0.6,'TextColor',color);
 filename2 = ['added scale_',filename];
 filepath2 = uigetdir;
 if not(exist(filepath2,'dir'))
     mkdir(filepath2);
 end
 imwrite(this_img, [filepath2,'\',filename2]);
end


function initial_hybrid_pushbutton_Callback(hObject, eventdata, handles)
skip = questdlg('Do you want to skip first round of hybridization?','Intial hybrdization','Skip!','No!','Skip!');
if strcmp(skip,'Skip!')
    disp('Injecting imaging buffer');
    imaging(handles.mega, handles.MVP2, get(handles.mega, 'img_t'));
    disp('Completed!');
else
    disp('Hybridizing');
    handles = MERFISH_hybridization(handles, handles.mega, handles.MVP, handles.MVP2, handles.MVP3, 1, handles.washTime, handles.washFr, handles.hybridTime, handles.hybridFr, handles.imgTime, handles.imgFr);
    disp('Complete');         
end
end


function est_pushbutton_Callback(hObject, eventdata, handles)
tile_num = handles.Xnum*handles.Ynum;

laser_expo = [handles.sbexpo handles.sirexpo handles.srexpo handles.sgexpo];
laser_check = [handles.blue_check handles.ir_check handles.red_check handles.green_check];
selected_laser = laser_check > 0;
selected_laser_expo = laser_expo(selected_laser);
total_expo = sum(selected_laser_expo);

IsThreeDimensional = get(handles.three_dimensional_checkbox,'Value');
if IsThreeDimensional ~= 1
    planeNum = 1;
else
    planeNum = handles.planeNum;
end

IsAutoFocus = get(handles.focus_checkbox,'Value');
if IsAutoFocus == 1
    focus_time  = 8*handles.sbexpo;
else 
    focus_time = 0;
end

imaging_time = tile_num*planeNum*(total_expo+focus_time);

fluid_time = handles.hybridization_fluid*2120;

total_time = imaging_time + fluid_time;

time_hour = floor(total_time/3600);
reminder_1 = rem(total_time,3600);
time_min = floor(reminder_1/60);
time_sec = round(rem(reminder_1,60));

set(handles.est_text,'String',['Estimated Time: ',num2str(time_hour),'HR ',num2str(time_min),'MIN ',num2str(time_sec),'SEC']);  
end


%%% Connect to instruments %%%
function ti2_connect_push_Callback(hObject, eventdata, handles)
disp('Connecting to Nikon Ti2...')
ti2 = actxserver('Nikon.Ti2.Microscope');
Connect(ti2, 1);
handles.ti2 = ti2;
ti2.set('iLIGHTPATH',3)
ti2.set('iDIA_LAMP_Pos',60)
ti2.set('iDIA_LAMP_Switch',1)
set(ti2,'iPFS_OFFSET',0);

lamp = get(ti2, 'iDIA_LAMP_POS');
set(handles.lampvoltage_edit, 'String', num2str(lamp))

zpos = get(ti2, 'iZPOSITION');
set(handles.zpos_edit, 'String', num2str(zpos))

nosEpos = get(ti2, 'iNOSEPIECE');
set(handles.nosepiece_popupmenu, 'Value', nosEpos);

set(handles.ti2, 'iTURRET1SHUTTER',1);
set(handles.shutter_pushbutton, 'String', 'Shutter_Off');

disp('Connected to Nikon Ti2');
guidata(hObject, handles);
end


function connect_stage_push_Callback(hObject, eventdata, handles)
handles.stage = 'MW SCAN';

disp('Connecting to XY Stage...')
s2 = serial('COM5');
set(s2,'BaudRate',57600);
set(s2,'DataBits',8);
%set(s2,'Parity','none');
set(s2,'StopBits',1);
set(s2,'Terminator',13)
set(s2,'FlowControl','hardware')
fopen(s2);

fprintf(s2,'!dim 1 1');
fprintf(s2,'!encpos 1');
fprintf(s2,'!autostatus 0');

handles.s2 = s2;

set(handles.xpos_edit, 'Enable', 'On');
set(handles.ypos_edit, 'Enable', 'On');
set(handles.calibrate_pushbutton, 'Enable', 'On');
set(handles.measure_pushbutton, 'Enable', 'On');
% set(handles.position_pushbutton, 'Enable', 'On');
set(handles.upperleft_pushbutton, 'Enable', 'On');
set(handles.lowerright_pushbutton, 'Enable', 'On');
set(handles.listindex_edit, 'Enable', 'On');
set(handles.saveroi_pushbutton, 'Enable', 'On');
set(handles.removeroi_pushbutton, 'Enable', 'On');
set(handles.clearroi_pushbutton, 'Enable', 'On');
set(handles.loadroi_pushbutton, 'Enable', 'On');
% set(handles.saveroi_checkbox, 'Enable', 'On');

set(handles.measure_pushbutton, 'String', 'Stop');
%set(handles.position_pushbutton, 'String', 'Set Origin');

disp('Connected to SCAN Stage')
guidata(hObject, handles);
end


function connect_camera_push_Callback(hObject, eventdata, handles)
if isfield(handles,'AndorNeoParamHandle')
    [rc_close] = AT_Close(handles.AndorNeoParamHandle);
    [rc_finalize] = AT_FinaliseLibrary();
end

% Andor Neo is selected
handles.camera = 'Andor Neo';
set(handles.gain_text,'String','Bit-Depth')
set(handles.exposuretime_text,'String','Exposure time[s]')
disp('Preparing Camera...');
[rc] = AT_InitialiseLibrary();
[rc,hndl] = AT_Open(0);
handles.AndorNeoParamHandle = hndl;

[rc] = AT_SetBool(hndl,'SensorCooling',1);
[rc] = AT_SetEnumString(hndl,'SimplePreAmpGainControl','12-bit (high well capacity)');
[rc] = AT_SetEnumString(hndl,'PixelEncoding','Mono12');

[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'ElectronicShurtteringMode', 'Global');

[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'CycleMode','Continuous');
[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'TriggerMode','Software');

[rc] = AT_SetInt(handles.AndorNeoParamHandle,'AOIHeight', 2160);
[rc] = AT_SetInt(handles.AndorNeoParamHandle,'AOIWidth', 2560);
[rc] = AT_SetInt(handles.AndorNeoParamHandle,'AOITop', 1);
[rc] = AT_SetInt(handles.AndorNeoParamHandle,'AOILeft', 1);

[rc,id] = AT_GetEnumIndex(handles.AndorNeoParamHandle, 'PreAmpGain');
[rc,gain] = AT_GetEnumStringByIndex(handles.AndorNeoParamHandle, 'PreAmpGain', id, 100);
set(handles.preampgain_edit, 'String', gain);

[rc,id] = AT_GetEnumIndex(handles.AndorNeoParamHandle, 'TemperatureControl');
[rc,temp] = AT_GetEnumStringByIndex(handles.AndorNeoParamHandle, 'TemperatureControl', id, 100);
set(handles.temperature_edit, 'String', temp);

[rc,id] = AT_GetEnumIndex(handles.AndorNeoParamHandle, 'BitDepth');
[rc,bit] = AT_GetEnumStringByIndex(handles.AndorNeoParamHandle, 'BitDepth', id, 100);
set(handles.gain_edit, 'String', bit);
set(handles.gain_text, 'String', 'BitDepth');

[rc] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime', 0.01);
set(handles.exposuretime_edit, 'String', num2str(0.01));

disp('Camera ready..');
guidata(hObject, handles);
end


function connect_lasers_push_Callback(hObject, eventdata, handles)
disp('Connecting to Laser-473...');
sblue = serial('COM7');
set(sblue,'BaudRate',500000);
set(sblue,'DataBits',8);
set(sblue,'Parity','none');
set(sblue,'StopBits',1);
set(sblue,'Terminator',13)
fopen(sblue);
handles.sblue = sblue;

fileName = fullfile(pwd, 'previousSettings.mat');
if exist(fileName,'file')
    load(fileName, 'powerSettings');
    val1 = floor(powerSettings(1)/100*4095);
    val2 = floor(powerSettings(3)/100*4095);
    val3 = floor(powerSettings(4)/100*4095);
    set(handles.blue_edit,'String',num2str(powerSettings(1)));
    set(handles.red_edit,'String',num2str(powerSettings(3)));
    set(handles.ir_edit,'String',num2str(powerSettings(4)));
else
    val1 = floor(0.05*4095);
    val2 = floor(0.3*4095);
    val3 = floor(0.5*4095);
    set(handles.blue_edit,'String','5');
    set(handles.red_edit,'String','30')
    set(handles.ir_edit,'String','50');
end

h = dec2hex(val1);
h2 = dec2hex(val2);
h3 = dec2hex(val3);
fprintf(sblue, ['?SLP',h]);

disp('Connecting to Laser-561...');
sgreen = serial('COM6');
set(sgreen,'BaudRate',115200);
set(sgreen,'DataBits',8);
set(sgreen,'Parity','none');
set(sgreen,'StopBits',1);
set(sgreen,'Terminator',13)
fopen(sgreen);
handles.sgreen = sgreen;
if exist('powerSettings','var') == 1
    fprintf(sgreen,['p ',num2str(0.5*powerSettings(2)/100)]);
    set(handles.green_edit,'String',num2str(powerSettings(2)));

else
    fprintf(sgreen, 'p 0.07');
    set(handles.green_edit,'String','14')
end

disp('Connecting to Laser-647...');
sred = serial('COM9');
set(sred,'BaudRate',500000);
set(sred,'DataBits',8);
set(sred,'Parity','none');
set(sred,'StopBits',1);
set(sred,'Terminator',13)
fopen(sred);
handles.sred = sred;
fprintf(sred, ['?SLP',h2]);

disp('Connecting to Laser-750...');
sir = serial('COM10');
set(sir,'BaudRate',500000);
set(sir,'DataBits',8);
set(sir,'Parity','none');
set(sir,'StopBits',1);
set(sir,'Terminator',13)
fopen(sir);
fprintf(sir, ['?SLP',h3]);
handles.sir = sir;

disp('Connected to lasers');
guidata(hObject, handles);
end


function connect_fluid_push_Callback(hObject, eventdata, handles)
disp('Connecting to Blossom...');
MVP = serial('COM12');
set(MVP,'BaudRate',9600);
set(MVP,'DataBits',7);
set(MVP,'Parity','Odd');
set(MVP,'StopBits',1);
set(MVP,'Terminator',13)
%set(MVP,'FlowControl','hardware')
fopen(MVP);
fprintf(MVP,'1a');

handles.MVP = MVP;

disp('Connection to Bubbles...');
MVP2 = serial('COM11');
set(MVP2,'BaudRate',9600);
set(MVP2,'DataBits',7);
set(MVP2,'Parity','Odd');
set(MVP2,'StopBits',1);
set(MVP2,'Terminator',13)
%set(MVP2,'FlowControl','hardware')
fopen(MVP2);
fprintf(MVP2,'1a');

handles.MVP2 = MVP2;

disp('Connection to Buttercup...');
MVP3 = serial('COM13');
set(MVP3,'BaudRate',9600);
set(MVP3,'DataBits',7);
set(MVP3,'Parity','Odd');
set(MVP3,'StopBits',1);
set(MVP3,'Terminator',13)
%set(MVP3,'FlowControl','hardware')
fopen(MVP3);
fprintf(MVP3,'1a');

handles.MVP3 = MVP3;

%Connect to pump
disp('Connecting to Pump...');
handles.mega = arduino('COM12','Mega2560');
configurePin(handles.mega, 'D20', 'pullup');        % bubble sensor

disp('Fluid system ready..')
guidata(hObject, handles);
end


function lightpath_popup_Callback(hObject, eventdata, handles)
light_path = get(handles.lightpath_popup,'Value');
switch light_path
    case 1 
        set(handles.ti2,'iLIGHTPATH',1);
    case 2
        set(handles.ti2,'iLIGHTPATH',4);
    case 3
        set(handles.ti2,'iLIGHTPATH',3);
end
end


function lightpath_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function startFromEdit_Callback(hObject, eventdata, handles)
handles.startRun = str2double(get(handles.startFromEdit,'String'));
guidata(hObject, handles)
end


function startFromEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function tilecapture_uipanel_CreateFcn(hObject, eventdata, handles)
end


function img_fr_popupmenu_Callback(hObject, eventdata, handles)
handles.imgFr = get(handles.img_fr_popupmenu, 'Value') - 1;
guidata(hObject, handles);

end


function img_fr_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function wash_fr_popupmenu_Callback(hObject, eventdata, handles)
handles.washFr = get(handles.wash_fr_popupmenu, 'Value') - 1;
guidata(hObject, handles);

end


function wash_fr_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function hybrid_fr_popupmenu_Callback(hObject, eventdata, handles)
handles.hybridFr = get(handles.hybrid_fr_popupmenu, 'Value') - 1;
guidata(hObject, handles);

end


function hybrid_fr_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function img_t_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.img_t_edit,'String'))) == 1
    imgTime = str2double(get(handles.img_t_edit,'String'));
    guidata(hObject, handles);

else
    disp('Error! Invalid imaging buffer time');
end
end


function img_t_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function wash_t_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.wash_t_edit,'String'))) == 1
    handles.washTime = str2double(get(handles.wash_t_edit,'String'));
    guidata(hObject, handles);

else
    disp('Error! Invalid wash buffer time');
end
end


function wash_t_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function hybrid_t_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.hybrid_t_edit,'String'))) == 1
    handles.hybridTime = str2double(get(handles.hybrid_t_edit,'String'));
    guidata(hObject, handles);

else
    disp('Error! Invalid hybridization buffer time');
end
end


function hybrid_t_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function clvg_fr_popupmenu_Callback(hObject, eventdata, handles)
handles.cleavageFr = get(handles.clvg_fr_popupmenu, 'Value') - 1;
guidata(hObject, handles);

end


function clvg_fr_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function clvg_t_edit_Callback(hObject, eventdata, handles)
if ~isnan(str2double(get(handles.clvg_t_edit,'String'))) == 1
    handles.cleavageTime = str2double(get(handles.clvg_t_edit,'String'));
    guidata(hObject, handles);

else
    disp('Error! Invalid cleavage flowrate');
end
end


function clvg_t_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
