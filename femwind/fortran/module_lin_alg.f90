module module_lin_alg

use module_utils

contains

subroutine inv3(M, M_inv, det)
!Purpose: Calculate the inverse of a 3X3 matrix
!In:
!M  3X3 matrix
!det determinand of M
!Out:
!M_inv Inverse of M 
implicit none
real,intent(in), dimension(3,3):: M
real,intent(out), dimension(3,3):: M_inv
real,intent(out), optional:: det

!Local Variables

real :: detM


    ! Compute M_inv
    detM  = (M(1,1)*M(2,2)*M(3,3) - M(1,1)*M(2,3)*M(3,2)-&
             M(1,2)*M(2,1)*M(3,3) + M(1,2)*M(2,3)*M(3,1)+&
             M(1,3)*M(2,1)*M(3,2) - M(1,3)*M(2,2)*M(3,1))

    if(abs(detM).lt.10.0*tiny(detM))then
        print *,'detM=',detM
        call crash('The matrix is numerically singular')
    endif
  
    if (present(det)) det = detM 

    detM = 1.0/detM

    M_inv(1,1) = +detM * (M(2,2)*M(3,3) - M(2,3)*M(3,2))
    M_inv(2,1) = -detM * (M(2,1)*M(3,3) - M(2,3)*M(3,1))
    M_inv(3,1) = +detM * (M(2,1)*M(3,2) - M(2,2)*M(3,1))
    M_inv(1,2) = -detM * (M(1,2)*M(3,3) - M(1,3)*M(3,2))
    M_inv(2,2) = +detM * (M(1,1)*M(3,3) - M(1,3)*M(3,1))
    M_inv(3,2) = -detM * (M(1,1)*M(3,2) - M(1,2)*M(3,1))
    M_inv(1,3) = +detM * (M(1,2)*M(2,3) - M(1,3)*M(2,2))
    M_inv(2,3) = -detM * (M(1,1)*M(2,3) - M(1,3)*M(2,1))
    M_inv(3,3) = +detM * (M(1,1)*M(2,2) - M(1,2)*M(2,1))

end subroutine inv3

subroutine print_matrix(name,A)
character(len=*)::name
real :: A(:,:)
integer i,j
print *,'Matrix ',trim(name),lbound(A,1),':',ubound(A,1),' by ', &
                          lbound(A,2),':',ubound(A,2)
do i=lbound(A,1),ubound(A,1)
    print *,(A(i,j),j=lbound(A,2),ubound(A,2))
enddo
end subroutine print_matrix

end module module_lin_alg 
