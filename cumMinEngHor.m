function [My, Tby] = cumMinEngHor(e)
% e is the energy map.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.

[ny,nx] = size(e);
My = zeros(ny, nx);
Tby = zeros(ny, nx);
My(:,1) = e(:,1);

%% Add your code here
for i=2:nx
   for j=1:ny
       if j==1
           My(j,i)=min(My(j,i-1),My(j+1,i-1))+e(j,i);  
           Tby(j,i)=min(find([My(j,i-1),My(j+1,i-1)]==min(My(j,i-1),My(j+1,i-1))))-1;
       elseif j==ny
           My(j,i)=min(My(j,i-1),My(j-1,i-1))+e(j,i);
           Tby(j,i)=min(find([My(j,i-1),My(j-1,i-1)]==min(My(j,i-1),My(j-1,i-1))))-2;
       else
           My(j,i)=min([My(j-1,i-1),My(j,i-1),My(j+1,i-1)])+e(j,i);
           Tby(j,i)=min(find([My(j-1,i-1),My(j,i-1),My(j+1,i-1)]==min([My(j-1,i-1),My(j,i-1),My(j+1,i-1)])))-2;
       end
   end
end

end