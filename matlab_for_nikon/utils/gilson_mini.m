s1 = serial('COM9');
set(s1,'BaudRate',19200);
set(s1,'DataBits',8);
set(s1,'Parity','even');
set(s1,'StopBits',1);
set(s1,'Terminator','')
set(s1,'FlowControl','none')
fopen(s1);
set(s1,'readasyncmode','continuous')

fprintf(s1,'%');
a = fscanf(s1)


