module module_f_assembly
       use module_hexa
       use module_utils
       
contains
subroutine f_assembly(                        &
    ifds, ifde, kfds, kfde, jfds, jfde,           & ! fire grid dimensions
    ifms, ifme, kfms, kfme, jfms, jfme,           &
    ifps, ifpe, kfps, kfpe, jfps, jfpe,           & ! fire patch bounds
    ifts, ifte, kfts, kfte, jfts,jfte,            &
    A, X, Y, Z, Xu0, Yu0, Zu0,                    & !Input from femwind, U0, V0, W0 not used in hexa to construct Kloc or JG
    F)                                             !Global load vector output  

implicit none


!*** arguments

integer, intent(in)::                             &
    ifds, ifde, kfds,kfde, jfds, jfde,            & ! fire grid dimensions
    ifms, ifme, kfms,kfme, jfms, jfme,            &
    ifps, ifpe, kfps, kfpe, jfps, jfpe,           & ! fire patch bounds
    ifts, ifte, kfts, kfte, jfts,jfte            




real, intent(in), dimension(3,3):: A
real, intent(in), dimension(ifms:ifme, kfms:kfme, jfms:jfme):: X,Y,Z, &     !spatial grid at cornersw
                                                               Xu0,Yu0,Zu0  !wind vector at midpoint
!Input for hexa

!integer,intent(in)::F_dim

real,intent(out), dimension(ifms:ifme, kfms:kfme, jfms:jfme)::F

!*** local

integer:: ie1, ie2, ie3, ic1, ic2, ic3, iloc, k1, k2, k3, id1, id2, id3
real :: Kloc(8,8), Floc(8), Jg(8,3), vol
real ::  Xloc(3,8), u0loc(3) 
integer :: kglo(8)
!*** u0loc is an input for module_hexa, but is not used to construct K. Do I need to define this?
!*** integer, dimension(3,1,1), save ::iflags = reshape((/1,0,1/),(/3,1,1/)) !define iflags to construct JG and Kloc in hexa

!call  write_array(reshape(A,(/3,3,1/)),'A_in')
!call  write_array(X(ifts: ifte+1, kfts: kfte+1, jfts:jfte+1),'X_in')
!call  write_array(Y(ifts: ifte+1, kfts: kfte+1, jfts:jfte+1),'Y_in')
!call  write_array(Z(ifts: ifte+1, kfts: kfte+1, jfts:jfte+1),'Z_in')
!call  write_array(Xu0(ifts: ifte, kfts: kfte, jfts:jfte),'u0_in')
!call  write_array(Yu0(ifts: ifte, kfts: kfte, jfts:jfte),'v0_in')

!call  write_array(Zu0(ifts: ifte, kfts: kfte, jfts:jfte),'w0_in')
Xloc = 9999.
u0loc = 0.
F = 0.

!** executable
do ie2=jfts,jfte
    do ie3=kfts,kfte
        do ie1=ifts,ifte
            do ic2=0,1
                do ic3=0,1
                    do ic1=0,1
                        iloc=1+ic1+2*(ic2+2*ic3)  !local index of the node in the element
                        Xloc(1,iloc)=X(ie1 + ic1, ie3 + ic3, ie2 + ic2)
                        Xloc(2,iloc)=Y(ie1 + ic1, ie3 + ic3, ie2 + ic2)
                        Xloc(3,iloc)=Z(ie1 + ic1, ie3 + ic3, ie2 + ic2)
                    enddo
                enddo
            enddo
            u0loc(1) = Xu0(ie1,ie3,ie2)
            u0loc(2) = Yu0(ie1,ie3,ie2)
            u0loc(3) = Zu0(ie1,ie3,ie2)
            
            call hexa(A,Xloc,Kloc,Jg,vol,2)
            Floc = -vol*matmul(Jg,u0loc)
            do id2 = 0,1
                do id3 = 0,1
                    do id1 = 0,1
                        iloc=1+id1+2*(id2+2*id3)  !local index of the node in the element
                        k1 = ie1+id1
                        k2 = ie2+id2
                        k3 = ie3+id3
                        F(k1,k3,k2) = F(k1,k3,k2) + Floc(iloc)
                    enddo
                enddo
            end do
        enddo
    enddo
enddo

!call  write_array(F(ifts: ifte+1, kfts: kfte+1, jfts:jfte+1),'F_out')

end subroutine f_assembly
end module  module_f_assembly
