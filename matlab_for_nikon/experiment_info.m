function varargout = experiment_info(varargin)
% EXPERIMENT_INFO MATLAB code for experiment_info.fig

% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experiment_info

% Last Modified by GUIDE v2.5 20-Dec-2019 09:51:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experiment_info_OpeningFcn, ...
                   'gui_OutputFcn',  @experiment_info_OutputFcn, ...
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

% --- Executes just before experiment_info is made visible.
function experiment_info_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

d = date;

handles.sampleID = '';

handles.xenoID = '';

handles.library = '';

handles.libraryPrep = '';

handles.digestionBuffer = 'SDS';

handles.digestionTime = '48 hrs';

handles.expansion = 0;

handles.date = d;

handles.readout = '';

handles.concentration = '10nm';

set(handles.edit_5,'String','SDS');

set(handles.edit_6,'String','48 hrs');

set(handles.edit_10,'String','10nm');

set(handles.edit_8,'String', d);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes experiment_info wait for user response (see UIRESUME)
uiwait(handles.figure1);

end

function figure1_CloseRequestFcn(hObject, eventdata, handles)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
% elseif strcmp(get(handles.edit_1,'String'),'') == 1
%     disp('Please enter sample ID!');
%     uiresume(hObject);
else
    delete(hObject);
end

end
% --- Outputs from this function are returned to the command line.
function varargout = experiment_info_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.sampleID;
% varargout{2} = handles.xenoID;
% varargout{3} = handles.library;
% varargout{4} = handles.libraryPrep;
% varargout{5} = handles.digestionBuffer;
% varargout{6} = handles.digestionTime;
% varargout{7} = handles.expansion;
% varargout{8} = handles.date;
% varargout{9} = handles.readout;
% varargout{10} = handles.concentration;

delete(handles.figure1);

end



function edit_5_Callback(hObject, eventdata, handles)
handles.digestionBuffer = get(handles.edit_5,'String');
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit_5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_1_Callback(hObject, eventdata, handles)

handles.sampleID = get(handles.edit_1,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_2_Callback(hObject, eventdata, handles)
handles.xenoID = get(handles.edit_2,'String');
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_3_Callback(hObject, eventdata, handles)

handles.library = get(handles.edit_3,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_4_Callback(hObject, eventdata, handles)

handles.libraryPrep = get(handles.edit_4,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit_6_Callback(hObject, eventdata, handles)

handles.digestionTime = get(handles.edit_6,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit_8_Callback(hObject, eventdata, handles)

handles.date = get(handles.edit_8,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit_9_Callback(hObject, eventdata, handles)

handles.readout = get(handles.edit_9,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit_10_Callback(hObject, eventdata, handles)

handles.concentration = get(handles.edit_10,'String');
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function edit_10_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in checkbox_1.
function checkbox_1_Callback(hObject, eventdata, handles)

handles.expansion = get(handles.checkbox_1, 'Value');
guidata(hObject, handles);

end


