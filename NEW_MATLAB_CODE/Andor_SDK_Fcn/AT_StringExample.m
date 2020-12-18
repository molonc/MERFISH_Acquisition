disp('Andor SDK3 String Example');
[rc] = andorsdk3functions('AT_InitialiseLibrary');
[rc,hndl] = andorsdk3functions('AT_Open',0);
disp('Camera initialized');
strLen = 256;
[rc, serialNumber] = andorsdk3functions('AT_GetString',hndl,'SerialNumber',strLen)
[rc, maxLength] = andorsdk3functions('AT_GetStringMaxLength',hndl,'SerialNumber')
[rc, writable] = andorsdk3functions('AT_IsWritable',hndl,'SerialNumber')
if writable==1
    [rc] = andorsdk3functions('AT_SetString',hndl,'SerialNumber','NewStringValue')
end
[rc] = andorsdk3functions('AT_Close',hndl);
[rc] = andorsdk3functions('AT_FinaliseLibrary');
disp('Camera shutdown');