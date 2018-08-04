function [Ic, T, rmIdxs, rmIdxs0] = suppress_carv(I, nr, nc,mask)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map
% Memory saving way for carving
DEBUG = 0;
[nx, ny, nz] = size(I);
T = zeros(nr+1, nc+1); %标记抽seam 的累积代价
TI = cell(nr+1, nc+1); %记录每次抽一条seam后的结果
rmIdxs = cell(nr+1,nc+1);
pI = zeros(nr+1,nc+1); %标记抽取的方向 1：seam水平 0：seam垂直
Eng=cell(nr+1,nc+1);
TI{1,1} = I;
% remove the horizontal seams
rmHors = [];
e=genEngMap(I);
e=e.*(1-mask);
Eng{1,1}=e;
for i = 2 : nr+1
    [ex,ey,ez]=size(Eng{i-1,1});
    eng=zeros(ex-1,ey,ez);
    % generate the energy map
	%e = genEngMap(TI{i-1, 1});
    % dynamic programming matrix
    [My, Tby] = cumMinEngHor(Eng{i-1,1});
    [TI{i, 1}, E, rmIdxs{i,1}] = rmHorSeam(TI{i-1, 1}, My, Tby);
    for k=1:ey
        for j=1:ex-1
            if j<rmIdxs{i,1}(k) 
                eng(j,k,:)=Eng{i-1,1}(j,k,:);
            else
                eng(j,k,:)=Eng{i-1,1}(j+1,k,:);
            end
        end
    end
    Eng{i,1}=eng;
    % accumulate the energy
	T(i, 1) = T(i-1, 1) + E;
    
    % assign the direction of parent 0 row,1 col
    pI(i,1) = 1;
end

% remove the vertical seams
rmVers = [];
for i = 2 : nc+1
	%e = genEngMap(TI{1, i-1});
    [ex,ey,ez]=size(Eng{1,i-1});
    eng=zeros(ex,ey-1,ez);
	[Mx,Tbx] = cumMinEngVer(Eng{1,i-1});
	[TI{1, i}, E, rmIdxs{1,i}] = rmVerSeam(TI{1, i-1}, Mx, Tbx);
    for k=1:ex
        for j=1:ey-1
            if j<rmIdxs{1,i}(k) 
                eng(k,j,:)=Eng{1,i-1}(k,j,:);
            else
                eng(k,j,:)=Eng{1,i-1}(k,j+1,:);
            end
        end
    end
    Eng{1,i}=eng;
	T(1, i) = T(1, i-1) + E;  
    pI(1,i) = 0;
end
% do the dynamic programming

for i = 2 : nr+1
	for j = 2 : nc+1
		%e = genEngMap(TI{i-1, j});
        [ex,ey,ez]=size(Eng{i-1,j});
        engh=zeros(ex-1,ey,ez);
		[My, Tby] = cumMinEngHor(Eng{i-1,j-1});
		[Iy, Ey, rmHor] = rmHorSeam(TI{i-1, j}, My, Tby);
        for k=1:ey
            for p=1:ex-1
                if p<rmIdxs{i,1}(k) 
                    engh(p,k,:)=Eng{i-1,j-1}(p,k,:);
                else
                    engh(p,k,:)=Eng{i-1,j-1}(p+1,k,:);
                end
            end
        end
 
		
		[ex,ey,ez]=size(Eng{i,j-1});
        engv=zeros(ex,ey-1,ez);
        %e = genEngMap(TI{i, j-1});
		[Mx, Tbx] = cumMinEngVer(Eng{i,j-1});
		[Ix, Ex, rmVer] = rmVerSeam(TI{i, j-1}, Mx, Tbx);
        for k=1:ex
            for p=1:ey-1
                if p<rmIdxs{i,1}(k) 
                    engv(k,p,:)=Eng{i-1,j-1}(k,p,:);
                else
                    engv(k,p,:)=Eng{i-1,j-1}(k,p+1,:);
                end
            end
        end
   
		
		if T(i, j-1) + Ex < T(i-1, j) + Ey
			TI{i, j} = Ix;
			T(i ,j) = T(i, j-1) + Ex;
            rmIdxs{i, j} = rmVer;
            Eng{i,j}=engv;
            pI(i,j) = 0; % inherite from row direction
		else
			TI{i, j} = Iy;
			T(i, j) = T(i-1, j) + Ey;
            rmIdxs{i,j} = rmHor;
            Eng{i,j}=engh;
            pI(i,j) = 1; % inherite from col direction
        end
        
        % suppress the memory for recording intermediate results
        TI{i-1,j} = [];%???为什么要清记录？省空间？
 
	end
end	

%%
% resolving the pathes
optPath = sub2ind([nr+1,nc+1],nr+1,nc+1);
rcur = nr+1; ccur = nc+1; num = nr+nc+1;
while(1)
    if(rcur==1 && ccur==1) break; end % to the top-left corner
    
    % resolve the path
    num = num - 1;
    if(pI(rcur,ccur)==0) 
        ccur = ccur-1;
        optPath = cat(1,sub2ind([nr+1,nc+1],rcur,ccur),optPath);
    elseif pI(rcur,ccur) == 1
        rcur = rcur-1;
        optPath = cat(1,sub2ind([nr+1,nc+1],rcur,ccur),optPath);
    else
        error('Undefined symbol for the direction!');
    end
end

%%
% checking carving along the path
rmIdxs0 = cell(nc+nr,1);
idxs4Im = reshape(1:size(I,1)*size(I,2),[size(I,1),size(I,2)]);
szP = size(I); % initialize the size of the Image;
for i = 2 : nr+nc+1
    % get the szP
    
    % get the index of the shrink point
    [yy,xx] = ind2sub(szP(1:2),rmIdxs{optPath(i)});
    szC = szP;

    
    % check whether the pI is correct
    if(pI(optPath(i))==0)
        szC(2)  = szC(2) - 1;
        idxs4ImC = zeros(szC(1:2));
        singlePath = [];
        for j = 1 : szC(1)
            singlePath = cat(1,singlePath,idxs4Im(j,xx(j)));
            idxs4ImC(j,:) = cat(2, idxs4Im(j, 1:xx(j)-1), idxs4Im(j, xx(j)+1:end));
        end  
    else
        szC(1) = szC(1) - 1;
        idxs4ImC = zeros(szC(1:2));
        singlePath = [];
        for j = 1 : szC(2)
            singlePath = cat(1,singlePath,idxs4Im(yy(j),j));
            idxs4ImC(:,j) = cat(1, idxs4Im(1:yy(j)-1,j), idxs4Im(yy(j)+1:end,j));            
        end  
    end
    
    % save the path and reset the residual pixels
    rmIdxs0{i-1} = singlePath;
    idxs4Im = idxs4ImC;    
    szP = szC;
end

Ic = TI{nr+1,nc+1};

end