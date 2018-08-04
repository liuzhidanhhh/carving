function [Ix, E,rmIdx] = addVerSeam(I, Mx, Tbx)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image add one column.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(ny, 1);
Ix = uint8(zeros(ny, nx-1, nz));

%% Add your code here
%seam 路径
rmIdx(ny,1)=min(find(Mx(ny,:)==min(Mx(ny,:))));
for i=ny:-1:2
    rmIdx(i-1,1)=rmIdx(i,1)+Tbx(i,rmIdx(i,1));
end
%移除seam列，得到Iy
for i=1:ny
    for j=1:nx+1
        if j<=rmIdx(i,1) 
            Ix(i,j,:)=I(i,j,:);
        else
            Ix(i,j,:)=I(i,j-1,:);
        end
    end
end
%计算E
E=min(Mx(ny,:));
end