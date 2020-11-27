function[] = PFS_set(handles)
search = 1;
current_pos = get(handles.ti2,'iZPOSITION');
set(handles.ti2,'iZPOSITION',current_pos-1000);
target_pos = current_pos;
count = 0;
step = 150; 
set(handles.ti2,'iSHUTTER_EPI',1);
while search == 1
    
    target_pos=target_pos+step;
    count = count+1;
    set(handles.ti2,'iZPOSITION',target_pos);
    
    PFS_status = get(handles.ti2,'iPFS_STATUS');
    
    if PFS_status >= 256
        break;
    end
   
end

pause(2);
end