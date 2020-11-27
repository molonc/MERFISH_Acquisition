% mega = arduino('COM8', 'Mega2560');
PWM = 'D6';
DIR = 'D8';
writeDigitalPin(mega, DIR, 1);
writeDigitalPin(mega, 'D11', 0);
writePWMVoltage(mega, PWM, 5);
% clear mega;