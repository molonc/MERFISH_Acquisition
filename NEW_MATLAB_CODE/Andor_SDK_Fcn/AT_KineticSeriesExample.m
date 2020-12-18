disp('Andor SDK3 Kinetic Series Example');
[rc] = andorsdk3functions('AT_InitialiseLibrary');
[rc,hndl] = andorsdk3functions('AT_Open',0);
disp('Camera initialized');
[rc] = andorsdk3functions('AT_SetFloat',hndl,'ExposureTime',0.01);
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'CycleMode','Fixed');
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'TriggerMode','Internal');
[rc] = andorsdk3functions('AT_SetEnumIndex',hndl,'PreAmpGainControl',3);
frameCount = 500;
[rc] = andorsdk3functions('AT_SetInt',hndl,'FrameCount',frameCount);
[rc,imagesize] = andorsdk3functions('AT_GetInt',hndl,'ImageSizeBytes');
[rc,height] = andorsdk3functions('AT_GetInt',hndl,'AOIHeight');
[rc,width] = andorsdk3functions('AT_GetInt',hndl,'AOIWidth');  
for X = 1:10
    [rc] = andorsdk3functions('AT_QueueBuffer',hndl,imagesize);
end
disp('Starting acquisition...');
[rc] = andorsdk3functions('AT_Command',hndl,'AcquisitionStart');
buf2 = zeros(width,height);
h=imagesc(buf2);
i=0;
while(i<frameCount)
    [rc,buf] = andorsdk3functions('AT_WaitBuffer',hndl,1000);
    [rc] = andorsdk3functions('AT_QueueBuffer',hndl,imagesize);
    [rc,buf2] = andordataconversion('AT_ConvertMono12PackedToMatrix',buf,height,width);
    set(h,'CData',buf2);
    drawnow;
    i = i+1;
end
disp('Acquisition complete');
[rc] = andorsdk3functions('AT_Command',hndl,'AcquisitionStop');
[rc] = andorsdk3functions('AT_Close',hndl);
[rc] = andorsdk3functions('AT_FinaliseLibrary');
disp('Camera shutdown');
