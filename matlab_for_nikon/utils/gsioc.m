function output = gsioc(s,ID,stype,command)

IDnum = ID + 128; %ID for sending to device

%initiate operation by sending IDnum to device
out = gsiocsendcheck(s,IDnum); %should return 150 for device 22 (128+22)
pause(0.1)
out = gsiocsendcheck(s,IDnum); %should return 150 for device 22 (128+22)

if stype == 'I'
    counter1 = 1; %counter for storing responses
    
    fwrite(s, command)  %send request to instrument
    
    response(counter1) = fread(s,1);
    
    while response(counter1) < 128
        fwrite(s, char(6)) %request next byte with 'ack'

        response(counter1 + 1) = fread(s, 1); %read 1 byte
        
        counter1 = counter1+1;  %Increment counter
    end
    
    % From Geoffrey Akien
    % the last byte to be sent is the ASCII number for the last character,
    % but + 128 to signify that this is the last character.  GSIOC does not
    % appear to transmit any data larger than 128 unless it is a deviceID,
    % or it is the last byte of data.
    
    % modifies the last byte and converts it into ASCII - Akien
    output = char([response(1:end - 1), response(end) - 128]);
    
elseif stype == 'B' 
    out = gsiocsendcheck(s,char(10));  %Initiate transmission with a LF
    
    for i = 1:numel(command)  % Send bytes one at a time
        out(i) = gsiocsendcheck(s,command(i));
    end
    out2 = gsiocsendcheck(s,char(13));  % Terminate transmission with a CR

    if out ~= command  %check that the returned signal matches the command
        output = 'fail';
        disp(['Sent: ',command,' Received ',out])
    else
        output = 'ok';
    end
end

