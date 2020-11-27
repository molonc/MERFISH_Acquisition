function [frame, darkframe, exposure] = exposeImage(handles, Iexposure, isExposureKnown)
%cri_lambda = Detection wavelength
%Iexposure = Initial exposuretime or absolute exposuretime
%isExposureKnown = 1 if Iexposure is absolute 0 if Iexposure is
%inital guess
darkframe = zeros(handles.height, handles.width, 'uint16');
%Exposure Time unknown
if(isExposureKnown == 0)
    
    exposure = Iexposure;
    disp('start - initial frame')
    disp(['Capturing with exposure: ' , num2str(exposure), ' ms'])
    
    set(handles.exposureinfo_text,'String',['Exposure Time = ',num2str(exposure),' s'])
    drawnow
    
    %Returning estimated frame capture finish time in CMD window
    A=clock;
    duration_minutes = exposure/60000*2;
    disp(['Estimated finish time: ', num2str(A(4) + floor((A(5)...
        + duration_minutes)/60)), ':', num2str(int8(mod(A(5) + duration_minutes,60)))])
    
    %capture initial image
    frame = AndorZylaCapture(handles.AndorNeoParamHandle,exposure,handles.imagesize,handles.height,handles.width,handles.stride);
    frame_difference = frame - darkframe;
    
end      
end