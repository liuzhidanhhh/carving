I=imread('xm.jpg');

%ʵ��ͼ���ѹ��
nr=5; %���������
nc=10; %���������
 [Ic, T, rmIdxs, rmIdxs0] = carv1(I, nr, nc);
figure,imshow(Ic);
imwrite(Ic,'remove.png');

%ʵ��ͼ�������
nr=5;
nc=10;
[Ic, T, rmIdxs, rmIdxs0] = carvAdd(I, nr, nc);
figure,imshow(Ic);
imwrite(Ic,'add.png');

%Ĩ��ͼƬ��ѡ������
nr=70;
nc=1;
[BW,xi,yi] = genmask(I);
[Ic, T, rmIdxs, rmIdxs0] = suppress_carv(I, nr, nc,BW);
figure,imshow(Ic);
imwrite(Ic,'suppress.png')
%����ͼ���ѡ������
[BW,xi,yi] = genmask(I);
[Ic, T, rmIdxs, rmIdxs0] = reserve_carv(Im, nr, nc,BW);
figure,imshow(Ic);
inwrite(Ic,'reserve.png')