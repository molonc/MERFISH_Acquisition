row = [1 2 3];
column = [0 1 2 3];
order = [10 7 6 5 11 8 1 4 12 9 2 3];
count  = 1;
handles.height = 2160;
handles.width = 2560;
handles.umPERpixel = round(276/handles.width,3);
handles.scale = round(200*handles.umPERpixel);
for i = 1 : numel(row)
    for j = 1:numel(column)
img473 = imread(['D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\try 5\try5\5\(',num2str(row(i)),', ',num2str(column(j)),')\473nm, Raw\Image_1_',num2str(order(count)),'.tiff']);
imgflat = imread('D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\Flat field\473.tif');
img_corrected = img473 - imgflat;
img_corrected(handles.height-50:handles.height-40,handles.width-250:handles.width-50)= 65535;
text = [num2str(handles.scale),'um'];
color = 'white';
box_color = 'black';
location = [2370 2060];
img_corrected = insertText(img_corrected,location,text,'FontSize',25,'BoxColor',box_color,'BoxOpacity',0.6,'TextColor',color);
imwrite(img_corrected, ['D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\try 5\try5\5\Flatfield_corrected\473\473,Image_1_',num2str(order(count)),'.tiff']);

img647 = imread(['D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\try 5\try5\5\(',num2str(row(i)),', ',num2str(column(j)),')\647nm, Raw\Image_1_',num2str(order(count)),'.tiff']);
imgflat = imread('D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\Flat field\647.tif');
img_corrected = img647 - imgflat;
img_corrected(handles.height-50:handles.height-40,handles.width-250:handles.width-50)= 65535;
text = [num2str(handles.scale),'um'];
color = 'white';
box_color = 'black';
location = [2370 2060];
img_corrected = insertText(img_corrected,location,text,'FontSize',25,'BoxColor',box_color,'BoxOpacity',0.6,'TextColor',color);
imwrite(img_corrected, ['D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\try 5\try5\5\Flatfield_corrected\647\647,Image_1_',num2str(order(count)),'.tiff']);

img750 = imread(['D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\try 5\try5\5\(',num2str(row(i)),', ',num2str(column(j)),')\750nm, Raw\Image_1_',num2str(order(count)),'.tiff']);
imgflat = imread('D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\Flat field\750.tif');
img_corrected = img750 - imgflat;
img_corrected(handles.height-50:handles.height-40,handles.width-250:handles.width-50)= 65535;
text = [num2str(handles.scale),'um'];
color = 'white';
box_color = 'black';
location = [2370 2060];
img_corrected = insertText(img_corrected,location,text,'FontSize',25,'BoxColor',box_color,'BoxOpacity',0.6,'TextColor',color);
imwrite(img_corrected, ['D:\20180723 4t1 EEF2 cleared\After rejigging fluidics\eef2_cleared_after_rejig\try 5\try5\5\Flatfield_corrected\750\750,Image_1_',num2str(order(count)),'.tiff']);

count = count + 1;
    end
end

