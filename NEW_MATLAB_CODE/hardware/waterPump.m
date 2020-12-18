function waterPump(mega, voltage)
PWM = 'D6';
DIR = 'D8';
writeDigitalPin(mega, DIR, 1);
writeDigitalPin(mega, 'D11', 0);            % what is this?
writePWMVoltage(mega, PWM, voltage);
end