ti2 = actxserver('Nikon.Ti2.Microscope');
Connect(ti2, 1);
[rc] = AT_InitialiseLibrary();
[rc,hndl] = AT_Open(0);
[rc] = AT_SetFloat(hndl,'ExposureTime',0.1);
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
[rc, imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
[rc, height] = AT_GetInt(hndl,'AOIHeight');
[rc, width] = AT_GetInt(hndl,'AOIWidth');
[rc, stride] = AT_GetInt(hndl, 'AOIStride');

[rc] = AT_Command(hndl,'AcquisitionStart');
[rc] = AT_QueueBuffer(hndl,imagesize);
[rc] = AT_Command(hndl,'SoftwareTrigger');
set(ti2,'iTURRET1SHUTTER',1);

[rc,buf] = AT_WaitBuffer(hndl,900000);
[rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
set(ti2,'iTURRET1SHUTTER',0);

buf2 = imrotate(buf2, 90);
[rc] = AT_Command(hndl,'AcquisitionStop');
figure,imshow(buf2,[0 4095]);

se = strel('rectangle',[2560 2160]);
buf3 = imtophat(buf2,se);
figure,imshow(buf3,[0,4095]);
buf3 = sort(buf3(:));
filter_buf3 = zeros(1,55);
j = numel(buf3)-55;
for i = 1:55
    filter_buf3(i) = buf3(j);
    j = j+1;
end

meanl_val = mean2(filter_buf3)
    

