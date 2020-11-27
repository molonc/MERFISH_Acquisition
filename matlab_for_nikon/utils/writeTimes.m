function writeTimes( path, filename, focustimes, imagetimes, spottimes, totaltime )

[L, N] = size(focustimes);
spots = [1:1:L];
tiles = [1:1:N];

xlswrite(filename, {'ROI#'},1,'A1')
xlswrite(filename, spots',1,'A2')
xlswrite(filename,{'TotalROI(s)'},1,'B1')
xlswrite(filename, spottimes',1,'B2')
xlswrite(filename, tiles,1,'C1')
xlswrite(filename, imagetimes, 1,'C2')

xlswrite(filename, {'TotalTime(s)'}, 1,['A',num2str(L+3)])
xlswrite(filename, totaltime, 1,['B',num2str(L+3)])

xlswrite(filename, {'FocusTimes(s)'},2,'A1')
xlswrite(filename, spots',2,'A2')
xlswrite(filename, tiles,2,'B1')
xlswrite(filename, focustimes, 2,'B2')



movefile(filename, path);

end

