function writeMega(mega, syringe, state2, state1, speed2, speed1, on_off)
    % Mega pins %
    if syringe == 10        % 10mL syringe
        ON_OFF = 'D10';
        STATE1 = 'D39';
        STATE2 = 'D41';
        SPEED1 = 'D43';
        SPEED2 = 'D45';
    elseif syringe == 30    % 30mL syringe
        %TODO: change these pins
        ON_OFF = 'D10';
        STATE1 = 'D39';
        STATE2 = 'D41';
        SPEED1 = 'D43';
        SPEED2 = 'D45';
    end

    writeDigitalPin(mega, STATE1, state1);
    writeDigitalPin(mega, STATE2, state2);
    writeDigitalPin(mega, SPEED1, speed1);
    writeDigitalPin(mega, SPEED2, speed2);
    writeDigitalPin(mega, ON_OFF, on_off);
end