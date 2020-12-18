function [ List ] = readRegions( loc, name )
%Reads Regions and returns List matrix
regionfile = [loc, name];
K = xlsread(regionfile, 'B1:B1');
List = xlsread(regionfile, ['A3:', 'D' ,num2str(K+2)]);

end

