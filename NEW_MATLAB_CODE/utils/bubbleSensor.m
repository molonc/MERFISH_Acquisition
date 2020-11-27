mega = arduino('COM12', 'Mega2560');
configurePin(mega, 'D20', 'pullup');
while 1
    result = readDigitalPin(mega, 'D20')          % if result == 0 => air
end
% clear mega;