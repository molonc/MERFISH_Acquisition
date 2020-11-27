function [] = MERFISH_hybridization(minipuls,MVP1,MVP2,MVP3,valve_pos,wash,imaging,ID,wash_t,hybrid_t, mega)
        
        disp('Initializing Hamiliton MVP');
        fprintf(MVP1,'aLXR');
%         fprintf(MVP2,'aLXR');
        fprintf(MVP3,'aLXR');
        pause(10);
       
        %fprintf(MVP2,'aLP06R');
     
        gsioc(minipuls,ID,'B','R4800');
        fprintf(MVP1, ['aLP0',num2str(wash),'R']);
        pause(1)
        disp('Inject Wash Buffer');
        gsioc(minipuls,ID,'B','K>');
        %run mini pump

       % pause(100);
        startTimeWash = clock;
%         reverseTimeWash2 = 10;
%         airoutTimeWash2 = 10;
%         overHeadTime = 2;
        bubbleCount = 0;
        while etime(clock,startTimeWash) < 100
            gsioc(minipuls,ID,'B','K>');
            airSensorVal = readDigitalPin(mega,'D20');
            if airSensorVal ~= 0
                disp("running pump");
            else
                bubbleCount = bubbleCount + 1;
                disp("air detected");
                % log it
                logFile = fopen(fullfile(pwd, 'logFile.txt'), 'a');
                if logFile == -1
                    error("Canont open log file.");
                end
                fprintf(logFile, '%s - %s: %s\n', bubbleCount, datestr(now, 0), "air detected");
                fclose(logFile);
                
%             waterSen = readDigitalPin(mega,'D12');
%             if sensorVal ~= 0
%                 disp('Runing Pump');
%                 writeDigitalPin(mega,'D8',0);
%                 writeDigitalPin(mega,'D7',0);
%             else
%                 disp('Reverse Pump');
%                 writeDigitalPin(mega,'D8',1);
%                 writeDigitalPin(mega,'D7',0);
%                 gsioc(minipuls,ID,'B','K<');
%                 pause(reverseTimeWash2);        
%                 %re-adjust time
%                 startTimeInSec = startTimeWash(6)+startTimeWash(5)*60+startTimeWash(4)*3600;
%                 startTimeInSec_new = startTimeInSec - reverseTimeWash2  - overHeadTime;
%                 hour = floor(startTimeInSec_new/3600);
%                 min = floor((startTimeInSec_new - (hour*3600))/60);
%                 sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
%                 startTimeWash(4) = hour;
%                 startTimeWash(5) = min;
%                 startTimeWash(6) = sec;
                
%             end
            
%             if waterSen ~= 0
%                 disp('leak detected!!')
%                 writeDigitalPin(mega,'D7',1);
%                 writeDigitalPin(mega,'D8',0);
%                 gsioc(minipuls,ID,'B','KH');
%                 writeDigitalPin(mega,'D4',0);
%                 writePWMVoltage(mega,'D9',0);
%                 pause(0.5);
%                 return             
%             end
        end    
%         clear startTimeInSec
%         clear startTimeInSec_new
%         clear hour
%         clear min
%         clear sec
%         clear sensorVal
%         clear waterSen

        gsioc(minipuls,ID,'B','R2400');
        startTimeWash2 = clock;
%         reverseTimeWash2 = 10;
%         airoutTimeWash2 = 10;
        while etime(clock,startTimeWash2) < wash_t
            gsioc(minipuls,ID,'B','K>');
%             sensorVal = readDigitalPin(mega,'D2');
%             waterSen = readDigitalPin(mega,'D12');
%             if sensorVal ~= 0
%                 disp('Runing Pump');
%                 writeDigitalPin(mega,'D8',0);
%                 writeDigitalPin(mega,'D7',0);
%             else
%                 disp('Reverse Pump');
%                 gsioc(minipuls,ID,'B','R4800');
%                 writeDigitalPin(mega,'D8',1);
%                 writeDigitalPin(mega,'D7',0);
%                 gsioc(minipuls,ID,'B','K<');
%                 pause(reverseTimeWash2);
%                 gsioc(minipuls,ID,'B','R2400');
% %                 %run mini pump
% %                 disp('running airout pump');
% %                 writeDigitalPin(mega,'D4',1);
% %                 writeDigitalPin(mega,'D5',0);
% %                 writePWMVoltage(mega,'D9',5);
% %                 pause(airoutTimeWash2);
% %                 writePWMVoltage(mega,'D9',0);
%                 %re-adjust time
%                 startTimeInSec = startTimeWash2(6)+startTimeWash2(5)*60+startTimeWash2(4)*3600;
%                 startTimeInSec_new = startTimeInSec - reverseTimeWash2  - overHeadTime;
%                 hour = floor(startTimeInSec_new/3600);
%                 min = floor((startTimeInSec_new - (hour*3600))/60);
%                 sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
%                 startTimeWash2(4) = hour;
%                 startTimeWash2(5) = min;
%                 startTimeWash2(6) = sec;         
%             end
%             
%             if waterSen ~= 0
%                 disp('leak detected!!')
%                 writeDigitalPin(mega,'D7',1);
%                 writeDigitalPin(mega,'D8',0);
%                 gsioc(minipuls,ID,'B','KH');
%                 writeDigitalPin(mega,'D4',0);
%                 writePWMVoltage(mega,'D9',0);
%                 pause(0.5);
%                 return   
%             end
        end   
%         clear startTimeInSec
%         clear startTimeInSec_new
%         clear hour
%         clear min
%         clear sec
%         clear sensorVal
%         clear waterSen
        gsioc(minipuls,ID,'B','KH');
        fprintf(MVP1,'aLP11R');
        pause(1)
        %%hybridization
%         writePWMVoltage(mega,'D9',0);
        fprintf(MVP3, ['aLP0',num2str(valve_pos),'R']);
        pause(1);
        
%         fprintf(MVP3, ['aLP0',num2str(valve_pos),'R']);
        disp('Inject Hybridization Buffer');
        gsioc(minipuls,ID,'B','R4800');
        
%         writePWMVoltage(mega,'D9',5);
        %pause(180);
        startTimehyb = clock;
%         reverseTimehyb = 10;
%         airoutTimehyb = 10;
        while etime(clock,startTimehyb) < 180
            gsioc(minipuls,ID,'B','K>');
%             sensorVal = readDigitalPin(mega,'D2');
%             waterSen = readDigitalPin(mega,'D12');
%             if sensorVal ~= 0
%                 disp('Runing Pump');
%                 writeDigitalPin(mega,'D8',0);
%                 writeDigitalPin(mega,'D7',0);
%             else
%                 disp('Reverse Pump');
%                 writeDigitalPin(mega,'D8',1);
%                 writeDigitalPin(mega,'D7',0);
%                 gsioc(minipuls,ID,'B','K<');
%                 pause(reverseTimehyb);
% %                 %run mini pump
% %                 disp('running airout pump');
% %                 writeDigitalPin(mega,'D4',1);
% %                 writeDigitalPin(mega,'D5',0);
% %                 writePWMVoltage(mega,'D9',5);
% %                 pause(airoutTimehyb);
% %                 writePWMVoltage(mega,'D9',0);     
%                 %re-adjust time
%                 startTimeInSec = startTimehyb(6)+startTimehyb(5)*60+startTimehyb(4)*3600;
%                 startTimeInSec_new = startTimeInSec - reverseTimehyb - overHeadTime;
%                 hour = floor(startTimeInSec_new/3600);
%                 min = floor((startTimeInSec_new - (hour*3600))/60);
%                 sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
%                 startTimehyb(4) = hour;
%                 startTimehyb(5) = min;
%                 startTimehyb(6) = sec;        
%             end
%             
%             if waterSen ~= 0
%                 disp('leak detected!!')
%                 writeDigitalPin(mega,'D7',1);
%                 writeDigitalPin(mega,'D8',0);
%                 gsioc(minipuls,ID,'B','KH');
%                 writeDigitalPin(mega,'D4',0);
%                 writePWMVoltage(mega,'D9',0);
%                 pause(0.5);
%                 return       
%             end
        end
        
%         clear startTimeInSec
%         clear startTimeInSec_new
%         clear hour
%         clear min
%         clear sec
%         clear sensorVal
%         clear waterSen
        
        gsioc(minipuls,ID,'B','R640');
        startTimehyb2 = clock;
%         reverseTimehyb2 = 10;
%         airoutTimehyb2 = 10;
        while etime(clock,startTimehyb2) < hybrid_t
            gsioc(minipuls,ID,'B','K>');
%             sensorVal = readDigitalPin(mega,'D2');
%             waterSen = readDigitalPin(mega,'D12');
%             if sensorVal ~= 0
%                 disp('Runing Pump');
%                 writeDigitalPin(mega,'D8',0);
%                 writeDigitalPin(mega,'D7',0);
%             else
%                 gsioc(minipuls,ID,'B','R4800');
%                 disp('Pause Pump');
%                 writeDigitalPin(mega,'D8',1);
%                 writeDigitalPin(mega,'D7',0);
%                 gsioc(minipuls,ID,'B','K<');
%                 pause(reverseTimehyb2);
%                 gsioc(minipuls,ID,'B','R640');
%                 %run mini pump
%                 disp('running airout pump');
%                 writeDigitalPin(mega,'D4',1);
%                 writeDigitalPin(mega,'D5',0);
%                 writePWMVoltage(mega,'D9',5);
%                 pause(airoutTimehyb2);
%                 writePWMVoltage(mega,'D9',0);
                
               %re-adjust time
%                 startTimeInSec = startTimehyb2(6)+startTimehyb2(5)*60+startTimehyb2(4)*3600;
%                 startTimeInSec_new = startTimeInSec - reverseTimehyb2 - overHeadTime;
%                 hour = floor(startTimeInSec_new/3600);
%                 min = floor((startTimeInSec_new - (hour*3600))/60);
%                 sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
%                 startTimehyb2(4) = hour;
%                 startTimehyb2(5) = min;
%                 startTimehyb2(6) = sec;  
%             end
%             
%             if waterSen ~= 0
%                 disp('leak detected!!')
%                 writeDigitalPin(mega,'D7',1);
%                 writeDigitalPin(mega,'D8',0);
%                 gsioc(minipuls,ID,'B','KH');
%                 writeDigitalPin(mega,'D4',0);
%                 writePWMVoltage(mega,'D9',0);
%                 pause(0.5);
%                 return                
%             end
        end
%         clear startTimeInSec
%         clear startTimeInSec_new
%         clear hour
%         clear min
%         clear sec
%         clear sensorVal
%         clear waterSen
%         gsioc(minipuls,ID,'B','KH');
%         writePWMVoltage(mega,'D9',0);
        gsioc(minipuls,ID,'B','KH');
        gsioc(minipuls,ID,'B','R4800');
        fprintf(MVP1,['aLP0',num2str(wash),'R']);
        pause(1);
%         fprintf(MVP1,['aLP0',num2str(wash),'R']);
        disp('Inject Wash Buffer');
        %pause(100);
        startTimeWash3 = clock;
%         reverseTimeWash3 = 10;
%         airoutTimeWash3 = 10;
        while etime(clock,startTimeWash3) < 100
            gsioc(minipuls,ID,'B','K>');
%             sensorVal = readDigitalPin(mega,'D2');
%             waterSen = readDigitalPin(mega,'D12');
%             if sensorVal ~= 0
%                 disp('Runing Pump');
%                 writeDigitalPin(mega,'D8',0);
%                 writeDigitalPin(mega,'D7',0);
%             else
%                 disp('Pause Pump');
%                 writeDigitalPin(mega,'D8',1);
%                 writeDigitalPin(mega,'D7',0);
%                 gsioc(minipuls,ID,'B','K<');
%                 pause(reverseTimeWash3);
% %                 %run mini pump
% %                 disp('running airout pump');
% %                 writeDigitalPin(mega,'D4',1);
% %                 writeDigitalPin(mega,'D5',0);
% %                 writePWMVoltage(mega,'D9',5);
% %                 pause(airoutTimeWash3);
% %                 writePWMVoltage(mega,'D9',0);
%                 
%                 %re-adjust time
%                 startTimeInSec = startTimeWash3(6)+startTimeWash3(5)*60+startTimeWash3(4)*3600;
%                 startTimeInSec_new = startTimeInSec - reverseTimeWash2  - overHeadTime;
%                 hour = floor(startTimeInSec_new/3600);
%                 min = floor((startTimeInSec_new - (hour*3600))/60);
%                 sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
%                 startTimeWash3(4) = hour;
%                 startTimeWash3(5) = min;
%                 startTimeWash3(6) = sec;
%                 
%             end
%             
%             if waterSen ~= 0
%                 disp('leak detected!!')
%                 writeDigitalPin(mega,'D7',1);
%                 writeDigitalPin(mega,'D8',0);
%                 gsioc(minipuls,ID,'B','KH');
%                 writeDigitalPin(mega,'D4',0);
%                 writePWMVoltage(mega,'D9',0);
%                 pause(0.5);
%                 return  
%             end
        end
%         clear startTimeInSec
%         clear startTimeInSec_new
%         clear hour
%         clear min
%         clear sec
%         clear sensorVal
%         clear waterSen
%         gsioc(minipuls,ID,'B','KH');
%         writePWMVoltage(mega,'D9',0);
        
        %%imaging buffer
        gsioc(minipuls,ID,'B','KH');
        fprintf(MVP1, ['aLP0',num2str(imaging),'R']);
        pause(1);
        disp('Inject Imaging Buffer');
        %pause(120)
        startTimeImg= clock;
%         reverseTimeImg = 10;
%         airoutTimeImg = 10;
        while etime(clock,startTimeImg) < wash_t
            gsioc(minipuls,ID,'B','K>');
           
%             sensorVal = readDigitalPin(mega,'D2');
%             waterSen = readDigitalPin(mega,'D12');
%             if sensorVal ~= 0
%                 writeDigitalPin(mega,'D8',0);
%                 writeDigitalPin(mega,'D7',0);
%             else
%                 writeDigitalPin(mega,'D8',1);
%                 writeDigitalPin(mega,'D7',0);
%                 gsioc(minipuls,ID,'B','K<');
%                 pause(reverseTimeImg);
% %                 gsioc(minipuls,ID,'B','KH');
% %                 %run mini pump
% %                 disp('running airout pump');
% %                 writeDigitalPin(mega,'D4',1);
% %                 writeDigitalPin(mega,'D5',0);
% %                 writePWMVoltage(mega,'D9',5);
% %                 pause(airoutTimeImg);
% %                 writePWMVoltage(mega,'D9',0);
%                 
%                 %re-adjust time
%                 startTimeInSec = startTimeImg(6)+startTimeImg(5)*60+startTimeImg(4)*3600;
%                 startTimeInSec_new = startTimeInSec - reverseTimeImg  - overHeadTime;
%                 hour = floor(startTimeInSec_new/3600);
%                 min = floor((startTimeInSec_new - (hour*3600))/60);
%                 sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
%                 startTimeImg(4) = hour;
%                 startTimeImg(5) = min;
%                 startTimeImg(6) = sec;
%                 
%             end
%             
%             if waterSen ~= 0
%                 disp('leak detected!!')
%                 writeDigitalPin(mega,'D7',1);
%                 writeDigitalPin(mega,'D8',0);
%                 gsioc(minipuls,ID,'B','KH');
%                 writeDigitalPin(mega,'D4',0);
%                 writePWMVoltage(mega,'D9',0);
%                 pause(0.5);
%                 return        
%             end
        end
        gsioc(minipuls,ID,'B','KH');
%         clear startTimeInSec
%         clear startTimeInSec_new
%         clear hour
%         clear min
%         clear sec
%         clear sensorVal
%         clear waterSen
%         
%         gsioc(minipuls,ID,'B','KH');
%         writeDigitalPin(mega,'D4',0);
%         writePWMVoltage(mega,'D9',0);
%         disp('Complete!');

    end