 clear
 clc
s=serial('COM8','BaudRate',115200);
fopen(s);
 readData=fscanf(s); %reads "Ready" 
 disp(readData);
writedata=uint16(500); %0x01F4
fwrite(s,writedata,'uint16') %write data
 for i=1:2 %read 2 lines of data
readData=fscanf(s);
disp(readData)
end
 fclose(s);
 delete(s);