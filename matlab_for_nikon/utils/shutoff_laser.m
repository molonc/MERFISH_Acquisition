function[] = shutoff_laser(handles)
fprintf(handles.sgreen, 'l0')
fprintf(handles.sred,'?LOf')
fprintf(handles.sir, '?LOf')
fprintf(handles.sblue,'?LOf')
set(handles.blue_pushbutton,'String','On');
set(handles.green_pushbutton,'String','On');
set(handles.red_pushbutton,'String','On');
set(handles.ir_pushbutton,'String','On');
end