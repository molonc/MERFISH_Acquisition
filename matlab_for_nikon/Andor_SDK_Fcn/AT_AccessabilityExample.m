disp('Andor SDK3 Accessability Example');
[rc] = andorsdk3functions('AT_InitialiseLibrary');
[rc,hndl] = andorsdk3functions('AT_Open',0);
disp('Camera initialized');
[rc, implemented] = andorsdk3functions('AT_IsImplemented',hndl,'ExposureTime')
[rc, readable] = andorsdk3functions('AT_IsReadable',hndl,'ExposureTime')
[rc, readableOnly] = andorsdk3functions('AT_IsReadOnly',hndl,'ExposureTime')
[rc, writable] = andorsdk3functions('AT_IsWritable',hndl,'ExposureTime')
[rc] = andorsdk3functions('AT_Close',hndl);
[rc] = andorsdk3functions('AT_FinaliseLibrary');
disp('Camera shutdown');