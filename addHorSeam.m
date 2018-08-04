function [Iy, E,rmIdx] = addHorSeam(I, My, Tby)
% I is the image. Note that I could be color or grayscale image.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.
% Iy is the image add one row.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(1, nx);
Iy = uint8(zeros(ny+1, nx, nz));

%% Add your code here

%seam ·��
rmIdx(1,nx)=min(find(My(:,nx)==min(My(:,nx))));
for i=nx:-1:2
    rmIdx(1,i-1)=rmIdx(1,i)+Tby(rmIdx(1,i),i);
end
%�Ƴ�seam�У��õ�Iy
for i=1:nx
    for j=1:ny+1
        if j<=rmIdx(i) 
            Iy(j,i,:)=I(j,i,:);
        else
            Iy(j,i,:)=I(j-1,i,:);
        end
    end
end
%����E
E=min(My(:,nx));
