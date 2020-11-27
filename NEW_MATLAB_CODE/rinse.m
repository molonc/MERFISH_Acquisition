function rinse(mega, MVP2, rinse_iter)
    fprintf(MVP2, 'aLP02R');
    % state2, state1, speed2, speed1, onoff
    writeMega(mega, 10, 0, 0, 0, 0, 1);
    fprintf(MVP2, 'aLP05R');
    for i=1:rinse_iter
        writeMega(mega, 10, 0, 1, 0, 0, 1);
        fprintf(MVP2, 'aLP02R');
        writeMega(mega, 10, 0, 0, 0, 0, 1);
    end
    % stop program from looping
    pause(1);
    writeMega(mega, 10, 1, 1, 1, 1, 1);
    writeMega(mega, 10, 1, 1, 1, 1, 0);
end