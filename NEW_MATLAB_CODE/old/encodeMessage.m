%% Encode message

function encoded_message = encodeMessage(on_off, flowrate, mode)
    % to get flowrate from delayTime, use calc.m and input delayTime
    % round flowrate to the nearest first decimal
    
    % encode your message like this: 
    % on/off:
    % on:                           xxxxxxx1
    % off:                          xxxxxxx0
    % param "on_off" will be one of [0, 1]
    
    % speeds:
    % bitwise mapping, not actual value of "flowrate"
    % flowrate = 0.5:               xxx11xxx
    % flowrate = 0.6:               xxx10xxx
    % flowrate = 1:                 xxx01xxx
    % flowrate = 6:                 xxx00xxx
    % param "flowrate" will be one of [0, 8, 16, 24],
    % which maps to the flowrate as shown above respectively
    
    % modes:
    % go to bottom ONLY:            xxxxx00x
    % go to top ONLY:               xxxxx01x
    % go to bottom THEN top:        xxxxx10x
    % go to top THEN bottom:        xxxxx11x
    % param "mode" will be one of [0, 2, 4, 6]
    
    
    modes = bitand(mode, 6);
    speeds = bitand(flowrate, 24);
    onoff = bitand(on_off, 1);
    
    encoded_message = bitor(bitor(modes, speeds), onoff);
end