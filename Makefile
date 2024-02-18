compile: 
	verilator -Wall --trace -cc src/defines.sv src/helper_functions_pkg.sv src/data_types_pkg.sv src/control.sv src/ram.sv src/rows_builder.sv src/convolutor.sv --top-module convolutor --prefix convolutor --exe convolutor_tb.cpp
	make -C obj_dir -f convolutor.mk convolutor

run:
	./obj_dir/convolutor
	mv waveform.vcd obj_dir

waves:
	gtkwave obj_dir/waveform.vcd sim/basic_debug.gtkw

clean:
	rm -r logs/*
	rm -r obj_dir/*
	rm -f waveform.vcd	