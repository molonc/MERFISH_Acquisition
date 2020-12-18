function [handles] = autofocusSecondary(handles)

disp('Focusing');

set(handles.ti2,'iSHUTTER_EPI',1);

stepSize = 75;

nPos = get(handles.ti2,'iZPOSITION');

set(handles.ti2,'iZPOSITION',nPos-stepSize);

focusData = zeros(5,2);
for i = 1:5
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
    
    FM = fmeasure(frame,'GDER',[]);
    Zpos = get(handles.ti2,'iZPOSITION');
    focusData(i,1) = Zpos;
    focusData(i,2) = FM;
    
    set(handles.ti2,'iZPOSITION',Zpos+stepSize);
end

maxFM = max(focusData(:,2));

for j = 1:size(focusData,1)
    if focusData(j,2) == maxFM
        focusPlane = focusData(j,1);
    end
end

set(handles.ti2, 'iZPOSITION',focusPlane);

end