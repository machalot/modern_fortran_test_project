submodule (demomodule) demosubmod
  implicit none

  contains
    module procedure dummy
      b = a*2
    end procedure dummy

end submodule demosubmod    
