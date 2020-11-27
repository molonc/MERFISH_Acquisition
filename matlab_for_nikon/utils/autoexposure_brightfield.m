function[] = autoexposure_brightfield(h,handles,ti2)

lower_limit = 3000;
upper_limit = 3500;
lower_bound = 0.01;
upper_bound = 0.2;
correct = 0;

imagesize = handles.imagesize;
height = handles.height;
width = handles.width;
stride = handles.stride;



[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(h,100000);
[rc,current] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
current_exposure = AT_GetFloat(h,'ExposureTime');
current_mean = mean2(current);
if current_mean < lower_limit
    if current_exposure > lower_bound
        lower_bound = current_exposure;
    end
elseif current_mean > upper_limit
    if current_mean < upper_bound
        upper_bound = current_exposure;
    end
else
    disp('Current exposure time is correct');
    correct = 1;
end

while(true)
    if correct == 1
        break;
    end
    [rc] = AT_SetFloat(h,'ExposureTime',lower_bound);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,capture] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    mean_lower = mean2(capture);
    
    [rc] = AT_SetFloat(h,'ExposureTime', upper_bound);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,capture] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    mean_upper = mean2(capture);
    
    exposure_new = ((upper_bound*mean_lower)+(lower_bound*mean_upper))/(mean_upper+mean_lower);
    
    [rc] = AT_SetFloat(h,'ExposureTime',exposure_new);
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,capture] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    mean_new = mean2(capture);
    
    if mean_new < lower_limit
        disp('Underexposed!')
        lower_bound  = exposure_new;
    elseif mean_new > upper_limit
        disp('Overexposed!')
        upper_bound = exposure_new;
    else
        disp('Done!');
        break;
    end
end
    
       
end