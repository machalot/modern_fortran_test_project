module demomodule
use, intrinsic :: iso_fortran_env, dp => real64
use vecmodule ! module dependency

implicit none

private ! make everything private by default
public :: dp

! but make all these variables public to demonstrate globals
real(dp), public :: a 
integer, public :: c
complex(dp), public :: e
type(vector), public :: g
real(dp), dimension(4), public :: p
real(dp), dimension(:), allocatable, public :: r, t
real(dp), dimension(3,3), public :: v, x

!interface dummy
!    module procedure idummy
!    module procedure ddummy
!end interface dummy

interface dummy
  module subroutine idummy(a,b)
    implicit none
    integer, intent(in) :: a
    integer, intent(out) :: b
  end subroutine idummy

  module subroutine ddummy(a,b)
    implicit none
    real(dp), intent(in) :: a
    real(dp), intent(out) :: b
  end subroutine ddummy
end interface dummy

! create generic procedure interface to handle various input argument types
public :: halfmag
interface halfmag
  module procedure halfmag_dp
  module procedure halfmag_int
  module procedure halfmag_cpx
  module procedure halfmag_ary
!  module procedure halfmag_vec ! even works with procedures from other used modules
end interface halfmag

! define specific procedures for each input argument type
contains 
  real(dp) function halfmag_dp(x) result(y)
    implicit none
    real(dp), intent(in) :: x
    y = 0.5d0*abs(x)
  end function halfmag_dp

  integer function halfmag_int(x) result(y)
    implicit none
    integer, intent(in) :: x
    y = abs(x)/2
  end function halfmag_int

  real(dp) function halfmag_cpx(x) result(y)
    implicit none
    complex(dp), intent(in) :: x
    y = 0.5d0*hypot(real(x),aimag(x))
  end function halfmag_cpx

  real(dp) function halfmag_ary(x) result(y)
    implicit none
    real(dp), intent(in) :: x(:)
    y = 0.5d0*norm2(x)
  end function halfmag_ary

!  real(dp) function halfmag_vec(this) result(y)
!    implicit none
!    type(vector), intent(in) :: this
!    y = 0.5d0*this%magnitude()
!  end function halfmag_vec

end module demomodule
