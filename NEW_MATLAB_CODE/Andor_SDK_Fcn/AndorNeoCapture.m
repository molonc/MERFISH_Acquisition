function frame = AndorZylaCapture(h,exposure, imagesize, height, width, stride)

%set exposure from ms to s
exposure = exposure;

[rc_ExposureTime] = AT_SetFloat(h,'ExposureTime',exposure);

[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
%[rc] = AT_Command(h,'AcquisitionStart');
[rc,buf] = AT_WaitBuffer(h,900000);
size(buf);
frame = AT_ConvertMono16ToMatrix(buf, height, width, stride);
frame = imrotate(frame,90);

%[rc] = AT_Command(h,'AcquisitionStop');

    
end