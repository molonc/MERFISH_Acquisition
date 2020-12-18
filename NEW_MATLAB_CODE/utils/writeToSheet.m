function writeToSheet(handles, loc_report, dname2, slide_number, tilename, number_fluid)
Position_table = table(loc_report(:,:));
sheetFileName = fullfile(dname2, slide_number, tilename, ['stagePos_Round#', nums2str(number_fluid), '.xlsx']);
disp(['Writing positions to sheet', sheetFileName]);
fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Writing positions to sheet ', sheetFileName]);
writetable(Position_table, sheetFileName,'Sheet',1);
end