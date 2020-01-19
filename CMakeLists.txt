cmake_minimum_required(VERSION 3.10.2)

# set the project name
project(testproj Fortran)

# add the executable
add_executable(a.out main.f90 vecmodule.f90 demomodule.f90 demosubmod.f90)
