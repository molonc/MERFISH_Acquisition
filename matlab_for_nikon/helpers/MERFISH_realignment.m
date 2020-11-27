function [] = MERFISH_realignment(handles,des_FM)

if rem(round(handles.planeNum/2),2)>0
    start = handles.Zmax - handles.threeDstepSize*(round(handles.planeNum/2)-1);
else
    start = handles.Zmax + handles.threeDstepSize*round(handles.planeNum/2);
end
 set(handles.ti2,'iZPOSITION',start);

 oldDIFF = 100; nSWITCH = 0; stepSize = -100; count = 0;

while(true)
    
    count = count+1;
    zpos = get(handles.ti2,'iZPOSITION')
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
    FM = fmeasure(frame,'GDER',[])
    
    Diff = abs(FM-des_FM)/des_FM;
    
    if Diff > oldDIFF+0.0008
        stepSize = stepSize*-1;
        nSWITCH = nSWITCH + 1;
    end
    oldDIFF = Diff;
    if Diff > 0.01
        set(handles.ti2,'iZPOSITION',zpos+stepSize);
    else
        break;           
    end
    
    
    if count == 15
        disp('Unable to find plane!');
        break;
    elseif nSWITCH > 2
        break;
    end
    
    
end


end