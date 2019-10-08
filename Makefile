# Find all source files, create a list of corresponding object files
SRCS    := $(wildcard *.f90)
OBJS    := $(patsubst %.f90,%.o,$(SRCS))
OBJDIR  := obj
BINDIR  := bin
MODDIR  := mod
BLDDIRS := $(OBJDIR) $(MODDIR)

# Ditto for mods (They will be in both lists)
MODS      := $(wildcard *mod*.f90)
MOD_OBJS  := $(patsubst %.f90,%.o,$(MODS))
SMODS     := $(wildcard *submod*.f90)
SMOD_OBJS := $(patsubst %.f90,%.o,$(SMODS))

# Compiler/Linker settings
FC      := gfortran
FLFLAGS := 
FCFLAGS := -c -J$(MODDIR) -Wall -Wextra -Wconversion -O2 -pedantic -fcheck=bounds -fmax-errors=5
PROGRAM := testproj
PRG_OBJ := $(PROGRAM).o

# make without parameters will make first target found.
default : $(PROGRAM)

# Compiler steps for all objects, modules, and submodules
$(OBJDIR)/%.o $(MODDIR)/%.mod $(MODDIR)/%.smod : %.f90 | $(BLDDIRS)
	$(FC) $(FCFLAGS) -o $(OBJDIR)/$*.o $< 

## Compiler steps for all module files
#$(MODDIR)/%.mod : %.f90 | $(BLDDIRS)
#	$(FC) $(FCFLAGS) -o $(subst $(MODDIR)/,$(OBJDIR)/,$(patsubst %.mod,%.o,$@)) $<
#
## Compiler steps for all module files
#$(MODDIR)/%.smod : %.f90 | $(BLDDIRS)
#	$(FC) $(FCFLAGS) -o $(subst $(MODDIR)/,$(OBJDIR)/,$(patsubst %.smod,%.o,$@)) $<

# Linker
$(PROGRAM) : $(addprefix $(OBJDIR)/,$(OBJS)) | $(BINDIR)
	$(FC) $(FLFLAGS) -o $(BINDIR)/$@ $^

# Rules to create directories if necessary
$(OBJDIR):
	mkdir -p $(OBJDIR) 
$(MODDIR):
	mkdir -p $(MODDIR)
$(BINDIR):
	mkdir -p $(BINDIR)

# If something doesn't work right, have a 'make debug' to 
# show what each variable contains.
debug:
	@echo "SRCS = $(SRCS)"
	@echo "OBJS = $(OBJS)"
	@echo "MODS = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"
	@echo "SMOD_OBJS = $(SMOD_OBJS)"
	@echo "PROGRAM = $(PROGRAM)"
	@echo "PRG_OBJ = $(PRG_OBJ)"
	@echo "BINDIR  = $(BINDIR)"
	@echo "OBJDIR  = $(OBJDIR)"
	@echo "MODDIR  = $(MODDIR)"
	@echo "Modules = $(addprefix $(MODDIR)/,$(patsubst %.o,%.mod,$(MOD_OBJS)))"
	@echo "Submods = $(wildcard $(addprefix $(MODDIR)/,*@$(patsubst %.o,%.smod,$(SMOD_OBJS))))"

clean:
	rm -rf $(addprefix $(BINDIR)/,$(OBJS)) $(BINDIR)/$(PROGRAM)
	rm -rf $(addprefix $(MODDIR)/,$(patsubst %.o,%.mod,$(MOD_OBJS)))
	rm -rf $(wildcard $(addprefix $(MODDIR)/,*@$(patsubst %.o,%.smod,$(SMOD_OBJS))))
	rm -rf $(BINDIR) $(OBJDIR) $(MODDIR)

re: clean default
	
.PHONY: debug default clean re

# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS) 

# Module dependency
$(OBJDIR)/demosubmod.o : $(MODDIR)/demomodule.smod
$(OBJDIR)/demomodule.o : $(MODDIR)/vecmodule.mod
$(OBJDIR)/main.o       : $(MODDIR)/demomodule.mod
