module vecmodule
!use dpmodule ! module dependency
use, intrinsic :: iso_fortran_env, dp => real64

implicit none

private ! hide direct access to derived types and bound procedures

! derived object type (i.e. class)
type, public :: vector
  real(dp) :: x, y, z
  contains
    procedure :: magnitude
end type vector

! apparently all identically named generic procedures in scope are combined, so
! augment demomodule generic procedure halfmag in with a form that handles vectors
public :: halfmag
interface halfmag
  module procedure halfmag_vec
end interface halfmag

! define specific procedures of vector class
contains
  real(dp) function magnitude(this) result(mag)
    implicit none
    class(vector) :: this
    mag = norm2( [this%x, this%y, this%z] ) ! in-line array constructor
  end function magnitude

  real(dp) function halfmag_vec(this) result(y)
    implicit none
    type(vector), intent(in) :: this
    y = 0.5d0*this%magnitude()
  end function halfmag_vec

end module vecmodule
