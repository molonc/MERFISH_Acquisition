function frame = andor_capture(mmc,gain,exposure,pre_amp_gain)

mmc.setProperty('Andor','Gain',gain);
mmc.setProperty('Andor','Exposure',exposure);
mmc.setProperty('Andor','Pre-Amp-Gain',pre_amp_gain);
mmc.intializeCircularBuffer();
mmc.setCircularBufferMemoryFootprint(200);

mmc.setProperty('Andor','InternalShutter','Open');
pause(1)
mmc.startSequenceAcquisition(1, 100, false);
pause(1);
while mmc.isSequenceRunning()
end
pause(2);
img = mmc.popNextImage();


% mmc.setProperty('Andor','InternalShutter','Closed');

% x = zeros(length(img),1,'uint16');
% for i=1:length(img)
%     if img(i,1)<0
%         x(i,1)=(32768 - (img(i,1)*(-1)))+32768;
%     else
%         x(i,1)=img(i,1);
%     end
%     
% end

frame = reshape(img,mmc.getImageWidth(),[]);
frame = fliplr(frame);
frame = uint16(frame(1:size(frame,2),:));