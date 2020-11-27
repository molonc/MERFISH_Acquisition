disp('Andor SDK3 CallBack Example');
[rc] = AT_InitialiseLibrary();
AT_CheckError(rc);
[rc,hndl] = AT_Open(0);
AT_CheckError(rc);
disp('Camera initialized');
%Registering the function will produce the first callback
[rc] = AT_RegisterFeatureCallback(hndl,'FrameCount','AT_CallBack()');
AT_CheckWarning(rc);
%Setting the feature will produce the second callback
[rc] = AT_SetInt(hndl,'FrameCount', 5);
AT_CheckWarning(rc);
[rc] = AT_UnregisterFeatureCallback(hndl,'FrameCount','AT_CallBack()');
AT_CheckWarning(rc);
%Setting the feature should no longer produce a callback
[rc] = AT_SetInt(hndl,'FrameCount', 5);
AT_CheckWarning(rc);
[rc] = AT_Close(hndl);
AT_CheckWarning(rc);
[rc] = AT_FinaliseLibrary();
AT_CheckWarning(rc);
disp('Camera shutdown');
