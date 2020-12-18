function result = bubbleSensor(mega)
% LOW: air present
% HIGH: no air present
% TODO: you can flip the lo/hi to make it more intuitive (ie. 0-no air; 1-air)
result = readDigitalPin(mega, 'D20');         
end