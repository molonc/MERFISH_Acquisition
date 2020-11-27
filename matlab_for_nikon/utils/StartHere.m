% StartHere.m 
% Script for demonstrating the use of gsioc.m, a serial interface function for 
% communicating with Gilson equiptment using the GSIOC protocol.  This code
% was developed while working with a gilson 215 liquid handler
% but should be functional with any of the other GSIOC protocol devices.
% 
% Many thanks to Geoffrey Akien and his CO2gui - lab control and automation
% for having figured out many of the intricacies of talking with a 
% GSIOC device.  This code is in many ways a simplified adaptation of his
% work with less error handling, but a little more flexability.  
% 
% Functions
% starthere.m - example implementation of the files
% gsiocserialstart.m - initiate serial interface
% gsioc.m - primary function for send/receive
% gsiocsendcheck.m - sub function of gsioc.m for serial communication
% 
% Example:  Un-comment any of the "stype" and "command" pairs below to 
% use the interface.  Be sure to specify the correct com port and device ID
%
% %Beep
% stype = 'B'; %I for immediate or B for buffered command (see user manual)
% command = ['B', num2str(2400),',',num2str(5)];
% 
% %Home Diluter
% stype = 'B';
% command = 'd';
% 
% %Volume in Diluter
% stype = 'I'
% command = 'D'
% 
% % volume to aspirate (+) or dispensed (-) 500 total
% stype = 'B'
% command = ['D','N','+','500']
% 
% %Home the probe
% stype = 'B'
% command = 'H'
% 
% %Travel range
% stype = 'I'
% command = 'Q'
% X= 0013/ 5924
% Y= 0020/ 3324
% Z= 0000/ 1750
% 
% %Write a character string to display
% stype = 'B';
% command = 'WHello';
% 
% %Location of probe xxxx/yyyy
% stype = 'I'
% command = 'X'
% 
% %Location of probe zzzz  large number is up
% stype = 'I'
% command = 'Z'
% 
% %set new X and Y position Xxxxx/yyyy
% stype = 'B'
% command = ['X',num2str(5900),'/',num2str(3300)]
% 
% % Set new Z position Zzzzz 0 is down, 1750 is up
%  stype = 'B'
%  command = ['Z',num2str(0000)]

clear output stype command

% Find any existing matlab serial objects and remove them:
g = instrfind; % remove any remaining serial objects
if ~isempty(g);
   fclose(g);
   delete(g)
   clear g
end

[s] = gsiocserialstart(1,'COM9');  % Initiate serial interface with COM3

if s.bytesavailable > 0; %clear buffer if data is available
    bufferread = fread(s);
end
ID = 30;  % Device ID to be addressed

output = gsioc(s,ID,'I','?')

















