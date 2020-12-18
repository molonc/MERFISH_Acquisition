function [] = autofocusZyla(h,handles, ti2, step, foc, preview, lamp, exposure)
        ti2.set('iDIA_LAMP_Pos', lamp)
        %[rc] = AT_SetFloat(h,'ExposureTime',0.06);%%%540
      %  [rc] = AT_SetFloat(h,'ExposureTime',exposure);%%%600

        oldFM = 0;
        FOFFSET = 15;
        stepswitch = 0;

        disp('Focusing...')
%         [rc,imagesize] = AT_GetInt(h,'ImageSizeBytes');
%         [rc,height] = AT_GetInt(h,'AOIHeight')
%         [rc,width] = AT_GetInt(h,'AOIWidth')
%         [rc, stride] = AT_GetInt(h, 'AOIStride');
%         %[rc] = AT_SetEnumString(h,'CycleMode','Continuous');
%         %[rc] = AT_SetEnumString(h,'TriggerMode','Software');
%         
%         [rc] = AT_Command(h,'AcquisitionStart'); 
        %buf = zeros(width,height);
        imagesize = handles.imagesize;
        height = handles.height;
        width = handles.width;
        stride = handles.stride;
        %start_time = clock;
        %total_timePast = start_time(4)*3600 + start_time(5)*60 +start_time(6)-handles.initialTime;
     %   [rc] = AT_SetFloat(h,'ExposureTime',0.01);
        while(true)
%tic    
        %set(handles.ti2,'iTURRET1SHUTTER',1);
        [rc] = AT_QueueBuffer(h,imagesize);
        [rc] = AT_Command(h,'SoftwareTrigger');
        [rc,buf] = AT_WaitBuffer(h,100000);
        %[rc,frame] = AT_ConvertMono12PackedToMatrix(buf,height,width);
        [rc,frame] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
      %  set(handles.ti2,'iTURRET1SHUTTER',0);
        %start2_time = clock;
        %current_time = start2_time(4)*3600 + start2_time(5)*60 +start2_time(6);
        %total_timePast = total_timePast + current_time -start_time(4)*3600 - start_time(5)*60 -start_time(6); 
        frame = imrotate(frame,90)*16;%/exp(photobleach*total_timePast);
        %frame = AT_ConvertMono16ToMatrix(buf,height,width,stride);
        %imshow(frame);


%toc

%          C = hist(double(frame(:)), 65536);
%          prcImage = sum(C(1:50000)) / numel(frame);%%%%
%          if(prcImage < 0.01)
%              break;
%          end
%tic
        %FM = fmeasure(frame, 'GRAS', []);%%%%22ms
        %FM = fmeasure(frame, 'BREN', []);
        FM = fmeasure(frame, 'GDER', []);
%toc
%tic
%         FOFFSET = 1000;%(FM -oldFM)/oldFM;
        disp(['FOCUS: ', num2str(FM)])
        set(preview,'CData',frame);
        drawnow;
%toc
%tic
        if(stepswitch >= 2)
            disp('Focus Complete.')
            break;
        elseif ((FM - oldFM) +FOFFSET > 0 )

            Advance

        elseif ((FM - oldFM) +FOFFSET < 0)
            step = step * -1;
            stepswitch = stepswitch + 1;%%%%
            disp('First Switch')
            
            Advance

        end
%toc
        end

        %[rc] = AT_SetEnumString(h,'CycleMode','Fixed');
        %[rc] = AT_SetEnumString(h,'TriggerMode','Internal');

    function Advance

                pos = ti2.get('iZPOSITION');
                pos = pos + step;
              
               
                ti2.set('iZPOSITION',pos)
                pause(0.05)
                oldFM = FM;
    end


        
end