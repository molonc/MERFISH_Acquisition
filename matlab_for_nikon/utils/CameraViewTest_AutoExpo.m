[rc] = AT_InitialiseLibrary();
[rc,hndl] = AT_Open(0);


[rc] = AT_SetBool(hndl,'SensorCooling',1);
[rc] = AT_SetEnumIndex(hndl,'PreAmpGainControl',5);
[rc] = AT_SetEnumIndex(hndl,'PixelEncoding',2);
[rc] = AT_SetEnumIndex(hndl, 'BitDepth', 1);
%[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'CycleMode','Fixed');
%[rc] = AT_SetEnumString(handles.AndorNeoParamHandle,'TriggerMode','Internal');
[rc] = AT_SetEnumString(hndl,'CycleMode','Continuous');
[rc] = AT_SetEnumString(hndl,'TriggerMode','Software');

[rc] = AT_SetInt(hndl,'AOIHeight', 2048);
[rc] = AT_SetInt(hndl,'AOIWidth', 2048);
[rc] = AT_SetInt(hndl,'AOITop', 57);
[rc] = AT_SetInt(hndl,'AOILeft', 257);

[rc,id] = AT_GetEnumIndex(hndl, 'PreAmpGain');
[rc,gain] = AT_GetEnumStringByIndex(hndl, 'PreAmpGain', id, 100);


[rc,id] = AT_GetEnumIndex(hndl, 'TemperatureControl');
[rc,temp] = AT_GetEnumStringByIndex(hndl, 'TemperatureControl', id, 100);


[rc,id] = AT_GetEnumIndex(hndl, 'BitDepth');
[rc,bit] = AT_GetEnumStringByIndex(hndl, 'BitDepth', id, 100);


[rc] = AT_SetFloat(hndl, 'ExposureTime', 0.0);

[rc,imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
[rc,height] = AT_GetInt(hndl,'AOIHeight');
[rc,width] = AT_GetInt(hndl,'AOIWidth');
[rc, stride] = AT_GetInt(hndl, 'AOIStride');
[rc] = AT_Command(hndl,'AcquisitionStart');
[rc] = AT_QueueBuffer(hndl,imagesize);
[rc] = AT_Command(hndl,'SoftwareTrigger');
[rc,buf] = AT_WaitBuffer(hndl,900000);
MSV_lim = 3.58

frame = mono16tomatrix(buf, height, width, stride);
imshow(uint16(frame));
val= hist(double(frame(:)),400);
x= [sum(val(1:100)) sum(val(101:200)) sum(val(201:300)) sum(val(301:400))];
for i = 1:4
    topfact(i) = (i+1)* x(i);
end
MSV_cal = sum(topfact)/sum(x);
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
                if (MSV_cal - MSV_lim) > 0.2
                    disp('OverExposed');
                    newExposure = newExposure *0.5
                else
                    disp('OverExposed');
                    newExposure = newExposure *0.9
                end
            else
                if (MSV_lim - MSV_cal) > 0.2
                    disp('UnderExposed');
                    newExposure = newExposure *1.5
                else
                    disp('UnderExposed');
                    newExposure = newExposure *1.1
                end
            end
        end
        
        [rc] = AT_SetFloat(hndl,'ExposureTime',newExposure);
        [rc,imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
        [rc,height] = AT_GetInt(hndl,'AOIHeight');
        [rc,width] = AT_GetInt(hndl,'AOIWidth');  
        [rc, stride] = AT_GetInt(hndl, 'AOIStride');
        [rc] = AT_QueueBuffer(hndl,imagesize);
        [rc] = AT_Command(hndl,'SoftwareTrigger');
        [rc,buf] = AT_WaitBuffer(hndl,1000000);
        frame = mono16tomatrix(buf, height, width, stride);
        val= hist(double(frame(:)),400);
        x= [sum(val(1:100)) sum(val(101:200)) sum(val(201:300)) sum(val(301:400))];
        for i = 1:4
            topfact(i) = (i+1)* x(i);
        end
        MSV_cal = sum(topfact)/sum(x)
    end
end

[rc] = AT_Command(hndl,'AcquisitionStop');