function wash(mega, MVP1, MVP2, wash_t, wash_fr)
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
    while etime(clock, startTime) < wash_t
    end
    % stop the pump
    writeMega(mega, 10, 1, 1, 1, 1, 1);
    % stop program from looping
    pause(1);
    writeMega(mega, 10, 1, 1, 1, 1, 0);
end