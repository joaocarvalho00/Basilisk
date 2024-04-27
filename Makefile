# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog


VERILOG_SOURCES += src/tpu.sv
VERILOG_SOURCES += src/processing_element.sv

EXTRA_ARGS += --trace-fst --trace-structs


# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = tpu

# MODULE is the basename of the Python test file
# MODULE = processing_element_tb
MODULE = tpu_basic_matmult_test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim


waves:
	gtkwave dump.fst waves_tpu.gtkw


