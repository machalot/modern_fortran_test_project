program testproj
!use dpmodule    ! contains type/kind parameters
use demomodule, only : dp, a, c, e, g, p, r, t, v, x, halfmag ! global variables and procedures

! local variables
implicit none
real(dp) :: b, f, h, q, s, u
real(dp), dimension(3) :: w, y
integer :: d, i

! Populate variable values with random data
a = -1.9d0 ! d0 still works for double precision
c = -21

e = (999.0_dp, 888.0_dp) ! complex number intrinsic type

g%x = 20.1_dp; g%y = 30.0_dp; g%z = 40.0_dp ! multiple commands on one line

p = [0.2d0, 0.4d0, 0.6d0, 0.8d0] ! convenient array constructor
! p = (/ 0.2d0, 0.4d0, 0.6d0, 0.8d0 /) ! older equivalent form

allocate(r(4))  ! explicit dynamic memory allocation
r = 0.1d0*[(i, i=2,8,2)] ! implicit do loop with stride

t = [-1.d0, -2.d0, -3.d0, -5.d0, -8.d0, -13.d0] ! implicit dynamic memory allocation using array constructor

! construct 3x3 matrix in column major order
v = reshape([1.d0, 2.d0, 3.d0, 4.d0, 5.d0, 6.d0, 7.d0, 8.d0, 9.d0], shape(v)) 
! construct 3x3 matrix in row major order
x = reshape([1.d0, 2.d0, 3.d0, 4.d0, 5.d0, 6.d0, 7.d0, 8.d0, 9.d0], shape(x), order=[2,1]) 

! Demonstrate generic function interface
b = halfmag(a) ! real
d = halfmag(c) ! integer
f = halfmag(e) ! complex
h = halfmag(g) ! vector derived type
q = halfmag(p) ! fixed real array
s = halfmag(r) ! explicitly allocated real array
u = halfmag(t) ! implicitly allocated real array

! slices of a matrix
do i = 1,3
  w(i) = halfmag(v(:,i))
  y(i) = halfmag(x(:,i))
end do

write(*,*) 'real:     ',a,b
write(*,*) 'integer:  ',c,d
write(*,*) 'complex:  ',e,f
write(*,*) 'vector:   ',g,h
write(*,*) 'array:    ',p,q
write(*,*) 'expalary: ',r,s
write(*,*) 'impalary: ',t,u
write(*,'(a/,3(a,i2/,4(g24.18/)/))') 'matrix:   ',(' col:',i,[v(:,i),w(i)], i=1,3) ! implicit do loop
write(*,'(a/,3(a,i2/,4(g24.18/)/))') 'matrix:   ',(' col:',i,[x(:,i),y(i)], i=1,3) ! implicit do loop

deallocate(r)
end program testproj
