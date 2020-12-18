function rinse(mega, MVP2, rinse_iter)
% ---Rinse---
%             MVP2 switches to valve position 2. (waste, empty dead volume)
%             Syringe pump goes to bottom.
%             MVP2 switches to valve position 5. (distilled water)
%             *Syringe pump goes to top, with set speed. (withdrawing)
%             *MVP2 switches to valve position 2. (waste)
%             *Syringe pump goes to bottom, with set speed. (rinsing)
%             *Repeat * for rinse_inter amount of times.

    fprintf(MVP2, 'aLP02R');
    % state2, state1, speed2, speed1, onoff
    writeMega(mega, 10, 0, 0, 0, 0, 1);
    for i=1:rinse_iter
        fprintf(MVP2, 'aLP05R');                    % go to DW
        writeMega(mega, 10, 0, 1, 0, 0, 1);         % go top
        % TODO: fill in the pin number
        while readDigitalPin(mega, 'D') == 0        % while still hasn't reached top switch
        end
        pause(1);
        fprintf(MVP2, 'aLP02R');                    % go to waste
        writeMega(mega, 10, 0, 0, 0, 0, 1);         % go bottom
        % TODO: fill in the pin number
        while readDigitalPin(mega, 'D') == 0        % while still hasn't reached bottom switch
        end
        pause(1);
    end
    % stop program from looping
    pause(1);
    writeMega(mega, 10, 1, 1, 1, 1, 1);
end