# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog


VERILOG_SOURCES += src/processing_element.sv

EXTRA_ARGS += --trace-fst --trace-structs


# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = processing_element

# MODULE is the basename of the Python test file
MODULE = processing_element_tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

waves:
	gtkwave dump.fst waves.gtkw


