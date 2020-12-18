disp('Andor SDK3 Single Scan Example');
[rc] = andorsdk3functions('AT_InitialiseLibrary');
[rc,hndl] = andorsdk3functions('AT_Open',0);
disp('Camera initialized');
[rc] = andorsdk3functions('AT_SetFloat',hndl,'ExposureTime',4.2);
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'CycleMode','Fixed');
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'TriggerMode','Internal');
[rc] = andorsdk3functions('AT_SetEnumIndex',hndl,'PreAmpGainControl',5);
[rc] = andorsdk3functions('AT_SetEnumIndex',hndl,'BitDepth',1);
%[rc] = andorsdk3functions('AT_SetEnumIndex',hndl,'SimplePreAmpGainControl',2);
%[rc] = andorsdk3functions('AT_SetEnumString',hndl,'PixelEncoding','Mono12Packed');
[rc] = andorsdk3functions('AT_SetEnumString',hndl,'PixelEncoding','Mono16');
[rc] = andorsdk3functions('AT_SetInt',hndl,'FrameCount',1);

        [rc] = AT_SetInt(hndl,'AOIHeight', 2048);
        [rc] = AT_SetInt(hndl,'AOIWidth', 2048);
        [rc] = AT_SetInt(hndl,'AOITop', 57);
        [rc] = AT_SetInt(hndl,'AOILeft', 257);
        
[rc,imagesize] = andorsdk3functions('AT_GetInt',hndl,'ImageSizeBytes');
[rc,height] = andorsdk3functions('AT_GetInt',hndl,'AOIHeight');
[rc,width] = andorsdk3functions('AT_GetInt',hndl,'AOIWidth');  
[rc, stride] = andorsdk3functions('AT_GetInt',hndl, 'AOIStride');

[rc] = andorsdk3functions('AT_QueueBuffer',hndl,imagesize);
disp('Starting acquisition...');
[rc] = andorsdk3functions('AT_Command',hndl,'AcquisitionStart');
[rc,buf] = andorsdk3functions('AT_WaitBuffer',hndl,30000);

%[rc,buf2] = andordataconversion('AT_ConvertMono12PackedToMatrix',buf,height,width);
%[rc,buf2] = andordataconversion('AT_ConvertMono16ToMatrix',buf,height,width);
buf2 = mono16tomatrix(buf, height, width, stride);

%imagesc(buf2);
mean2(buf2)
%buf2 = double(buf2);
%scale = buf2 ./ prctile(buf2(:), 99.999);
figure, imshow(buf2, [0 66535])
%figure, imshow(buf2, [0 2048])
disp('Acquisition complete');
[rc] = andorsdk3functions('AT_Command',hndl,'AcquisitionStop');
%%
[rc] = andorsdk3functions('AT_Close',hndl);
[rc] = andorsdk3functions('AT_FinaliseLibrary');
%%
disp('Camera shutdown');
