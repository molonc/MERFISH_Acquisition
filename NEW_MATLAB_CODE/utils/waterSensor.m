mega = arduino('COM12', 'Mega2560');
while 1
    readDigitalPin(mega, 'D19')
end