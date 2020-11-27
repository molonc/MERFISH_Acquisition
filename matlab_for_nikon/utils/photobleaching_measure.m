function[] = photobleaching_measure(handles)
imagesize = handles.imagesize;
height = handles.height;
width = handles.width;
stride = handles.stride;
set(handles.ti2,'iTURRET1SHUTTER',1);
mean_val = zeros(1,10);
[rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
[rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,1000);
[rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
 mean_val(1)= mean2(buf2);
for j = 1:numel(handles.laser_wavelength)
    switch_laser(j);
    
for i = 1:9
    current_time = clock;
    pause(2);
    [rc] = AT_QueueBuffer(hndl,imagesize);
    [rc] = AT_Command(hndl,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(hndl,1000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    %current2_time = clock;
    %time_passed = current2_time - current_time;
    %time_passed = time_passed(4)*3600 + time_passed(5)*60 + time_passed(6);
    %total_timePassed = total_timePassed + time_passed;
    %buf2 = buf2/ exp(-0.008349*total_timePassed);
    mean_val(i+1)= mean2(buf2);
end

set(handles.ti2,'iTURRET1SHUTTER',0);
x = [0 2 4 8 10 12 14 16 18 20];
f = fit(x',mean_val','exp1');
handles.photobleach(j) = f.b;
end
end
