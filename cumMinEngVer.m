function [Mx, Tbx] = cumMinEngVer(e)
% e is the energy map.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.

[ny,nx] = size(e);
Mx = zeros(ny, nx);
Tbx = zeros(ny, nx);
Mx(1,:) = e(1,:);

%% Add your code here
for i=2:ny
   for j=1:nx
       if j==1
           Mx(i,j)=min(Mx(i-1,j),Mx(i-1,j+1))+e(i,j);  
           Tbx(i,j)=min(find([Mx(i-1,j),Mx(i-1,j+1)]==min(Mx(i-1,j),Mx(i-1,j+1))))-1;
       elseif j==nx
           Mx(i,j)=min(Mx(i-1,j-1),Mx(i-1,j))+e(i,j);
           Tbx(i,j)=min(find([Mx(i-1,j-1),Mx(i-1,j)]==min(Mx(i-1,j-1),Mx(i-1,j))))-2;
       else
           Mx(i,j)=min([Mx(i-1,j-1),Mx(i-1,j),Mx(i-1,j+1)])+e(i,j);
           Tbx(i,j)=min(find([Mx(i-1,j-1),Mx(i-1,j),Mx(i-1,j+1)]==min([Mx(i-1,j-1),Mx(i-1,j),Mx(i-1,j+1)])))-2;
       end
   end
end
A=[1 0 0 0 0 0 0 0 1;
    1 0.5 0 0 0 0 0 0.5 1;
    1 0.5 0.5 0 0 0  0.5 0.5 1;
    1 0.5 0.5 0.5 0 0.5 0.5 0.5 1;
    1 0.5 0.5 0.5 0.5 0.5 0.5 0.5 1;
    1 0.5 0.5 0.5 0 0.5 0.5 0.5 1;
    1 0.5 0.5 0 0 0 0.5 0.5 1;
    1 0.5 0 0 0 0 0 0.5 1;
    1 0 0 0 0 0 0 0 1;
];

end
