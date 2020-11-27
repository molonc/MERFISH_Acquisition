function darkCapture
        
        lamp = get(handles.lampvoltage_edit, 'string')
        set(handles.lampvoltage_edit,'string','0');
        fprintf(handles.s, 'HPCV1,0')
        pause(1)
        
        if(exist('CurrentDarkfields', 'dir'))
            rmdir('CurrentDarkfields','s');
        end
        if(~exist('CurrentDarkfields', 'dir'))
            mkdir('CurrentDarkfields');
        end
        
        handles.darks = zeros(2048, 2048, numel(cri_lambda));
        ii = 1;
        for jj=1:numel(cri_lambda)
            jj
            
            disp(['Wavelength: ',num2str(cri_lambda(jj)),'nm'])
            
            idx = find(TExposureTimes(:,1) == cri_lambda(jj));
            if(numel(idx) ==  1)
                exposure = TExposureTimes(idx,2);
            end
            
            handles.darks(:,:,jj) = double(exposeImage( cri_lambda(jj), exposure, 1, 'Raw', 'Dark'));
            imwrite(uint16(handles.darks(:,:,jj)), ['CurrentDarkfields\', num2str(cri_lambda(jj)), 'nm_DarkField.TIFF']);
            
        end
        
        %exposureTimes
        %handles.exposureTimes = exposureTimes;
        set(handles.status_text,'String','... DONE ...')
        
        set(handles.lampvoltage_edit,'string',lamp);
        fprintf(handles.s, ['HPCV1,',lamp])
        
        guidata(hObject, handles);     
end