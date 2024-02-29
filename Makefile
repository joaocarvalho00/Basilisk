# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += src/defines.sv
VERILOG_SOURCES += src/data_types_pkg.sv
VERILOG_SOURCES += src/helper_functions_pkg.sv
VERILOG_SOURCES += src/ram.sv
VERILOG_SOURCES += src/rows_builder.sv
VERILOG_SOURCES += src/control.sv
VERILOG_SOURCES += src/convolutor.sv
#VERILOG_SOURCES = count_up.sv

EXTRA_ARGS += --trace-fst --trace-structs

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = convolutor

# MODULE is the basename of the Python test file
MODULE = testbench

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim