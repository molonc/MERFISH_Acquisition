function [hObject, handles] = switch_laser(hObject, handles,wavelength)
%handles.ti2.set('iTURRET1SHUTTER',1)
switch wavelength
    case 473
        fprintf(handles.sgreen, 'l0');
        fprintf(handles.sred,'?LOf');
        fprintf(handles.sir, '?LOf');
        fprintf(handles.sblue,'?LOn');
        set(handles.blue_pushbutton,'String','Off');
        set(handles.green_pushbutton,'String','On');
        set(handles.red_pushbutton,'String','On');
        set(handles.ir_pushbutton,'String','On');
        
    case 561
        fprintf(handles.sblue,'?LOf');
        fprintf(handles.sred, '?LOf');
        fprintf(handles.sir, '?LOf');
        fprintf(handles.sgreen,'l1');
        set(handles.blue_pushbutton,'String','On');
        set(handles.green_pushbutton,'String','Off');
        set(handles.red_pushbutton,'String','On');
        set(handles.ir_pushbutton,'String','On');
        
    case 647
  
        fprintf(handles.sblue,'?LOf');
        fprintf(handles.sgreen,'l0');
        fprintf(handles.sir, '?LOf');
        fprintf(handles.sred, '?LOn');
        set(handles.blue_pushbutton,'String','On');
        set(handles.green_pushbutton,'String','On');
        set(handles.red_pushbutton,'String','Off');
        set(handles.ir_pushbutton,'String','On');
        
    case 750 
     
        fprintf(handles.sblue,'?LOf');
        fprintf(handles.sgreen,'l0');
        fprintf(handles.sred, '?LOf');
        fprintf(handles.sir, '?LOn');
        set(handles.blue_pushbutton,'String','On');
        set(handles.green_pushbutton,'String','On');
        set(handles.red_pushbutton,'String','On');
        set(handles.ir_pushbutton,'String','Off');
        
    case 0
        fprintf(handles.sblue,'?LOf');
        fprintf(handles.sgreen,'l0');
        fprintf(handles.sred, '?LOf');
        fprintf(handles.sir, '?LOf');
        set(handles.blue_pushbutton,'String','On');
        set(handles.green_pushbutton,'String','On');
        set(handles.red_pushbutton,'String','On');
        set(handles.ir_pushbutton,'String','On');   
end

guidata(hObject, handles);
end




