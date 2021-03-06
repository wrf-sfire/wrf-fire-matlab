function U = poisson_fft3z(F,h,w)
% solve poisson equation in nD, n up to 3 supported
% - div D grad U = F
% D is diag(d(1)I, d(2)I, d(3)I)
if ~exist('w','var'),
    w=[1,1,1];
end
p = length(h);
if p~=3 & p~=2,
    error('poisson_fft3z: only 2 or 3 dimensions supported')
end
n = ones(1,3);
n(1:ndims(F)) = size(F);
U = F;
X={0,0,0};
for i=1:p
    X{i}=w(i)*poisson_1d_eig(n(i),h(i));
    U=dstn(U,i);
end
if 1  % faster
    u1=zeros(n(1),1,1); u1(:,1,1)=X{1};
    u2=zeros(1,n(2),1); u2(1,:,1)=X{2};
    u3=zeros(1,1,n(3)); u3(1,1,:)=X{3};
    U=U./(repmat(u1,1,n(2),n(3))+repmat(u2,n(1),1,n(3))+repmat(u3,n(1),n(2),1));
else
    for i3=1:n(3)
        for i2=1:n(2)
            for i1=1:n(1)
                U(i1,i2,i3)=U(i1,i2,i3)/(X{1}(i1)+X{2}(i2)+X{3}(i3));
            end
        end
    end
end
for i=1:p
    U=dstn(U,i);
end
U=U*(2^p)/prod(n(1:p)+1); % scale for nonunitary DST



