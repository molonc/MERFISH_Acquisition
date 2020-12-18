function result = hasPower(mega)
%{ 
return true if power is on, false otherwise
%}

% TODO: figure out power supply pin on mega
if readDigitalPin(mega, 'D') == 0
    result = true;
else
    result = false;
end
end