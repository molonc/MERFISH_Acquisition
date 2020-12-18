function [hObject, eventdata, handles] = MERFISH_speed(hObject, eventdata, handles)
%{ 
Main function to run the MERFISH experiment.
Workflow:
- initialization
- loop through hybridization rounds
    - inject fluids
    - loop through each tile
        - go to tile
        - loop through each stack
            - go to stack position
            - loop through each laser
                - take image
%}

%%% HELPER FUNCTIONS %%%

    function [hObject, handles] = setExposure(hObject, handles, wavelength)
        %{ 
        Helper function to set exposure of the selected laser channel.
        Return: none
        %}
        switch wavelength
            case 473
                set(handles.filter_popupmenu,'Value',1);
                [~] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime',handles.sbexpo);
                set(handles.exposuretime_edit,'String',num2str(handles.sbexpo));
            case 561
                set(handles.filter_popupmenu,'Value',1);
                [~] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime',handles.sgexpo);
                set(handles.exposuretime_edit,'String',num2str(handles.sgexpo));
            case 647
                set(handles.filter_popupmenu,'Value',2);
                pause(0.5);
                [~] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime',handles.srexpo);
                set(handles.exposuretime_edit,'String',num2str(handles.srexpo));
            case 750
                pause(1);
                set(handles.filter_popupmenu,'Value',1);
                [~] = AT_SetFloat(handles.AndorNeoParamHandle, 'ExposureTime',handles.sirexpo);
                set(handles.exposuretime_edit,'String',num2str(handles.sirexpo));
        end
        
        guidata(hObject, handles);
    end


    function [hObject, handles] = getPrestitchIndex(hObject, handles, laser_selection, numberOfLaser)
        %{ 
        Helper function to get prestitch index from the number of selected
        lasers.
        Return as a handle property.
        %}
        switch laser_selection
            case '473'
                handles.prestitch_index = 1;
            case '750'
                if numberOfLaser == 1
                    handles.prestitch_index = 1;
                else
                    handles.prestitch_index = 2;
                end
            case '647'
                if numberOfLaser == 1
                    handles.prestitch_index = 1;
                elseif numberOfLaser == 2
                    handles.prestitch_index = 2;
                else
                    handles.prestitch_index = 3;
                end
        end
        guidata(hObject,handles);
    end


    function laser_selection = getLaserSelection(numberOfLaser, laser_wavelength)
        %{ 
        Helper function to prompt user to select laser channel for
        pre-stitch image.
        Return the index of the selected laser.
        %}
        switch numberOfLaser
        case 1
            laser_selection = questdlg('Select a channel for pre-stitch image:','Channel Selection',num2str(laser_wavelength(1)),num2str(laser_wavelength(1)));
        case 2
            laser_selection = questdlg('Select a channel for pre-stitch image:','Channel Selection',num2str(laser_wavelength(1)),num2str(laser_wavelength(2)),num2str(laser_wavelength(1)));
        case 3
            laser_selection = questdlg('Select a channel for pre-stitch image:','Channel Selection',num2str(laser_wavelength(1)),num2str(laser_wavelength(2)),num2str(laser_wavelength(3)),num2str(laser_wavelength(1)));
        case 4
            laser_selection = questdlg('Select a channel for pre-stitch image:','Channel Selection',num2str(laser_wavelength(1)),num2str(laser_wavelength(2)),num2str(laser_wavelength(3)),num2str(laser_wavelength(1)));
        end
    end


    function stage_loc = moveToTile(stage, xpos, ypos)
        %{ 
        Helper function to move to the tile defined by xpos and ypos
        Return the actual stage location after movement.
        %}
        fprintf(stage, ['!moa ',num2str(xpos),' ', num2str(ypos)]);
        fprintf(stage, '?isvel');
        isMoving = fscanf(stage);                               % if stage is moving, it will return some strings
        C = strsplit(isMoving);
        xvel = str2double(C(1));
        yvel = str2double(C(2));
        while((xvel ~= 0 ) || (yvel ~= 0))                      % while it's still moving, continue to move
            fprintf(stage, '?isvel');
            isMoving = fscanf(stage);
            C = strsplit(isMoving);
            xvel = str2double(C(1));
            yvel = str2double(C(2));
            pause(0.01);
        end
        fprintf(stage,'?pos');
        stage_pos = fscanf(stage);
        stage_loc = strsplit(stage_pos);
    end


    function [handles, exposure, ROV, imagesize, height, width, stride] = getImageParams(hObject, handles)
        %{ 
        Helper function to get Andor camera parameters.
        Parameters stored as a property in the returned handle.
        %}
        [~,handles.imagesize] = AT_GetInt(handles.AndorNeoParamHandle,'ImageSizeBytes');
        [~,handles.height] = AT_GetInt(handles.AndorNeoParamHandle,'AOIHeight');
        [~,handles.width] = AT_GetInt(handles.AndorNeoParamHandle,'AOIWidth');
        [~,handles.stride] = AT_GetInt(handles.AndorNeoParamHandle, 'AOIStride');
        [~, exposure] = AT_GetFloat(handles.AndorNeoParamHandle,'ExposureTime');
        [~] = AT_SetEnumString(handles.AndorNeoParamHandle,'SimplePreAmpGainControl','12-bit (high well capacity)');
        [~] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStart');
        [ROV, ~] = size(handles.List);
        imagesize = handles.imagesize;
        height = handles.height;
        width = handles.width;
        stride = handles.stride;
        guidata(hObject, handles);
    end


%     function timeElapsed = getTimeElapsed(startTime, endTime)
%         %{ 
%         Return time elapsed. Similar to getDuration (not sure why there're
%         2 version of them...)
%         %}
%         timeElapsed = -startTime(4)*3600 - startTime(5)*60 - startTime(6) + endTime(4)*3600 + endTime(5)*60 + endTime(6);
%     end


    function duration = getDuration(time_begin, time_end)
        %{ 
        Helper function to get the duration of the experiment.
        Return: double
        %}
        duration = 3.152E7*(time_end(1)-time_begin(1))+2.628E6*(time_end(2)-time_begin(2))+86400*(time_end(3)-time_begin(3))+3600*(time_end(4)-time_begin(4))+60*(time_end(5)-time_begin(5))+(time_end(6)-time_begin(6));
    end


%%% BEGIN %%%

    % create log file
    handles.logfile = fopen(fullfile(pwd, 'merlog.txt'), 'w');
    if handles.logfile == -1
        error('Cannot open log file.');
    end
    
    fprintf(handles.logfile, '%s: 5s\r\n', datestr(now, 0), 'Starting MERFISH run');
    [handles.sampleID,handles.xenoID,handles.library,handles.libraryPrep,handles.digestionBuffer,handles.digestionTime,handles.expansion,handles.exp_date,handles.readout,handles.concentration,handles.collectorID] = experiment_2info();
    guidata(hObject, handles);
    pause(0.5);

    handles.Isfocus = get(handles.focus_checkbox,'Value');
    laser_wavelength_list = [473 750 647 561];
    set(handles.ti2,'iTURRET1SHUTTER',1);
    laser_checklist = [handles.blue_check handles.ir_check handles.red_check handles.green_check];
    index = laser_checklist > 0;
    laser_wavelength = laser_wavelength_list(index);

    numberOfLaser = size(laser_wavelength,2);
    set(handles.ti2,'iLIGHTPATH',4);
    laser_selection = getLaserSelection(numberOfLaser, laser_wavelength);
    [hObject, handles] = getPrestitchIndex(hObject, handles, laser_selection, numberOfLaser);

    % getting imaging parameters from camera
    [handles, exposure, ROV, imagesize, height, width, stride] = getImageParams(hObject, handles);
    
    % output directory configuration
    dname2 = handles.dname2;
    slide_number = get(handles.slidename_edit,'String');
    path = fullfile(dname2, slide_number);
    if not(exist(path,'dir'))
        disp(['Creating new directory at ', path]);
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Creating new directory at ', path]);
        mkdir(path);
    else
        disp(['Using existing directory at ', path]);
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Using existing directory at ', path]);
    end

    % write to excel file
    tilelabel = get(handles.tilename_edit,'String');
    writeRegions(handles.List, path, tilelabel)

    % fill 30mL syringe with cleavage solution (initialization)
    fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Filling up clevage syringe');
    disp('Filling up cleavage syringe');
    handles = cleavage_init(handles, handles.mega, handles.MVP, handles.MVP2);
    fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Finished filling up syringe');
    disp('Finished filling up syringe');

    % start the timer
    time_begin = clock;
%     startTime = clock;            % not sure why there's a second timer

    for r=1:ROV                                                 % don't have to care about this for now, this is for multiple ROVs
        if(ROV>1)
            tilename = [tilelabel,  '_', num2str(r),];
        else
            tilename = tilelabel;
        end
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Acquiring tile ', tilename]);

%         exposure_Initial = zeros(1,numel(laser_wavelength));
        exposure_switch = get(handles.autoexpo_checkbox,'Value');
        handles.isfluidic = get(handles.fluidic_checkbox,'Value');

        for hybrid_round = 1:handles.hybridization_rounds       % don't have to care about this for now, this is for multiple ROVs
            disp(['Hybrid round #',num2str(hybrid_round)]);
            fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Hybrid round #', num2str(hybrid_round)]);

            num_of_fluid = handles.hybridization_fluid;
            disp(['Round of hybridization:',num2str(num_of_fluid+1)]);
            fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Round of hybridization: ',num2str(num_of_fluid+1)]);
            fluid_round = handles.hybridization_fluid + 1;
            
            
            % loop through each hybridization fluid
            for number_fluid = handles.startRun:fluid_round
                set(handles.ti2,'iZEscape',1);
                disp(['Fluid round',num2str(fluid_round)]);   
                disp(['Fluid #',num2str(number_fluid-1)]);
                fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0),['Fluid round ', num2str(fluid_round)]);
                fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Fluid #', num2str(number_fluid-1)]);
                
                k = 1;
                counting = 0;
                valve_pos = (number_fluid - 1);
                if handles.isfluidic == 1
                    if hybrid_round == 1 &&  number_fluid == 2
                        disp('No on stage hybridization');
                        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'No on-stage hybridization');
                    else
                        % activate fluidics
                        handles = MERFISH_hybridization(handles, handles.mega, handles.MVP, handles.MVP2, handles.MVP3, valve_pos, get(handles.mega, 'wash_t'), get(handles.mega, 'hybrid_t'), get(handles.mgea, 'img_t'));
                        disp('Complete fluid transfer!');
                        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Completed fluid transfer');
                        pause(10);                                              % why pause?
                    end        
                end
                
                % prepare to capture image

                set(handles.ti2,'iZEscape',0);

                resX = handles.resX;
                resY = handles.resY;

%                 X = width;
%                 Y = height;

                % show FOV window
                figure('MenuBar', 'none','ToolBar', 'none', 'Name', 'PreView');
                set(gca,'units','pixels');                                      % set the axes units to pixels
                x = get(gca,'position');                                        % get the position of the axes
                set(gcf,'units','pixels');                                      % set the figure units to pixels
                y = get(gcf,'position');                                        % get the figure position
                set(gcf,'position',[y(1) y(2) x(3) x(4)])                       % set the position of the figure to the length and width of the axes
                set(gca,'units','normalized','position',[0 0 1 1])              % set the axes units to pixels
                set(gcf, 'OuterPosition', [0 resY-(height+30) width height+30])
                handles.preview = imshow(uint16(zeros(height, width)), [0 65535]);
                xx = 0;
                yy = 0;
                FOVx = handles.FOVx;
                FOVy = handles.FOVy;
                overlapx = 10;
                overlapy = 10;
                [handles, IXpos, IYpos, Xnum, Ynum] = getTiles(handles, r,FOVx,FOVy,overlapx,overlapy);
                if rem(max(Xnum,Ynum),2)==0
                    ITR = (max(Xnum, Ynum)+1) ^ 2;
                else
                    ITR = max(Xnum,Ynum)^2;
                end
                dx = 0;
                dy = -1;
                %Set begining tile location
                ItileX = ceil(Xnum/2);
                ItileY = ceil(Ynum/2);

                loc_report = zeros(Xnum*Ynum,(5+handles.planeNum));

                handles.mapview = figure('MenuBar', 'none','ToolBar', 'none', 'Name', 'MapView');
                set(gca,'units','pixels');                                      % set the axes units to pixels
                x = get(gca,'position');                                        % get the position of the axes
                set(gcf,'units','pixels');                                      % set the figure units to pixels
                y = get(gcf,'position');                                        % get the figure position
                set(gcf,'position',[y(1) y(2) x(3) x(4)]);                      % set the position of the figure to the length and width of the axes
                set(gca,'units','normalized','position',[0 0 1 1]);             % set the axes units to pixels
                set(gcf, 'OuterPosition', [resX/2 50 resX/2 resY-50]);
                movegui(handles.mapview,'northwest');

                % 16bit map
                handles.map = zeros(height*Ynum, width*Xnum, 'uint16');
                handles.mapview = imshow(handles.map, [0 65535]);
                size(handles.map)

                %create map for 647nm and 750nm
                handles.map_647 = zeros(height*Ynum, width*Xnum,'uint16');
                handles.map_750 = zeros(height*Ynum, width*Xnum,'uint16');
                
                
                % loop through each tile
                for itr=1:ITR
                    Z_arr = zeros(handles.planeNum,1);

                    if ( ( -(Xnum/2) <= xx ) && ( xx < (Xnum/2)) && (-(Ynum/2) <= yy ) && ( yy < (Ynum/2) ) )

                        counting = counting + 1;
                        
                        % calcualte stage location
                        handles.xpos = (FOVx-overlapx)*xx + IXpos;
                        handles.ypos = (FOVy-overlapy)*yy + IYpos;

                        disp(['Stage Location: X=', num2str(handles.xpos),' Y=', num2str(handles.ypos)]);
                        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0),['Stage Location: X = ', num2str(handles.xpos), ' Y = ', num2str(handles.ypos)]);
                        
                        % move to tile with position (xpos, ypos)
                        stage_loc = moveToTile(handles.s2, handles.xpos, handles.ypos);
                        set(handles.xpos_edit,'String',stage_loc(1));
                        set(handles.ypos_edit,'String',stage_loc(2));

                        handles.IsThreeDimensional = get(handles.three_dimensional_checkbox,'Value');
                        if handles.IsThreeDimensional == 0                          % Check if 3 dimensional imaging is requested
                            handles.planeNum = 1;
                            guidata(hObject,handles);
                        end
                        
                        % what are the other options?
                        switch exposure_switch
                            case 0
                                disp('Constant exposure time!');
                                fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Constant exposure time');
                        end
                        
                        
                        % loop through each stack
                        for Z_stack = 1: handles.planeNum                           %for 3 dimensional imaging
                            
                            % loop through each laser
                            for laserIndex = 1:numel(laser_wavelength)              %run each laser at every single image plane
                                set(handles.ti2,'iSHUTTER_EPI',1);
                                wavelength = laser_wavelength(laserIndex);
                                disp(['Laser Wavelength: ',num2str(wavelength)]);
                                fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0),['Laser Wavelength: ', num2str(wavelength)]);

                                % turn on laser
                                [hObject, handles] = switch_laser(hObject, handles,wavelength);
                                if exposure_switch == 0         % constant exposure time
                                    [hObject, handles] = setExposure(hObject, handles, wavelength);
                                end

                                if laser_wavelength(laserIndex) == 561 || laser_wavelength(laserIndex) == 750  
                                    pause(1);       % 561nm laser takes a second to start up
                                end

                                % autofocus
                                if Z_stack == 1  && laserIndex == 1 && handles.IsThreeDimensional == 0
                                    if handles.Isfocus == 1 && counting == 1                    
                                        [handles] = autofocusImgTiling(handles);        % initial focus
                                        handles.currentFocusPos = get(handles.ti2,'iZPOSITION');                       
                                    end
                                else
                                    if handles.IsThreeDimensional == 1          %Check if 3 dimensional imaging is requested
                                        if Z_stack == 1 && laserIndex == 1
                                            if counting == 1
                                                [handles] = autofocusImgTiling(handles);        % initial focus for the first time of each round
                                            else
                                                [handles] = autofocusSecondary(handles);        % small adjustment for subsequent tiles of the current round
                                            end
                                            handles.currentFocusPos = get(handles.ti2,'iZPOSITION');
                                            startPos = handles.currentFocusPos + (handles.upperStepSize*(handles.upperPlaneNum-1));
                                            set(handles.ti2,'iZPOSITION', startPos);
                                        end
                                    end
                                end

                                Z_drive_loc = get(handles.ti2,'iZPOSITION');
                                Z_arr(Z_stack, 1) = Z_drive_loc;

                                image_filepath_2 = [path,'\',tilename,'\' num2str(laser_wavelength(laserIndex)),'nm, Raw\'];
                                if not(exist(image_filepath_2,'dir'))
                                    mkdir(image_filepath_2);
                                end

                                % capture image
                                set(handles.ti2,'iSHUTTER_EPI',1);

                                [~] = AT_QueueBuffer(handles.AndorNeoParamHandle,imagesize);
                                [~] = AT_Command(handles.AndorNeoParamHandle,'SoftwareTrigger');
                                [~,buf] = AT_WaitBuffer(handles.AndorNeoParamHandle,100000);
                                [~,frame] = AT_ConvertMono16ToMatrix(buf,height,width,stride);

                                pause(exposure);        % pause for exposure time
                                frame = imrotate(frame,90)*16;
                                set(handles.preview,'CData',frame);
                                drawnow;
                                
                                % format the numeral string in output image
                                % file
                                
                                hybrid_num = hybrid_round * number_fluid;
                                hybrid_str = num2str(hybrid_num, '%02.f');
                                counting_str = num2str(counting, '%03.f');
                                Z_stack_str = num2str(Z_stack, '%02.f');            

                                if handles.IsThreeDimensional==1
                                        file_name3 = ['merFISH_',hybrid_str,'_',counting_str,'_',Z_stack_str,'.TIFF'];
                                        switch laserIndex
                                            case 1
                                                    handles.z_stack_img1(:,:,Z_stack) = frame;
                                            case 2
                                                    handles.z_stack_img2(:,:,Z_stack) = frame;
                                            case 3
                                                    handles.z_stack_img3(:,:,Z_stack) = frame;
                                            case 4
                                                    handles.z_stack_img4(:,:,Z_stack) = frame;
                                        end

                                        if  laserIndex == 1
                                            if Z_stack > handles.lowerPlaneNum
                                                startPos = startPos - handles.lowerStepSize;
                                                pause(0.5);
                                            else
                                                startPos = startPos - handles.upperStepSize;
                                                pause(0.5);
                                            end 

                                        end
                                        set(handles.ti2, 'iZPOSITION', startPos);

                                else
                                    file_name3 = ['merFISH_',hybrid_str,'_',counting_str,'.TIFF'];
                                    handles.raw(:,:,laserIndex) = frame;                                        
                                end

                                imwrite(frame,fullfile(image_filepath_2, file_name3));
                            end
                        end

                        set(handles.ti2,'iZposition',handles.currentFocusPos);
                        loc_report(counting,:) = [counting xx yy handles.xpos handles.ypos Z_arr(:,1)'];
                        if handles.IsThreeDimensional == 1
                            handles.raw(:,:,1) = handles.z_stack_img1(:,:,ceil(handles.planeNum/2));

                            if numel(laser_wavelength) > 1
                                handles.raw(:,:,2) = handles.z_stack_img2(:,:,ceil(handles.planeNum/2));

                                if numel(laser_wavelength) > 2
                                    handles.raw(:,:,3) = handles.z_stack_img3(:,:,ceil(handles.planeNum/2));

                                    if numel(laser_wavelength) > 3
                                        handles.raw(:,:,4) = handles.z_stack_img4(:,:,ceil(handles.planeNum/2));  
                                    end
                                end
                            end
                        end

                        if ((ItileY-yy)~=0 && (ItileX-xx)~=0)
                            handles.map((((ItileY-yy)*height)-height +1):((ItileY-yy)*height ), (((ItileX-xx)*width)-width+1 ):((ItileX-xx)*width) ) = handles.raw(:,:,handles.prestitch_index);

                            if handles.red_check == 1 && handles.ir_check == 1
                                handles.map_647((((ItileY-yy)*height)-height +1):((ItileY-yy)*height ), (((ItileX-xx)*width)-width+1 ):((ItileX-xx)*width) ) = handles.raw(:,:,2);
                                handles.map_750((((ItileY-yy)*height)-height +1):((ItileY-yy)*height ), (((ItileX-xx)*width)-width+1 ):((ItileX-xx)*width) ) = handles.raw(:,:,3);
                            end

                            set(handles.mapview,'CData',handles.map);

                            drawnow;
                            handles.raws = [];
                        end

                        %%Image flat
                        %flatCapture           
                        k = k+1;
                    end

                    if(xx == yy || (xx < 0 && xx == -yy) || (xx > 0 && xx == 1 - yy))
                        tempdx = dx;
                        tempdy = dy;
                        dx = -1 * tempdy;
                        dy = tempdx;
                        clear tempdx tempdy
                    end
                    xx = xx + dx;
                    yy = yy + dy;

                end
                
                % turn off laser
                [hObject, handles] = switch_laser(hObject, handles,0);

                close('MapView');
                close('PreView');
                hold all;

                drawnow;
                disp('Tile Capture Complete!')
                fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Tile capture completed');

                % save tile images
                filename1 = [slide_number, '-', tilename, 'fluid#', num2str(number_fluid),'-Prestiched.TIFF'];
                filepath1 = fullfile(dname2, slide_number, tilename, filename1);
                imwrite(handles.map, filepath1);
                
                filename2 = [slide_number,'-',tilename,'fluid#',num2str(number_fluid),'-647nm Prestiched.TIFF'];
                filepath2 = fullfile(dname2, slide_number, tilename, filename2);
                imwrite(handles.map_647, filepath2); 
                
                filename3 = [slide_number,'-',tilename,'fluid#',num2str(number_fluid),'-750nm Prestiched.TIFF'];
                filepath3 = fullfile(dname2, slide_number, tilename, filename3);
                imwrite(handles.map_750, filepath3);
                
                % re-initialize the maps
                handles.flats = [];         % not sure what this is
                handles.correct = [];       % not sure what this is
                handles.map = [];
                handles.map_647 = [];
                handles.map_750 = [];

                % cleavage
                if handles.isfluidic == 1
                    if number_fluid < fluid_round
                        set(handles.ti2,'iZEscape',1);
                        disp('Cleavage starting');
                        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Cleavage starting');
                        handles = MERFISH_cleavage(handles, handles.mega, handles.MVP, handles.MVP2, handles.cleavageTime, handles.cleavageFr);
                        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Cleavage completed');
                        disp('Cleavage completed');
                        set(handles.ti2,'iZEscape',0);         
                    end
                end

                % record stage position to excel
                writeToSheet(handles, loc_report, dname2, slide_number, tilename, number_fluid);
            end
        end
    end
    
    % finished acquisition, clean up and log
    disp('Done')
    fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Completed MERFISH run');
    [~] = AT_Command(handles.AndorNeoParamHandle,'AcquisitionStop');
    [hObject, handles] = switch_laser(hObject, handles,0);
    hold all;

%     endTime = clock;
%     timeElapsed = getTimeElapsed(startTime, endTime);
%     disp(['total time elapsed:',num2str(timeElapsed)]);
%     fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0),['Total time elapsed: ', num2str(timeElapsed)]);
    set(handles.epishutter_pushbutton,'String','EPIShutter_On');

    time_end = clock;
    duration = getDuration(time_begin, time_end);
    reminder_hour = rem(duration,3600);
    reminder_min = rem(reminder_hour,60);
    duration_hour = fix(duration/3600);
    duration_min = fix(reminder_hour/60);
    duration_sec = ceil(reminder_min);
    duration_str = ['Total Duration: ',num2str(duration_hour),'hrs ',num2str(duration_min),'mins ',num2str(duration_sec),'secs'];
    if handles.expansion == 1
        expansion_str = 'YES';
    else
        expansion_str = 'No';
    end   

    reportFileName = fullfile(dname2, slide_number, tilename, 'report.txt');
    fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0),['Writing to report: ', reportFileName]);
    report = fopen(reportFileName,'w');

    fprintf(report,['Sample ID: ',handles.sampleID,'\r\n']);
    fprintf(report,['Xeno ID: ',handles.xenoID, '\r\n']);
    fprintf(report,['Library: ',handles.library,'\r\n']);
    fprintf(report,['Library prep data: ',handles.libraryPrep,'\r\n']);
    fprintf(report,['Date of Imaging: ',handles.exp_date,'\r\n']);
    fprintf(report,['Digestion Buffer: ',handles.digestionBuffer,'\r\n']);
    fprintf(report,['Digestion time: ',handles.digestionTime,'\r\n']);
    fprintf(report,['Expansion: ', expansion_str,'\r\n']);
    fprintf(report,['Readout probes: ',handles.readout,'\r\n']);
    fprintf(report,['Readout probe concentration: ',handles.concentration,'\r\n']);
    fprintf(report,['Lab collector ID: ',handles.collectorID,'\r\n']);
    fprintf(report,['Tile number: ',num2str(Xnum*Ynum),'\r\n']);
    fprintf(report,['Image size: ',num2str(handles.FOVx*handles.FOVy),'um^2','\r\n']);
    fprintf(report,['Total Area of imaging: ',num2str(Xnum*Ynum*handles.FOVx*handles.FOVy),'um^2','\r\n']);
    fprintf(report,['Time for hybridization: 6 mins at 6.4rpm','\r\n']);
    fprintf(report,['Time for cleavaging: 7 mins at 6.4rpm','\r\n']);
    fprintf(report,['Exposure time: 473nm ',num2str(handles.sbexpo),'s','\r\n','561nm ',num2str(handles.sgexpo),'s','\r\n','647nm ',num2str(handles.srexpo),'s','\r\n','750nm ',num2str(handles.sirexpo),'s','\r\n']);
    
    if handles.IsThreeDimensional == 1
        fprintf(report,['3D imaging: ON','\r\n']);
    else
        fprintf(report,['3D imaging: OFF','\r\n']);
    end
    if handles.Isfocus == 1
        fprintf(report,['Autofocus: ON','\r\n']);
    else
        fprintf(report,['Autofocus: OFF','\r\n']);
    end
    fprintf(report,duration_str,'\r\n');
    fclose(report);  
    
    fprint(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Rinsing syringes');
    rinse(handles.mega, handles.MVP2, 5);
    fprint(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Finished rinsing syrintes.'); 

    fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Closing log file');
    fclose(handles.logfile);
    
    guidata(hObject, handles);
end