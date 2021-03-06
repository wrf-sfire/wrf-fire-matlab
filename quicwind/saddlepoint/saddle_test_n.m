n=100
f=2
fprintf('linear array of %i cells with %i faces each\n',n,f)
B=sparse(f*n);
D=sparse(n,f*n);
C=sparse(n,f*n);
if n<200, B=full(B);D=full(D);C=full(C); end
for i=1:n
    s=(i-1)*f+1:i*f;    % span of local dofs
    B(s,s)=eye(f);
    % B(s,s)=rand(f);
    D(i,s)=ones(1,f);
    C(i,s(end))=1;
    if i<n,
        C(i,s(end)+1)=1; 
    else
        disp('flux boundary condition on last cell')
    end
end
v0 = rand(f*n,1);
saddle_sparse
if n<10,M,end
