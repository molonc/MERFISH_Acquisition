function frame = AndoriXonCapture(mmc,gain,exposure,pre_amp_gain,shutter)

mmc.setProperty('Andor','Gain',gain);
mmc.setProperty('Andor','Exposure',num2str(exposure));
mmc.setProperty('Andor','Pre-Amp-Gain',pre_amp_gain);


if shutter
    mmc.setProperty('Andor','Shutter (Internal)','Open');
    disp('Exposing with OPEN shutter...')
else
    mmc.setProperty('Andor','Shutter (Internal)','Closed');
    disp('Exposing with CLOSED shutter...')
end

mmc.snapImage(); 
disp('Exposure Complete')
img = mmc.getImage(); 


frame = reshape(img,mmc.getImageWidth(),[]);
frame = fliplr(frame);
frame = uint16(frame(1:size(frame,2),:));
