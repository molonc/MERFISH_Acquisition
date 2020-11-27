function [gain,exp] = startcontinuouslivevideo(mmc)
% % Andor Camera Series
% % 
% % Live video with settings GUI
% % 
% % Recieves java object mmc in order to control the camera [MicroManager API]
% % Returns gain and exposure setting so external GUI can display changes (if exists)

% create GUI window
gain = 0;
exp = 0;

options = figure('Position',[0,0,200,430],'Visible','off','Color',[1 1 1],'MenuBar','none','CloseRequestFcn',@endvid_Callback);
movegui(options,'east');

% static labels
uicontrol('Style','text','String','Display:','Position',[15,360,70,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');
uicontrol('Style','text','String','Binning:','Position',[15,320,70,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');
uicontrol('Style','text','String','Gain:','Position',[15,280,170,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');
uicontrol('Style','text','String','Pre-Amp Gain:','Position',[15,240,170,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');
uicontrol('Style','text','String','Exposure (ms):','Position',[15,200,170,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');
uicontrol('Style','text','String','Readout Freq:','Position',[15,160,170,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');
uicontrol('Style','text','String','Camera Cooling:','Position',[15,120,170,20],'BackgroundColor',[1,1,1],'HorizontalAlignment','left');

% edit boxes
gaintxt = uicontrol('Style','edit','String','','Position',[90,280,40,25],'BackgroundColor',[1,1,1],'Callback',{@gaintxt_Callback});
exptxt = uicontrol('Style','edit','String','','Position',[90,200,70,25],'BackgroundColor',[1,1,1],'Callback',{@exptxt_Callback});
temperaturetxt = uicontrol('Style', 'edit', 'String', '', 'Position', [100,120,40,25], 'BackgroundColor', [1,1,1], 'Callback', {@temperaturetxt_Callback});

% pop-up menus
binchoices = {'1','2','4','8'};
preampchoices = {'1.00','2.40','4.30'};
readoutchoices = {'1.000 MHz','3.000 MHz','5.000 MHz','10.000 MHz'};
displaychoices = {'No Mod','Contrast','Prob','Prob_jet','Diff'};
display = uicontrol('Style','popupmenu','String',displaychoices,'Position',[90,360,80,20],'BackgroundColor',[1,1,1],'Callback',{@display_Callback});
bin = uicontrol('Style','popupmenu','String',binchoices,'Position',[90,320,80,20],'BackgroundColor',[1,1,1],'Callback',{@bin_Callback});
preamp = uicontrol('Style','popupmenu','String',preampchoices,'Position',[90,240,80,20],'BackgroundColor',[1,1,1],'Callback',{@preamp_Callback});
readout = uicontrol('Style','popupmenu','String',readoutchoices,'Position',[90,160,80,20],'BackgroundColor',[1,1,1],'Callback',{@readout_Callback});

% exit button
uicontrol('Style','pushbutton','String','Exit Live Video','Position',[50,80,100,25],'Callback',{@endvid_Callback});

% get current properties of the camera and load them into the GUI
set(gaintxt,'String',char(mmc.getProperty('Andor','Gain')));
set(exptxt,'String',char(mmc.getProperty('Andor','Exposure')));
set(temperaturetxt, 'String', char(mmc.getProperty('Andor', 'CCDTemperatureSetPoint')));

binreal = char(mmc.getProperty('Andor','Binning'));
preampreal = char(mmc.getProperty('Andor','Pre-Amp-Gain'));
readoutreal = char(mmc.getProperty('Andor','ReadoutMode'));
for i=1:4
    if strcmp(cell2mat(binchoices(i)),binreal)
        set(bin,'Value',i);
        break
    end
end
for i=1:3
    if strcmp(cell2mat(preampchoices(i)),preampreal)
        set(preamp,'Value',i);
        break
    end
end
for i=1:4
    if strcmp(cell2mat(readoutchoices(i)),readoutreal)
        set(readout,'Value',i);
        break
    end
end

% make settings window visible
set(options,'Visible','on');
% initialize buffer
%mmc.intializeCircularBuffer();
%mmc.setCircularBufferMemoryFootprint(200);
% start main loop
videoLoop();

% MAIN LOOP
    function videoLoop()
        % Start continuous picture taking and display images
        global vidwin
        global dispmod
        
        % set display to normal
        dispmod = 1;
        % open camera internal shutter
        mmc.setProperty('Andor','Shutter (Internal)','Open');
        % start picture sequence
        pause(1)
        mmc.startContinuousSequenceAcquisition(500);
        pause(1)
        % open figure to put pictures
        vidwin = figure;
        
        % check to make sure sequence is running, get picture and display
        while mmc.isSequenceRunning()
            if mmc.getRemainingImageCount()
                img = mmc.popNextImage();
                a=reshape(uint16(img),mmc.getImageWidth(),[]);
                a = fliplr(a);
                
                % open new display window if previous has been closed
                try
                    set(0,'CurrentFigure',vidwin)
                catch ME1
                    vidwin = figure;
                end
                maxlim = 16628;
                % different display modes
                if dispmod == 1
                    sc(a, [0 maxlim])
                end
                if dispmod == 2
                    sc(a, [0 maxlim],'contrast')
                end
                if dispmod == 3
                    sc(a, [0 maxlim],'prob')
                end
                if dispmod == 4
                    sc(a, [0 maxlim],'prob_jet')
                end
                if dispmod == 5
                    sc(a, [0 maxlim],'diff')
                end
                pause(.05);
                
                %This part added by Joel
                frame = reshape(img,mmc.getImageWidth(),[]);
                frame = fliplr(frame);
                frame = uint16(frame(1:size(frame,2),:));
                temp = medfilt2(frame);
                double(prctile(temp(:),99.9))/14080
                %double(prctile(temp(:),99.9))/9638
                %disp(['Ratio = ',(double(prctile(temp(:),99.9)))/14080]); % 220/256 * 2^14 = 14080
            end
        end
    end

% GUI CALLBACKS
    function gaintxt_Callback(hObject, eventdata, handles)
        % Change camera's gain setting, adjust if user enters value out of
        % bounds
        
        newgain = get(gaintxt,'String');
        if str2num(newgain)>255
            newgain = '255';
        end
        if str2num(newgain)<1
            newgain = '1';
        end
        set(gaintxt,'String',newgain);
        mmc.setProperty('Andor','Gain',newgain);
    end

    function exptxt_Callback(hObject, eventdata, handles)
        % Change camera's exposure setting
        
       newexp = get(exptxt,'String');
       mmc.setProperty('Andor','Exposure',newexp);
    end

    function temperaturetxt_Callback(hObject, eventdata, handles)
        % Change camea's cooling temperature setting
        newtemp = get(temperaturetxt, 'String');
        mmc.setProperty('Andor', 'CCDTemperatureSetPoint', newtemp);
    end


    function bin_Callback(hObject, eventdata, handles)
        % Change binning setting.
        % Because a change in binning changes the dimensions of the image,
        % the sequence must be stopped and restarted.
        global vidwin
        
        mmc.stopSequenceAcquisition();
       choice = get(bin,'Value');
       newbin = cell2mat(binchoices(choice));
       mmc.setProperty('Andor','Binning',newbin);
       delete(vidwin)
       videoLoop();
    end

    function preamp_Callback(hObject, eventdata, handles)
        % Changes camera's pre-amp gain setting
        
       choice = get(preamp,'Value');
       newpreamp = cell2mat(preampchoices(choice));
       mmc.setProperty('Andor','Pre-Amp-Gain',newpreamp);
    end

    function readout_Callback(hObject, eventdata, handles)
        % Changes camera's readout freqency setting
        
       choice = get(readout,'Value');
       newreadout = cell2mat(readoutchoices(choice));
       mmc.setProperty('Andor','ReadoutMode',newreadout);
    end

    function display_Callback(hObject, eventdata, handles)
        % Changes display modifier        
        global dispmod
        
        dispmod = get(display,'Value');
    end

    function endvid_Callback(hObject, eventdata, handles)
        % Clean-up and Destroy function
        global vidwin
        try
        gain = get(gaintxt,'String');
        exp = get(exptxt,'String');
       mmc.setProperty('Andor','Shutter (Internal)','Closed');            
       mmc.stopSequenceAcquisition(); 
        catch
        end
        try
       delete(vidwin);
        catch
        end
       delete(options);
       
    end

end
