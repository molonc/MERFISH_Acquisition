function hybrid_buffer(mega, MVP2, MVP3, fluid_num, hybrid_t, hybrid_fr)
    fprintf(MVP2, 'aLP03R');
    fprintf(MVP3, ['aLP0', num2str(fluid_num), 'R']);
    % state2, state1, speed2, speed1, onoff
    writeMega(mega, 10, 0, 0, 0, 0, 1);
    fprintf(MVP2, 'aLP08R');
    writeMega(mega, 10, 0, 1, 0, 0, 1);
    fprintf(MVP2, 'aLP01R');
    startTime = clock;
    switch hybrid_fr
        case 0
            writeMega(mega, 10, 1, 0, 0, 0, 1);
        case 1
            writeMega(mega, 10, 1, 0, 0, 1, 1);
        case 2
            writeMega(mega, 10, 1, 0, 1, 0, 1);
        case 3
            writeMega(mega, 10, 1, 0, 1, 1, 1);
    end
    while etime(clock, startTime) < hybrid_t
    end
   % stop
    writeMega(mega, 10, 1, 1, 1, 1, 1);
    % stop program from looping
    pause(1);
    writeMega(mega, 10, 1, 1, 1, 1, 0);
end