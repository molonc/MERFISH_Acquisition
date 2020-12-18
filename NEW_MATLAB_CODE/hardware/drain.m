function drain(handles, mega)
%{ 
turn on drain pump until all drain has been pumped out
pause if power has been cut
%}
disp('Detected leakage. Activating drain pump...');
fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Detected leakage. Activating drain pump...');
waterPump(mega, 5);
while waterSensor(mega) == 1 && hasPower(mega)      % keep pumping until there's no more fluid in the drain, or if power has been cut
end

if ~hasPower(mega)
    % if power has been cut, record the status
    disp('Power has been cut. Waiting to resume...');
    fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Power has been cut. Waiting to resume...');
end
while ~hasPower(mega)
    % wait until power supply comes back up
end

disp('Leak has been fully drained. Resuming program...');
fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Leak has been fully drained. Resuming program...');
waterPump(mega, 0);
end 
