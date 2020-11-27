function writeToArduino(onoff, mode, flowrate)
    if onoff == 1
        on_off = 1
    else
        on_off = 0
    end
    
    if mode == 0
        state1 = 0
        state2 = 0
    elseif mode == 1
        state1 = 1
        state2 = 0
    elseif mode == 2
        state1 = 0
        state2 = 1
    else
        state1 = 1
        state2 = 1
    end
    
    if flowrate == 0
        speed1 = 0
        speed2 = 0
    elseif flowrate == 1
        speed1 = 1
        speed2 = 0
    elseif flowrate == 2
        speed1 = 0
        speed2 = 1
    else
        speed1 = 1
        speed2 = 1
    end
    
    mega = arduino('COM8', 'Mega2560');
    writeDigitalPin(mega, 'D10', 1);
    writeDigitalPin(mega, 'D39', 1);
    writeDigitalPin(mega, 'D41', 1);
    writeDigitalPin(mega, 'D43', 1);
    writeDigitalPin(mega, 'D45', 1);
    clear mega
    disp("finished writing to mega");
end