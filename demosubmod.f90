submodule (demomodule) demosubmod
  implicit none

  contains
    module procedure idummy
      b = a*2
    end procedure idummy

    module procedure ddummy
      b = a*2.d0
    end procedure ddummy

end submodule demosubmod
