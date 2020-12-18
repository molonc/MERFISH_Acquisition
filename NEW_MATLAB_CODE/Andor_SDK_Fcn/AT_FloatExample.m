disp('Andor SDK3 Float Example');
[rc] = AT_InitialiseLibrary();
AT_CheckError(rc);
[rc,hndl] = AT_Open(0);
AT_CheckError(rc);
disp('Camera initialized');
[rc, expTime] = AT_GetFloat(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc, expMin] = AT_GetFloatMin(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc, expMax] = AT_GetFloatMax(hndl,'ExposureTime')
AT_CheckWarning(rc);
[rc] = AT_SetFloat(hndl,'ExposureTime', 0.5)
AT_CheckWarning(rc);
[rc] = AT_Close(hndl);
AT_CheckWarning(rc);
[rc] = AT_FinaliseLibrary();
AT_CheckWarning(rc);
disp('Camera shutdown');