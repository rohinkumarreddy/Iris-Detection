function iris_d()
clear all;
close all;
clc;
ButtonName = questdlg('Enable Debug Mode?', 'Please Select', 'No');
if strcmp(ButtonName,'Yes')==1
debug=1;
else
    debug=0;
end
[FileName,~] = uigetfile('*.bmp','Select the input image file');
x_g=imread(FileName);
if size(x_g,3) == 3
    x_g=rgb2gray(x_g);
end
[r,c]=size(x_g);
x_v=imcomplement(x_g);
x_bw=im2bw(x_v,0.9);

[p_centre,p_radii]=imfindcircles(x_bw,[42 45],'ObjectPolarity','bright','sensitivity',0.99);
%p_centre=median(p_centre1);
%p_radii=median(p_radii1);
x_co=imadjust(x_g,[],[],3.75);

x_co_v=imcomplement(x_co);
x_co_bw=im2bw(x_co_v,0.9);

for i=2:r-1
    for j=2:c-1
        med=[x_co_bw(i-1,j-1), x_co_bw(i-1,j), x_co_bw(i-1,j+1), x_co_bw(i,j-1), x_co_bw(i,j), x_co_bw(i,j+1), x_co_bw(i+1,j-1), x_co_bw(i+1,j), x_co_bw(i+1,j+1)];
        x_co_bw_m(i,j)=median(med);
    end
end

[i_centre,i_radii]=imfindcircles(x_co_bw_m,[102 103],'ObjectPolarity','bright','sensitivity',0.997);
normalized= iris_normalise( x_g, p_centre(2), p_centre(1), p_radii , i_centre(2) , i_centre(1) , i_radii);

[E0,filtersum] = gaborconvolve(normalized, 1, 18, 1, 0.5);
[template] = encode1(normalized, 1,E0);

figure(1)
imshow(x_g);%grayscale
title('gray scale')
if debug==1
figure(2)
imshow(x_v);%inverse
title('inverse image')
figure(3)
imshow(x_bw);%black&white
title('black and white')
title('pupil detection');
h1 = viscircles(p_centre,p_radii,'EdgeColor','r');
figure(4)
imshow(x_g)
title('pupil detection overlayed onto resized image');
h1 = viscircles(p_centre,p_radii,'EdgeColor','r');
figure(5)
imshow(x_co)
title('Gamma corrected image');
figure(6)
imshow(x_co_bw)
title('gamma corrected binarized image');
figure(7)
imshow(x_co_bw_m)
title('median filtered binarized gamma corrected image');
figure(9)
imshow(x_co_bw_m)
title('detecting the boundary between Iris and Sclera');
h2 = viscircles(i_centre,i_radii,'EdgeColor','r');
end
figure(10)
imshow(x_g)
title('Detecting the Iris annular ring');
h3=viscircles(i_centre,i_radii,'EdgeColor','r');
h4=viscircles(p_centre,p_radii,'EdgeColor','r');
figure(11)
imshow(uint8(normalized))
title('Normalized Iris image');
figure(12)
imshow(template);
title('Encoded Iris image');
cd('Database');
%for i=1:
 %   p=num2str(i);
  %  a=['template_',p];
   % template1=imread(a,'bmp');
    %hd=hamdist(template,template1,1);
%end
[filename, pathname] = uiputfile('template.bmp', 'Save the template as');
if filename~=[];
imwrite(template,filename);
end
cd ..;