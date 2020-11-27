function imaging(mega, MVP2, imaging_t, imaging_fr)
    fprintf(MVP2, 'aLP07R');
    % state2, state1, speed2, speed1, onoff
    writeMega(mega, 10, 0, 1, 0, 0, 1);
    fprintf(MVP2, 'aLP01R');
    startTime = clock;
    switch imaging_fr
        case 0
            writeMega(mega, 10, 1, 0, 0, 0, 1);
        case 1
            writeMega(mega, 10, 1, 0, 0, 1, 1);
        case 2
            writeMega(mega, 10, 1, 0, 1, 0, 1);
        case 3
            writeMega(mega, 10, 1, 0, 1, 1, 1);
    end
    while etime(clock, startTime) < imaging_t
    end
    % stop the pump
    writeMega(mega, 10, 1, 1, 1, 1, 1); 
    % stop program from looping
    pause(1);
    writeMega(mega, 10, 1, 1, 1, 1, 0);
end