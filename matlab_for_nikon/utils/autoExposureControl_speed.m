function[] = autoExposureControl_speed(h,handles,ETlower,ETupper)
%Check which laser is on
set(handles.ti2,'iSHUTTER_EPI',0);
sb_status = strcmp(get(handles.blue_pushbutton, 'String'),'Off');
sg_status = strcmp(get(handles.green_pushbutton, 'String'),'Off');
sr_status = strcmp(get(handles.red_pushbutton, 'String'), 'Off');
sir_status = strcmp(get(handles.ir_pushbutton, 'String'),'Off');
percent_tile = 0.1; 

ETold = 0;
count = 0;

lower_limit = 0;
upper_limit = 0;
multiplier = 0;
%Determine which laser is operating
%Set exposure time boundary for the each laser
if sb_status == 1
    lower_bound = ETlower(1);
    upper_bound = ETupper(1);
    lower_limit = 1100;
    upper_limit = 1300;
    multiplier = 5;
    max = ETupper(1);
elseif sg_status == 1
    lower_bound = ETlower(2);
    upper_bound = ETupper(2);
    lower_limit = 1100;
    upper_limit = 1300;
    multiplier = 5.5;
    max = ETupper(2);

elseif sr_status == 1
    lower_bound = ETlower(3);
    upper_bound = ETupper(3);
    lower_limit = 1000;
    upper_limit = 1200;
    multiplier = 4.4;
    max = ETupper(3);
elseif sir_status == 1 
    lower_bound = ETlower(4);
    upper_bound = ETupper(4);
    lower_limit = 500;
    upper_limit = 600;
    multiplier = 6.9;
    max = ETupper(4);
else
    lower_bound = 0.01;
    upper_bound = 0.1;
end
disp('Auto-Exposure');
%Capture an image with current exposure time
%Determine if the current image is underexposed/overexposed/correct_exposed
imagesize = handles.imagesize;
height = handles.height;
width = handles.width;
stride = handles.stride;
%set laser power to 1%
%green laser require 14% power to be stable
fprintf(handles.sblue, ['?SLP',dec2hex(floor(0.01*4095))])
fprintf(handles.sgreen,'p 0.025')
if sg_status == 1
    pause(2);
end
fprintf(handles.sred,['?SLP',dec2hex(floor(0.1*4095))])
fprintf(handles.sir,['?SLP', dec2hex(floor(0.1*4095))])
set(handles.blue_edit,'String','1');
set(handles.green_edit,'String','5');
set(handles.red_edit,'String','10');
set(handles.ir_edit,'String','10');


[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(h,100000);
[rc,dark] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
 set(handles.ti2,'iSHUTTER_EPI',1);
 set(handles.epishutter_pushbutton,'String','EPIShutter_Off')
 %pause(0.5);
[rc ,current_exposure] = AT_GetFloat(h,'ExposureTime');
[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(h,100000);
[rc,current] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
set(handles.ti2,'iSHUTTER_EPI',0);
set(handles.epishutter_pushbutton,'String','EPIShutter_On')

matrixSize = 2160*2560;
current = current - dark;
current = sort(current(:));
%take 0.05% of the pixels with the highest value
numberInPercentile = round(numel(current)*(percent_tile/100));


expo_mea = 0;
current_mean_val = mean2(current((matrixSize-numberInPercentile):matrixSize))*multiplier
if current_mean_val < lower_limit
    disp('underexposed');
    lower_bound = current_exposure;%if image is overexposed, set current expsure time to be upper limit
elseif current_mean_val > upper_limit
    disp('overexposed');
    upper_bound = current_exposure;%if image is underexposed, set current expsure time to be lower limit
else
    expo_mea = 1;
    disp('Correct Exposure Time');
end


while(true)
    if expo_mea == 1 %break if the current exposure time is correct
        break;
    end

    [rc] = AT_SetFloat(h,'ExposureTime',lower_bound);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,dark1] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
     set(handles.ti2,'iSHUTTER_EPI',1);
     set(handles.epishutter_pushbutton,'String','EPIShutter_Off')

    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iSHUTTER_EPI',0);
    set(handles.epishutter_pushbutton,'String','EPIShutter_On')
    buf2 = buf2 - dark1;
    buf2 = sort(buf2(:));
    numberInPercentile = round(numel(buf2)*(percent_tile/100));

    mean_lower = mean2(buf2((matrixSize-numberInPercentile):matrixSize))*multiplier
    
    [rc] = AT_SetFloat(h,'ExposureTime',upper_bound);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,dark2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iSHUTTER_EPI',1);
    set(handles.epishutter_pushbutton,'String','EPIShutter_Off')
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf3] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2, 'iSHUTTER_EPI',0);
    set(handles.epishutter_pushbutton,'String','EPIShutter_On')
    buf3 = buf3 - dark2;
    buf3 = sort(buf3(:));
    numberInPercentile = round(numel(buf3)*(percent_tile/100));
    
    mean_upper = mean2(buf3((matrixSize-numberInPercentile):matrixSize))*multiplier
    %Find new exposure time
    ETnew = ((upper_bound*mean_lower)+(lower_bound*mean_upper))/(mean_upper+mean_lower)
    if ETnew < 0.01 || ETnew > (max-0.05)
        break;
    end
    
    [rc] = AT_SetFloat(h,'ExposureTime',ETnew);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,dark3] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iSHUTTER_EPI',1);
    set(handles.epishutter_pushbutton,'String','EPIShutter_Off')
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,100000);
    [rc,buf4] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    set(handles.ti2,'iSHUTTER_EPI',0);
    set(handles.epishutter_pushbutton,'String','EPIShutter_On');
    buf4 = buf4 - dark3;
    buf4 = sort(buf4(:));
    numberInPercentile = round(numel(buf4)*(percent_tile/100));


    mean_new = mean2(buf4((matrixSize-numberInPercentile):matrixSize))*multiplier
    if mean_new < lower_limit
        disp('UnderExposed');
        lower_bound = ETnew
    elseif mean_new > upper_limit
        disp('OverExposed');
        upper_bound = ETnew
    else
        break;
    end
    count = count+1;
    if count == 15 || ETnew == ETold
        break;
    end
    ETold = ETnew;
end
set(handles.ti2,'iSHUTTER_EPI',0);
fprintf(handles.sblue,['?SLP',dec2hex(floor(0.05*4095))])
fprintf(handles.sgreen,'p 0.5')
set(handles.blue_edit,'String','5');
set(handles.green_edit,'String','12');



end