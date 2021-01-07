clear
close all
%% load image
f = imread('pic1.ppm');
figure(1),imshow(f);title('Original Image');
R = f(:,:,1);
G = f(:,:,2);
B = f(:,:,3);
%% preprocessed image
% The foreground is a big lake whose B value is much larger than G value
% Smooth the image to reduce the irrelevant details to get a better result
I = B;
figure(2),imshow(I);title('B Channel Image');
h = fspecial('gaussian',19,3);
g = imfilter(I,h,'replicate'); 
g(B<G+25)=0; 
figure(3),imshow(g);title('Preprocessed Image');
%% use otsu to get the threshold value      
th = otsu(g); % otsu is my own function writen in otsu.m file 
BW=im2bw(g,th/255); % plot binary image
figure(4),imshow(BW);title('Segementation Result Using Otsu Method');
%% use opening to remove small regions and smooth the contour
% erode and dilate are functions written in erode.m and dilate.m
SE = ones(11,11); 
openedBW = dilate(erode(BW,SE),SE);
figure(5),imshow(openedBW);title('Opening Version of Binary Image');
%% get contour
contourBW=bwperim(openedBW);
figure(6),imshow(contourBW);title('Contour of Binary Image')
% form a white contour
mr = R; mg = G; mb = B;
mr(contourBW)=255;
mg(contourBW)=255;
mb(contourBW)=255;
f2 = cat(3,mr,mg,mb);
figure(7),imshow(f2);title('Output image'); 
