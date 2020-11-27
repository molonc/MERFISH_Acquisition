function [ frame ] = GenDarkFrame( exposure, pixelslopes )
%Generates 14-bit DarkFrame based on exposure time.

            frame =  uint16(   ((round( pixelslopes(:,:,1)*exposure + pixelslopes(:,:,2))))  );
    
    %insure no value is larger than 16628
           [r,v]=find(frame>65535);
           frame(sub2ind(size(frame),r,v)) = 65535; 

end

