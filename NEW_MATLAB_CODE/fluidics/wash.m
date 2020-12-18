function wash(handles, mega, MVP1, MVP2, wash_t, wash_fr)
% ---Wash---
%             MVP1 switches to valve position 1. (10mL syringe)
%             MVP2 switches to valve position 2. (waste, empty dead volume)
%             Syringe pump goes to bottom. (ready to withdraw)
%             MVP2 switches to valve position 8. (wash buffer)
%             Syringe pump goes to top, with set speed. (withdrawing)
%             MVP2 switches to valve position 1. (chamber inlet)
%             Syringe pump goes down, with specified flowrate and duration.
%             (washing)

    fprintf(MVP1, 'aLP01R');
    fprintf(MVP2, 'aLP02R');
    % state2, state1, speed2, speed1, onoff
    writeMega(mega, 10, 0, 0, 0, 0, 1);
    fprintf(MVP2, 'aLP08R');
    writeMega(mega, 10, 0, 1, 0, 0, 1);
    fprintf(MVP2, 'aLP01R');
    startTime = clock;
    switch wash_fr
        case 0
            writeMega(mega, 10, 1, 0, 0, 0, 1);
        case 1
            writeMega(mega, 10, 1, 0, 0, 1, 1);
        case 2
            writeMega(mega, 10, 1, 0, 1, 0, 1);
        case 3
            writeMega(mega, 10, 1, 0, 1, 1, 1);
    end
    
    % TODO: verify that waterSensor(mega) == 0 means no leak is present
    while etime(clock, startTime) < wash_t && waterSensor(mega) == 0 && hasPower(mega)          % keep down until wash time is reached, or leak is detected, or power has been cut  
        if bubbleSensor(mega) == 1
            disp('Detected air. Logging the time...');
            fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Detected air. Logging the time...');
        end
    end
    if ~hasPower(mega)
        % if power has been cut, record the status
        disp('Power has been cut. Waiting to resume...');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Power has been cut. Waiting to resume...');
    end
    while ~hasPower(mega)
        % wait until power supply comes back up
    end
    
    % stop the pump
    writeMega(mega, 10, 1, 1, 1, 1, 1);
    pause(1);
    if waterSensor(mega) == 1
        % emergency stop
        writeMega(mega, 10, 1, 1, 1, 1, 0);
        drain(handles, mega);
    end
end