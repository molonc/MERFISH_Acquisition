disp('Andor SDK3 Integer Example');
[rc] = AT_InitialiseLibrary();
AT_CheckError(rc);
[rc,hndl] = AT_Open(0);
AT_CheckError(rc);
disp('Camera initialized');
[rc, frameCount] = AT_GetInt(hndl,'FrameCount')
AT_CheckWarning(rc);
[rc, countMin] = AT_GetIntMin(hndl,'FrameCount')
AT_CheckWarning(rc);
[rc, countMax] = AT_GetIntMax(hndl,'FrameCount')
AT_CheckWarning(rc);
[rc] = AT_SetInt(hndl,'FrameCount', 5)
AT_CheckWarning(rc);
[rc] = AT_Close(hndl);
AT_CheckWarning(rc);
[rc] = AT_FinaliseLibrary();
AT_CheckWarning(rc);
disp('Camera shutdown');