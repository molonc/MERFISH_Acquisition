function [ X ] = mono16tomatrix( data, H, W, S)

data = reshape(data, S, []);
data = data';
data = data(:, 1:(W*2));
data = data';
data = reshape(data, 1, []);
data16 = typecast(uint8(data), 'uint16');
X = reshape(data16, H, W);


% data = reshape(data, [], S);
% %data = data';
% data = data(:, 1:(W*2));
% %data = data';
% data = reshape(data, [], 1);
% data16 = typecast(uint8(data), 'uint16');
% X = reshape(data16, H, W);
end

