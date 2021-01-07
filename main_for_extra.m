%% load image 
clear
close all
I = imread('ex1.pgm'); % I = imread('ex2.pgm');
[m,n]=size(I);
figure(1),imshow(I);title('original image')
%% using edge to improve global Thresholding
% edge detection
h = edge(I,'canny');
level=otsu(h*255); % input of otsu() must range in [0 255]
% binary image result
BW=im2bw(I,level/255);
figure(2),imshow(BW);title('Using Edge to Improve Global Thresholding')
%% use 'One component at a time' algorithm referrenced by Wiki to compute the connected regions
% one_pass() is a function for calculating the number of connected regions
num_conc = one_pass(BW);
Print = ['The number of connected regions in step 1 binary image is ',num2str(num_conc)];
disp(Print);
%% use erosion and dilation to correct region detection
SE=ones(9,9);
openBW=dilate(erode(BW,SE),SE);
figure(3),imshow(openBW);title('Corrected Region Detection')
%% use 'One component at a time' algorithm compute the connected regions
% one_pass() is a function for calculating the number of connected regions
% and their labels
num_conc = one_pass(openBW);
Print = ['The number of connected regions in step 3 binary image is ',num2str(num_conc)];
disp(Print);
%% produce a pseudo-color image
% The liver is the largest connected region in the left half of the openBW picture
liver_mask = zeros(m,n);liver_mask(:,1:floor(n/2))=1;
liver_region = find_max_area(openBW.*liver_mask);
figure(4),subplot(2,2,1),imshow(liver_region);title('liver')
% The left kidney is the largest connected region in the lower left part
% except the liver region
kidney1_mask = zeros(m,n);kidney1_mask(floor(0.4*m):m,1:floor(n/2))=1;
kidney1_region = find_max_area(openBW.*kidney1_mask.*~liver_region);
figure(4),subplot(2,2,2),imshow(kidney1_region);title('kidney1')
% The right kidney is the largest connected region in the lower right part
kidney2_mask = zeros(m,n);kidney2_mask(floor(0.4*m):m,floor(n/2):n)=1;
kidney2_region = find_max_area(openBW.*kidney2_mask);
figure(4),subplot(2,2,3),imshow(kidney2_region);title('kidney2')
% The spleen is the largest connected region 
spleen_mask = zeros(m,n);spleen_mask(:,floor(0.8*512):n)=1;
erodeBW=erode(BW,ones(25,25));
if sum(sum(erodeBW.*spleen_mask))==0
    spleen_region = zeros(m,n);
else
    spleen_region = find_max_area(erodeBW.*spleen_mask);    
    spleen_region2 = dilate(spleen_region,SE)&openBW;
    while sum(sum(spleen_region2 - spleen_region))~=0
        spleen_region = spleen_region2;
        spleen_region2 = dilate(spleen_region,SE)&openBW;
    end
end 
figure(4),subplot(2,2,4),imshow(spleen_region);title('spleen')

interest_region = liver_region| kidney1_region| kidney2_region| spleen_region;
figure(5),imshow(interest_region);title('The organs of interests')
%% produce pseudo-color image 
r = zeros(m,n); g = r; b = r;
r(liver_region|kidney1_region| kidney2_region)=255;
g(spleen_region|kidney1_region| kidney2_region)=255;
f2 = cat(3,r,g,b);
figure(6),imshow(f2);title('Pseudo-color Image'); 