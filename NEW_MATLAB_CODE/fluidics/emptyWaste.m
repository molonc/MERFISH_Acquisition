function emptyWaste(mega, MVP2)
% ---Empty Waste---
%             MVP2 switches to valve position 2. (waste, empty dead volume)
%             Syringe pump goes to bottom.

fprintf(MVP2, 'aLP02R');                    % go to waste
writeMega(mega, 10, 0, 0, 0, 0, 1);         % go bottom
% TODO: figure out bottom switch pin on mega
while readDigitalPin(mega, 'D') == 0 && hasPower(mega)   % keep down until bottom is reached, or if power has been cut off
end

if ~hasPower(mega)
        % if power has been cut, record the status
        disp('Power has been cut. Waiting to resume...');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Power has been cut. Waiting to resume...');
end
while ~hasPower(mega)
    % wait until power supply comes back up
end
writeMega(mega, 10, 1, 1, 1, 1, 1);
pause(1);
end