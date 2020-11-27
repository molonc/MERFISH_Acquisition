function [ ] = writeRegions(List, output, label )
%Writes Regions to exccel file

Titles = {'UpperLeftX' 'UpperLeftY' 'LowerRightX' 'LowerRightY'};

filename = [label,'.xlsx'];

[K, N] = size(List);
xlswrite(filename, {'#Regions'},1,'A1')
xlswrite(filename, K, 1,'B1')

xlswrite(filename, Titles, 1, 'A2')
xlswrite(filename, List, 1, 'A3')

movefile([label,'.xlsx'], output);

end

