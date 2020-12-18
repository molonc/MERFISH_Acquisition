function [handles] = autofocusImgTiling(handles)

disp('Focusing');

set(handles.ti2,'iSHUTTER_EPI',1);
steps = 5;
stepSize = 100;
FM_arr  = zeros(2,10);

for i = 1:(steps*2+1)  
    set(handles.ti2,'iSHUTTER_EPI',1);
    [~,exposure] = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
    [~] = AT_QueueBuffer(handles.AndorNeoParamHandle,handles.imagesize);
    [~] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
    [~,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,10000);
    
    if exposure > 0.5
        pause(exposure);
    end
    
    [~,frame] = AT_ConvertMono16ToMatrix(buf,handles.height,handles.width,handles.stride);
    frame = imrotate(frame,90)*16;
    
    % get the focus measure of the current capture
    % using MATLAB's built-in fmeasure function
    FM = fmeasure(frame,'GDER',[]);
    Zpos = get(handles.ti2,'iZPOSITION');
    FM_arr(1,i) = FM;
    FM_arr(2,i) = Zpos;
    
    if i ~= steps*2+1
        Zpos = Zpos + stepSize;
        set(handles.ti2,'iZPOSITION',Zpos);
    end
end

OptimFM = max(FM_arr(1,:));
[~,B] = find(FM_arr == OptimFM);
set(handles.ti2, 'iZPOSITION', FM_arr(2,B));

end