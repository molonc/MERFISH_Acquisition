disp('Andor SDK3 Kinetic Series Example');
[rc] = andorsdk3functions('AT_InitialiseLibrary');
[rc,hndl] = andorsdk3functions('AT_Open',0);
disp('Camera initialized');
[rc] = andorsdk3functions('AT_SetFloat',hndl,'ExposureTime',0.01);
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'CycleMode','Continuous');
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'TriggerMode','Software');
[rc] = andorsdk3functions('AT_SetEnumIndex',hndl,'PreAmpGainControl',3);
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'PixelEncoding','Mono12Packed');
[rc,imagesize] = andorsdk3functions('AT_GetInt',hndl,'ImageSizeBytes');
[rc,height] = andorsdk3functions('AT_GetInt',hndl,'AOIHeight');
[rc,width] = andorsdk3functions('AT_GetInt',hndl,'AOIWidth');
warndlg('To Abort the acquisition close the image display.','Starting Acquisition')    
disp('Starting acquisition...');
[rc] = andorsdk3functions('AT_Command',hndl,'AcquisitionStart');
buf2 = zeros(width,height);
%h=imagesc(buf2);
 scale = buf2 ./ prctile(double(buf2(:)), 99.99);
 h = imshow(scale);
while(get(0,'CurrentFigure'))
    [rc] = andorsdk3functions('AT_QueueBuffer',hndl,imagesize);
    [rc] = andorsdk3functions('AT_Command',hndl,'SoftwareTrigger');
    [rc,buf] = andorsdk3functions('AT_WaitBuffer',hndl,1000);
    [rc,buf2] = andordataconversion('AT_ConvertMono12PackedToMatrix',buf,height,width);
    set(h,'CData',buf2);
    drawnow;
end
disp('Acquisition complete');
[rc] = andorsdk3functions('AT_Command',hndl,'AcquisitionStop');
[rc] = andorsdk3functions('AT_Close',hndl);
[rc] = andorsdk3functions('AT_FinaliseLibrary');
disp('Camera shutdown');
