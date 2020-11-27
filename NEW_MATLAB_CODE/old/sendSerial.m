%% Send encoded message to MEGA

function sendSerial(encoded_message)
%     disp(encoded_message);
    mega = serial('COM8', 'Baudrate', 115200);    % change the COM port
%     fclose(mega);
    fopen(mega);
%     fwrite(mega, encoded_message);
    fwrite(mega, uint16(encoded_message), 'uint16');
%     fprintf(mega, '%s', char(encoded_message));
%     write(mega, encoded_message, "uint8");
%     disp("sent");
    response = fscanf(mega)
    disp("sent");
    fclose(mega);
    delete(mega);
end