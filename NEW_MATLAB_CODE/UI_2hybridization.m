function varargout = UI_2hybridization(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_2hybridization_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_2hybridization_OutputFcn, ...
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
% --- Executes just before UI_2hybridization is made visible.
end


function UI_2hybridization_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.ti2 = varargin{1};
handles.focus_pos = get(handles.ti2,'iZPOSITION');
guidata(hObject, handles);
%uiwait(hObject);
% UIWAIT makes UI_2hybridization wait for user response (see UIRESUME)
 uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = UI_2hybridization_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)figure

% Get default command line output from handles structure
%varargout{1} = handles.output;
varargout{1} = handles.planeNum;
varargout{2} = handles.Zmax;
varargout{3} = handles.Zmin;
% varargout{1} = handles.hyblue;
% varargout{2} = handles.hygreen;
% varargout{3} = handles.hyred;
% varargout{4} = handles.hyir;

delete(handles.figure1);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
end


function planeNum_edit_Callback(hObject, eventdata, handles)
handles.planeNum = str2double(get(handles.planeNum_edit,'String'));
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function planeNum_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in Zmax_pushbutton.
function Zmax_pushbutton_Callback(hObject, eventdata, handles)
handles.Zmax = get(handles.ti2,'iZPOSITION');
guidata(hObject, handles);
% if handles.Zmax < handles.focus_pos
%     set(handles.Zmax_text,'String','Error','ForegroundColor','red');
% else
%     set(handles.Zmax_text,'String', num2str(handles.Zmax),'ForegroundColor','blue');
% end
set(handles.Zmax_text,'String', num2str(handles.Zmax),'ForegroundColor','blue');
end


% --- Executes on button press in Zmin_pushbutton.
function Zmin_pushbutton_Callback(hObject, eventdata, handles)
handles.Zmin = get(handles.ti2,'iZPOSITION');
guidata(hObject,handles);
% if handles.Zmin > handles.focus_pos
%     set(handles.Zmin_text,'String', 'Error','ForegroundColor','red');
% else
%     set(handles.Zmin_text,'String', num2str(handles.Zmin),'ForegroundColor','blue');
% end
set(handles.Zmin_text,'String', num2str(handles.Zmin),'ForegroundColor','blue');
end
