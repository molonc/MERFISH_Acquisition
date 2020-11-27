function[] = autofocusImgTiling(handles)

count = 0;
%if counting == 1
disp('Focusing');

set(handles.ti2,'iSHUTTER_EPI',1);
steps = 5;
stepSize = 100;
FM_arr  = zeros(2,10);
Zpos = get(handles.ti2, 'iZPOSITION');
startPos = Zpos - stepSize * steps
for i = 1:(steps*2+1)
    
    set(handles.ti2,'iSHUTTER_EPI',1);
    [rc,exposure] = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
    [rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,handles.imagesize);
    [rx] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,10000);
    if exposure > 0.5
        pause(exposure);
    end
    [rc,frame] = AT_ConvertMono16ToMatrix(buf,handles.height,handles.width,handles.stride);
    frame = imrotate(frame,90)*16;
    
    FM = fmeasure(frame,'GDER',[]);
    Zpos = get(handles.ti2,'iZPOSITION');
    FM_arr(1,i) = FM;
    %     if FM/oldFM > 1.3
    %         stepSize=stepSize * (-1);
    FM_arr(2,i) = Zpos;
    
    if i ~= steps*2+1
        Zpos = Zpos + stepSize;
        set(handles.ti2,'iZPOSITION',Zpos);
    end
end
OptimFM = max(FM_arr(1,:));
[A,B] = find(FM_arr == OptimFM);
set(handles.ti2, 'iZPOSITION', FM_arr(2,B));

end