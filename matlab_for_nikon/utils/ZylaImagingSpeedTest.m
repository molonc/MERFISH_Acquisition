ti2 = actxserver('Nikon.Ti2.Microscope');
Connect(ti2, 1);
initial_pos = get(ti2, 'iZPOSITION');
start_pos = initial_pos + 200;
[rc] = AT_InitialiseLibrary();
[rc,hndl] = AT_Open(0);


[rc] = AT_SetBool(hndl,'SensorCooling',1);
[rc] = AT_SetEnumString(hndl,'SimplePreAmpGainControl','12-bit (high well capacity)');
[rc] = AT_SetEnumString(hndl,'PixelEncoding','Mono12');
[rc] = AT_SetEnumString(hndl,'ElectronicShurtteringMode', 'Global');
[rc] = AT_SetEnumString(hndl,'CycleMode','Continuous');
[rc] = AT_SetEnumString(hndl,'TriggerMode','Software');
[rc] = AT_SetInt(hndl,'AOIHeight', 2160);
[rc] = AT_SetInt(hndl,'AOIWidth', 2560);
[rc] = AT_SetInt(hndl,'AOITop', 1);
[rc] = AT_SetInt(hndl,'AOILeft', 1);
[rc] = AT_SetFloat(hndl,'ExposureTime', 0.01);
[rc,imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
[rc,height] = AT_GetInt(hndl,'AOIHeight');
[rc,width] = AT_GetInt(hndl,'AOIWidth');
[rc,stride] = AT_GetInt(hndl,'AOIStride'); 
[rc] = AT_Command(hndl,'AcquisitionStart');

tic
%set(ti2,'iTURRET1SHUTTER',1);
for i = 1:5
    
    set(ti2,'iZPOSITION', start_pos);
    set(ti2,'iTURRET1SHUTTER',1);
    [rc] = AT_QueueBuffer(hndl,imagesize);
    [rc] = AT_Command(hndl,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(hndl,1000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    buf2 = imrotate(buf2,90);
    set(ti2,'iTURRET1SHUTTER',0);
    figure,imshow(buf2,[0 4095]);
    start_pos = start_pos - 100;
end
%set(ti2,'iTURRET1SHUTTER',0);
toc
set(ti2,'iZPOSITION',initial_pos);
[rc] =AT_Command(hndl,'AcquistionStop');
[rc_close] = AT_Close(hndl);
[rc_finalize] = AT_FinaliseLibrary();