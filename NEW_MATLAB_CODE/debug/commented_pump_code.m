sensorVal = readDigitalPin(mega,'D2');
waterSen = readDigitalPin(mega,'D12');
if sensorVal ~= 0
    disp('Runing Pump');
    writeDigitalPin(mega,'D8',0);
    writeDigitalPin(mega,'D7',0);
else
    disp('Reverse Pump');
    writeDigitalPin(mega,'D8',1);
    writeDigitalPin(mega,'D7',0);
    gsioc(minipuls,ID,'B','K<');
    pause(reverseTimehyb);
%                 %run mini pump
%                 disp('running airout pump');
%                 writeDigitalPin(mega,'D4',1);
%                 writeDigitalPin(mega,'D5',0);
%                 writePWMVoltage(mega,'D9',5);
%                 pause(airoutTimehyb);
%                 writePWMVoltage(mega,'D9',0);     
    %re-adjust time
    startTimeInSec = startTimehyb(6)+startTimehyb(5)*60+startTimehyb(4)*3600;
    startTimeInSec_new = startTimeInSec - reverseTimehyb - overHeadTime;
    hour = floor(startTimeInSec_new/3600);
    min = floor((startTimeInSec_new - (hour*3600))/60);
    sec = floor((startTimeInSec_new - (hour*3600) - (min*60)));
    startTimehyb(4) = hour;
    startTimehyb(5) = min;
    startTimehyb(6) = sec;        
end

if waterSen ~= 0
    disp('leak detected!!')
    writeDigitalPin(mega,'D7',1);
    writeDigitalPin(mega,'D8',0);
    gsioc(minipuls,ID,'B','KH');
    writeDigitalPin(mega,'D4',0);
    writePWMVoltage(mega,'D9',0);
    pause(0.5);
    return       
end


clear startTimeInSec
clear startTimeInSec_new
clear hour
clear min
clear sec
clear sensorVal
clear waterSen
gsioc(minipuls,ID,'B','KH');
writePWMVoltage(mega,'D9',0);