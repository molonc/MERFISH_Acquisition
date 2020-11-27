function [s] = gsiocserialstart(mode,port)
% Funtion for initializing a serial interface in matlab for interfacing
% with a GSIOC device
%
% mode 1 initializes the connection using the com port specified in
% opt.serial
%
%  IF no arguments are provided the default is COM1 
%
% The functions using the serial port must be passed the serial port object
% s in order for the serial port to be acessable.  

if nargin == 0
    mode = 1; 
    port = 'COM1';
end

if mode == 1
    s = serial(port);
    set(s,'BaudRate',19200,'DataBits',8,'StopBits',1,'Parity',... 
    'even','Flowcontrol','none',...
    'Terminator','','Timeout',0.5);
    fopen(s);
    set(s,'readasyncmode','continuous');
    
    disp([datestr(now),'    Initiating Serial Interface...'])    
end
