function handles = cleavage_init(handles, mega, MVP1, MVP2)

    %%% READ ME %%%
    %{
        fill 30mL syringe with cleavage solution.
    %}
    
    %{
        workflow:
            MVP2 switches to valve position 2. (waste, empty dead volume)
            MVP1 switches to valve position 2. (30mL syringe)
            Syringe goes to bottom.
            MVP2 switches to valve 6. (cleavage buffer)
            Syringe goes to top.
    %}
        
    fprintf(MVP2, 'aLP02R');
    fprintf(MVP1, 'aLP02R');
    writeMega(mega, 30, 0, 0, 0, 0, 1);
    % TODO: figure out bottom switch pin on mega
    while readDigitalPin(mega, 'D') == 0            % keep down until bottom is reached     
    end
    
    fprintf(MVP2, 'aLP06R');
    writeMega(mega, 30, 0, 1, 0, 0, 1);
    
    % TODO: figure out top switch pin on mega
    % TODO: verify that waterSensor(mega) == 0 means no leak is present 
    while readDigitalPin(mega, 'D') == 0 && waterSensor(mega) == 0 && hasPower(mega)        % keep up until top is reached, or if power has been cut off, or if leakage is detected     
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
    writeMega(mega, 30, 1, 1, 1, 1, 1);
    pause(1);
    if waterSensor(mega) == 1
        % emergency stop
        writeMega(mega, 10, 1, 1, 1, 1, 0);
        drain(handles, mega)
    end    
end