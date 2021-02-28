function y=ndt_mult(K,x)
%y=nd_mult(K,x)
% multiply vector x by matrix K from nd_assembly
[n1,n2,n3,m]=size(K);
t = ndt_storage_table(m); 
u=reshape(x,n1,n2,n3);  % make x into grid vector if needed
y=zeros(n1,n2,n3);
for j3=-1:1                  
    for j2=-1:1               
        for j1=-1:1
            % i offset i=+1,0,-1 to the location of matrix entry (i,j)
            % in fortran won't have the 2+ because
            % the array t will be indexed -1:1
            o1=t(1,2+j1,2+j2,2+j3);  
            o2=t(2,2+j1,2+j2,2+j3);
            o3=t(3,2+j1,2+j2,2+j3);
            % location j of the matrix entry (i,j) in K(io,j) 
            jx=t(4,2+j1,2+j2,2+j3);
            for i3=1:n3 
                k3 = i3 + j3;
                m3 = i3 + o3;
                for i2=1:n2
                    k2 = i2 + j2;
                    m2 = i2 + o2;
                    for i1=1:n1
                        k1 = i1 + j1;
                        m1 = i1 + o1;
                        % contribution of K(i,j)*x(j) if index not out of bounds
                        % in fortran, we won't need to worry about out of bounds
                        % because K and x will be wrapped with zeros
                        if ~(m1<1 || m1>n1 || m2<1 || m2>n2 || m3<1 || m3>n3 || ...
                             k1<1 || k1>n1 || k2<1 || k2>n2 || k3<1 || k3>n3 )   
                            y(i1,i2,i3)=y(i1,i2,i3)...
                                +K(m1,m2,m3,jx)*u(k1,k2,k3);
                        end
                    end
                 end
            end
        end
    end
end