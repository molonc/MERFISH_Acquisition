function [] = autofocusSecondary(handles)

count = 0;
%if counting == 1
disp('Focusing');

set(handles.ti2,'iSHUTTER_EPI',1);

stepSize = 75;

nPos = get(handles.ti2,'iZPOSITION');

set(handles.ti2,'iZPOSITION',nPos-stepSize);

focusData = zeros(5,2);
for i = 1:5
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
%     filter = fspecial('gaussian',2160,2);
%     frame = imfilter(frame,filter,'replicate');
    %set(handles.preview,'CData',frame);
    
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