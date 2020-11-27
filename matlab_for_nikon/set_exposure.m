function [varargout] = set_exposure(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @set_exposure_OpeningFcn, ...
                   'gui_OutputFcn',  @set_exposure_OutputFcn, ...
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


% --- Executes just before set_exposure is made visible.
end
function set_exposure_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.sbexpo = varargin{1};
handles.sgexpo = varargin{2};
handles.srexpo = varargin{3};
handles.sirexpo = varargin{4};
handles.washTime = varargin{5};
handles.hybridTime = varargin{6};
handles.clevageTime = varargin{7};
set(handles.edit1,'String',num2str(handles.sbexpo));
set(handles.edit2, 'String',num2str(handles.sgexpo));
set(handles.edit3, 'String',num2str(handles.srexpo));
set(handles.edit4,'String', num2str(handles.sirexpo));
set(handles.edit5,'String',num2str(handles.washTime));
set(handles.edit6, 'String',num2str(handles.hybridTime));
set(handles.edit7, 'String',num2str(handles.clevageTime));
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);
end

function varargout = set_exposure_OutputFcn(hObject, eventdata, handles) 

%varargout{1} = handles.output;
varargout{1} = handles.sbexpo;
varargout{2} = handles.sgexpo;
varargout{3} = handles.srexpo;
varargout{4} = handles.sirexpo;
varargout{5} = handles.washTime;
varargout{6} = handles.hybridTime;
varargout{7} = handles.clevageTime;
delete(handles.figure1);

end



function edit1_Callback(hObject, eventdata, handles)
handles.sbexpo = str2double(get(handles.edit1, 'String'));
guidata(hObject, handles);

end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit2_Callback(hObject, eventdata, handles)
handles.sgexpo = str2double(get(handles.edit2,'String'));
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit3_Callback(hObject, eventdata, handles)
handles.srexpo = str2double(get(handles.edit3,'String'));
guidata(hObject, handles);
end
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit4_Callback(hObject, eventdata, handles)
handles.sirexpo = str2double(get(handles.edit4,'String'));
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
end



function edit5_Callback(hObject, eventdata, handles)
handles.washTime = str2double(get(handles.edit5,'String'));
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit6_Callback(hObject, eventdata, handles)
handles.hybridTime = str2double(get(handles.edit6,'String'));
guidata(hObject,handles);
end
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit7_Callback(hObject, eventdata, handles)
handles.clevageTime = str2double(get(handles.edit7,'String'));
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
