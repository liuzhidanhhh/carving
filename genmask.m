function [BW,xi,yi] = genmask(im1)
figure(1);clf;%imshow(im1);
[BW,xi,yi]=roipoly(im1);
save('source.mat','BW','xi','yi');