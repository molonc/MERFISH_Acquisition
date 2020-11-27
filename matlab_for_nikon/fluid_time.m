function varargout = fluid_time(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fluid_time_OpeningFcn, ...
                   'gui_OutputFcn',  @fluid_time_OutputFcn, ...
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


% --- Executes just before fluid_time is made visible.
end
function fluid_time_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.washTime = varargin{1};
handles.hybridTime = varargin{2};
handles.clevageTime = varargin{3};
set(handles.edit1,'String',num2str(handles.washTime));
set(handles.edit4, 'String',num2str(handles.hybridTime));
set(handles.edit5, 'String', num2str(handles.clevageTime));
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = fluid_time_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
% varargout{1} = handles.washTime;
% varargout{2} = handles.hybridTime;
% varargout{3} = handles.clevageTime;
delete(handles.figure1);

end


function edit1_Callback(hObject, eventdata, handles)
handles.washTime = str2double(get(handles.edit1,'String'));
check = handles.washTime;
disp(check);
guidata(hObject, handles);
end

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit4_Callback(hObject, eventdata, handles)
handles.hybridTime= str2double(get(handles.edit4,'String'));
check = handles.hybridTime;
disp(check);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit5_Callback(hObject, eventdata, handles)
handles.clevageTime = str2double(get(handles.edit5,'String'));
check = handles.washTime;
disp(check);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
end