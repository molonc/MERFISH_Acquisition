function []= autoExposureControlZyla(h,handles,ETlower,ETupper,photobleach)
sb_status = strcmp(get(handles.blue_pushbutton, 'String'),'Off');
sg_status = strcmp(get(handles.green_pushbutton, 'String'),'Off');
sr_status = strcmp(get(handles.red_pushbutton, 'String'), 'Off');
sir_status = strcmp(get(handles.ir_pushbutton, 'String'),'Off');

%Determine which laser is operatingma
%Set exposure time boundary for the right laser
if sb_status == 1
    laser = 1;
    lower_bound = ETlower(1);
    upper_bound = ETupper(1);
elseif sg_status == 1
    laser = 2;
    lower_bound = ETlower(2);
    upper_bound = ETupper(2);
elseif sr_status == 1
    laser = 3;
    lower_bound = ETlower(3);
    upper_bound = ETupper(3);
elseif sir_status == 1 
    laser = 4;
    lower_bound = ETlower(4);
    upper_bound = ETupper(4);
else
    lower_bound = 0.01;
    upper_bound = 0.1;
end

if (sb_status == 1||sg_status == 1||sr_status ==1|| sir_status == 1)
%Capture an image with current exposure time
%Determine if the current image is underexposed/overexposed/correct_exposed
imagesize = handles.imagesize;
height = handles.height;
width = handles.width;
stride = handles.stride;
set(handles.ti2,'iTURRET1SHUTTER',1);
[rc ,current_exposure] = AT_GetFloat(h,'ExposureTime');
[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(h,100000);
[rc,current] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
set(handles.ti2,'iTURRET1SHUTTER',0);
%start_time = clock;
%total_timePassed = start_time(4)*3600+start_time(5)*60+start_time(6)-handles.initialTime;
expo_mea = 0;

if mean2(current) < 400
    disp('underexposed');
    lower_bound = current_exposure;%if image is overexposed, set current expsure time to be upper limit
elseif mean2(current)>1000
    disp('overexposed');
    upper_bound = current_exposure;%if image is underexposed, set current expsure time to be lower limit
else
    expo_mea = 1;
end



while(true)
    if expo_mea == 1 %break if the current exposure time is correct
        break;
    end
    %start_time = clock;
    %current_time = start_time(4)*3600+start_time(5)*60+start_time(6);
    [rc] = AT_SetFloat(h,'ExposureTime',lower_bound);
    set(handles.ti2,'iTURRET1SHUTTER',1);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iTURRET1SHUTTER',0);

    %start_time  = clock;
    %current2_time = start_time(4)*3600+start_time(5)*60+start_time(6);
    %total_timePassed = total_timePassed + (current2_time-current_time);
    %buf2 = buf2/exp(photobleach*total_timePassed);
    mean_lower = mean2(buf2);
    
    
    [rc] = AT_SetFloat(h,'ExposureTime',upper_bound);
    set(handles.ti2,'iTURRET1SHUTTER',1);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf3] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iTURRET1SHUTTER',0);
%     start_time = clock;
%     current3_time = start_time(4)*3600+start_time(5)*60+start_time(6);
%     total_timePassed = total_timePassed + (current3_time - current2_time);
%     buf3 = buf3/exp(photobleach*total_timePassed);
    mean_upper = mean2(buf3);
    %Find new exposure time
    ETnew = ((upper_bound*mean_lower)+(lower_bound*mean_upper))/(mean_upper+mean_lower)
    if ETnew < 0.01
        break;
    end
    
    [rc] = AT_SetFloat(h,'ExposureTime',ETnew);
    set(handles.ti2,'iTURRET1SHUTTER',1);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf4] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iTURRET1SHUTTER',0);

   % start_time = clock;
%     current4_time = start_time(4)*3600+start_time(5)*60+start_time(6);
%     total_timePassed = total_timePassed + (current4_time - current3_time); 
%     buf4 = buf4/exp(photobleach*total_timePassed);
    mean_new = mean2(buf4);
    if mean_new < 400
        disp('UnderExposed');
        lower_bound = ETnew;
    elseif mean_new > 1000
        disp('OverExposed');
        upper_bound = ETnew;
    else
        break;
    end
end
else
imagesize = handles.imagesize;
height = handles.height;
width = handles.width;
stride = handles.stride;
[rc ,current_exposure] = AT_GetFloat(h,'ExposureTime');
[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(h,100000);
[rc,current] = AT_ConvertMono16ToMatrix(buf,height,width,stride);

expo_mea = 0;
current_mean = mean2(current)
if mean2(current) < 2200
    disp('underexposed');
    lower_bound = current_exposure;%if image is overexposed, set current expsure time to be upper limit
elseif mean2(current)>3200
    disp('overexposed');
    upper_bound = current_exposure;%if image is underexposed, set current expsure time to be lower limit
else
    expo_mea = 1;
end




while(true)
    if expo_mea == 1 %break if the current exposure time is correct
        break;
    end
    
    [rc] = AT_SetFloat(h,'ExposureTime',lower_bound);
    
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    
    mean_lower = mean2(buf2);
    
    
    [rc] = AT_SetFloat(h,'ExposureTime',upper_bound);
    
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf3] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    
    mean_upper = mean2(buf3);
    %Find new exposure time
    ETnew = ((upper_bound*mean_lower)+(lower_bound*mean_upper))/(mean_upper+mean_lower)
    if ETnew < 0.01
        break;
    end
    
    [rc] = AT_SetFloat(h,'ExposureTime',ETnew);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf4] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    
    
    mean_new = mean2(buf4);
    if mean_new < 2200
        disp('UnderExposed');
        lower_bound = ETnew;
    elseif mean_new > 3200
        disp('OverExposed');
        upper_bound = ETnew;
    else
        break;
    end
end    
end

  
end