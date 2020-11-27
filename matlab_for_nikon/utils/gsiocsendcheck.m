function out = gsiocsendcheck(s,command)

% send a command
% check that the response matches the byte sent
% if they do not match then attempt to re-send and check

try
    if s.bytesavailable > 0 %clear buffer if data is available
        bufferread = fread(s,s.bytesavailable);
    end
    % Write to device
    fwrite(s,command);

    %read from the device
    out = fread(s,1);
catch
    if s.bytesavailable > 0; %clear buffer if data is available
        bufferread = fread(s,s.bytesavailable);
    end
    % Write to device
    fwrite(s,command);

    %read from the device
    out = fread(s,1);
end

if command ~= out  %check for match of bytess
    disp(['output: ',out,' does not match command: ',command])
end



end