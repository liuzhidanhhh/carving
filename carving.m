I=imread('xm.jpg');

%实现图像的压缩
nr=5; %抽掉的行数
nc=10; %抽调的列数
 [Ic, T, rmIdxs, rmIdxs0] = carv1(I, nr, nc);
figure,imshow(Ic);
imwrite(Ic,'remove.png');

%实现图像的膨胀
nr=5;
nc=10;
[Ic, T, rmIdxs, rmIdxs0] = carvAdd(I, nr, nc);
figure,imshow(Ic);
imwrite(Ic,'add.png');

%抹掉图片的选定内容
nr=70;
nc=1;
[BW,xi,yi] = genmask(I);
[Ic, T, rmIdxs, rmIdxs0] = suppress_carv(I, nr, nc,BW);
figure,imshow(Ic);
imwrite(Ic,'suppress.png')
%保留图像的选定内容
[BW,xi,yi] = genmask(I);
[Ic, T, rmIdxs, rmIdxs0] = reserve_carv(Im, nr, nc,BW);
figure,imshow(Ic);
inwrite(Ic,'reserve.png')