disp('Andor SDK3 Boolean Example');
[rc] = AT_InitialiseLibrary();
AT_CheckError(rc);
[rc,hndl] = AT_Open(0);
AT_CheckError(rc);
disp('Camera initialized');
[rc, bool] = AT_GetBool(hndl,'Overlap')
AT_CheckWarning(rc);
[rc] = AT_SetBool(hndl,'Overlap', 1)
AT_CheckWarning(rc);
[rc, bool] = AT_GetBool(hndl,'Overlap')
AT_CheckWarning(rc);
[rc] = AT_Close(hndl);
AT_CheckWarning(rc);
[rc] = AT_FinaliseLibrary();
AT_CheckWarning(rc);
disp('Camera shutdown');