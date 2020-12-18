disp('Andor SDK3 Accessibility Example');
[rc] = AT_InitialiseLibrary();
AT_CheckError(rc);
[rc,hndl] = AT_Open(0);
AT_CheckError(rc);
disp('Camera initialized');
[rc, implemented] = AT_IsImplemented(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc, readable] = AT_IsReadable(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc, readableOnly] = AT_IsReadOnly(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc, writable] = AT_IsWritable(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc] = AT_Close(hndl);
AT_CheckWarning(rc);
[rc] = AT_FinaliseLibrary();
AT_CheckWarning(rc);
disp('Camera shutdown');