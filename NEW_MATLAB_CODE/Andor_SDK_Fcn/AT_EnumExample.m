disp('Andor SDK3 Enumerated Example');
[rc] = AT_InitialiseLibrary();
AT_CheckError(rc);
[rc,hndl] = AT_Open(0);
AT_CheckError(rc);
disp('Camera initialized');
strLen = 256;
[rc, count] = AT_GetEnumCount(hndl,'SimplePreAmpGainControl')
AT_CheckWarning(rc);
[rc, currentIndex] = AT_GetEnumIndex(hndl,'SimplePreAmpGainControl')
AT_CheckWarning(rc);

disp('Available Options');
for i=0:count-1
  [rc, currentString] = AT_GetEnumStringByIndex(hndl,'SimplePreAmpGainControl',i,strLen);
  AT_CheckWarning(rc);
  disp(['  Index: ' num2str(i) ' Value: ' currentString]);
end
disp('End of Available Options');

[rc] = AT_SetEnumIndex(hndl,'SimplePreAmpGainControl',count-1)
AT_CheckWarning(rc);
[rc, currentIndex] = AT_GetEnumIndex(hndl,'SimplePreAmpGainControl')
AT_CheckWarning(rc);
[rc] = AT_SetEnumString(hndl,'SimplePreAmpGainControl',currentString)
AT_CheckWarning(rc);
[rc, currentIndex] = AT_GetEnumIndex(hndl,'SimplePreAmpGainControl')
AT_CheckWarning(rc);
[rc, isImplemented] = AT_IsEnumIndexImplemented(hndl,'SimplePreAmpGainControl', count)
AT_CheckWarning(rc);
[rc, isAvailable] = AT_IsEnumIndexAvailable(hndl,'SimplePreAmpGainControl', count)
AT_CheckWarning(rc);
[rc] = AT_Close(hndl);
AT_CheckWarning(rc);
[rc] = AT_FinaliseLibrary();
AT_CheckWarning(rc);
disp('Camera shutdown');