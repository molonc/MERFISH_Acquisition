function []= autoExposureZyla(h,iExposure)
%Take an initial image
[rc] = AT_SetFloat(h,'ExposureTime',iExposure);
[rc,imagesize] = AT_GetInt(h,'ImageSizeBytes');
[rc,height] = AT_GetInt(h,'AOIHeight');
[rc,width] = AT_GetInt(h,'AOIWidth');
[rc, stride] = AT_GetInt(h, 'AOIStride');

[rc] = AT_Command(h,'AcquisitionStart');
[rc] = AT_QueueBuffer(h,imagesize);
[rc] = AT_Command(h,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(h,900000);
[rc,buf2] = AT_ConvertMono16ToMatrix(buf, height, width,stride);
%h=figure,imshow(uint16(buf2));
if (mean2(buf2)>65000)
    iExposure = iExposure * 0.5;
    [rc] = AT_SetFloat(h,'ExposureTime',iExposure);
    [rc,imagesize] = AT_GetInt(h,'ImageSizeBytes');
    [rc,height] = AT_GetInt(h,'AOIHeight');
    [rc,width] = AT_GetInt(h,'AOIWidth');
    [rc, stride] = AT_GetInt(h, 'AOIStride');
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,1000000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf, height, width,stride);
end

if (mean2(buf2)<15000)
    iExposure = iExposure *2;
    [rc] = AT_SetFloat(h,'ExposureTime',iExposure);
    [rc,imagesize] = AT_GetInt(h,'ImageSizeBytes');
    [rc,height] = AT_GetInt(h,'AOIHeight');
    [rc,width] = AT_GetInt(h,'AOIWidth');
    [rc, stride] = AT_GetInt(h, 'AOIStride');
    [rc] = AT_QueueBuffer(h,imagesize);
    [rc] = AT_Command(h,'SoftwareTrigger');
    [rc,buf] = AT_WaitBuffer(h,1000000);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf, height, width,stride);
end


MSV_lim = 4.55;% mean sample value(MSV) of the image when it has the correct exposure
%create histogram for image and divide it into four regions
val= hist(double(buf2(:)),400);
x= [sum(val(1:100)) sum(val(101:200)) sum(val(201:300)) sum(val(301:400))];

    
%calculate mean sample value(MSV) of the current image
for i = 1:4
    topfact(i) = (i+1)* x(i);
end
MSV_cal = sum(topfact)/sum(x)
newExposure = iExposure;
%overexposed when calculated MSV greater than desire MSV
%underexposed when calculated MSV smaller than desire MSV
if (abs(MSV_cal- MSV_lim)>0.1)
    while (true)
%         if newExposure > 0.2
%             break;
%         end
%         if newExposure < 0.01
%             break;
%         end
        if (abs(MSV_cal- MSV_lim)<0.01)
            break;
        else
            if (MSV_cal > MSV_lim)
                if (MSV_cal - MSV_lim) > 0.05
                    disp('OverExposed');
                    newExposure = newExposure *0.8
                else
                    disp('OverExposed');
                    newExposure = newExposure *0.9
                end
            else
                if (MSV_lim - MSV_cal) > 0.05
                    disp('UnderExposed');
                    newExposure = newExposure *1.2
                else
                    disp('UnderExposed');
                    newExposure = newExposure *1.1
                end
            end
        end
        
        [rc] = AT_SetFloat(h,'ExposureTime',newExposure);
        [rc,imagesize] = AT_GetInt(h,'ImageSizeBytes');
        [rc,height] = AT_GetInt(h,'AOIHeight');
        [rc,width] = AT_GetInt(h,'AOIWidth');  
        [rc, stride] = AT_GetInt(h, 'AOIStride');
        [rc] = AT_QueueBuffer(h,imagesize);
        [rc] = AT_Command(h,'SoftwareTrigger');
        [rc,buf] = AT_WaitBuffer(h,1000000);
        [rc,buf2] = AT_ConvertMono16ToMatrix(buf, height, width,stride);
        val= hist(double(buf2(:)),400);
        x= [sum(val(1:100)) sum(val(101:200)) sum(val(201:300)) sum(val(301:400))];
        for i = 1:4
            topfact(i) = (i+1)* x(i);
        end
        MSV_cal = sum(topfact)/sum(x)
    end
end
[rc] = AT_Command(h,'AcquisitionStop');
end
    
% [rc] = AT_SetFloat(handles.AndorNeoParamHandle,'ExposureTime',newExposure);
% [rc] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
% [rc] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
% [rc,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,1000000);
% [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
% figure, imshow(uint16(buf2));
% [rc] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');