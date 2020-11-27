clc
close all
light = serial('COM4');
set(light,'BaudRate',9600);
set(light,'DataBits',8);
set(light,'Parity','None');
set(light,'StopBits',1);
set(light,'Terminator',13)
%set(MVP2,'FlowControl','hardware')
fopen(light);

str = '5702FF50';
str2 = '5703AB50';
% A = sscanf(str, '%2x');
% B = sscanf(str2,'%2x');
% fwrite(light,A,'uint8');
% fwrite(light,B,'uint8');
str3 = '53910250';

fprintf(light,'%X',str);
fprintf(light,'%X',str2);
fprintf(light,'%X',str3);
% C = sscanf(str3,'%2x');
% fwrite(light,C,'uint8');
%pause(1);
data = fscanf(light)
%fprintf(light,'GET SN');
%a = fscanf(light);

fclose(light);
