/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module convolutor (
	input logic 								clk,    
	input logic 								rst,
	input logic 					start_operation,
	input logic [3:0] 			   			   addr,

	output logic [`N_ROWS-1:0][`WIDTH-1:0] 		out
);

	logic read_enable;
	logic finish_read;

	control ctrl_m(
		.clk							(clk),
		.rst 							(rst),
		.start_operation	(start_operation),
		.finish_read			(finish_read),

		.read_enable    		(read_enable),
		/* verilator lint_off PINCONNECTEMPTY */
		.conv_start     		 		   ()
		/* verilator lint_off PINCONNECTEMPTY */
		);

	rows_builder rows_m(
		.clk							(clk),
		.rst 							(rst),
		.addr 						   (addr),
		.read_enable   			(read_enable),

		.out 							(out),
		.finish_read 			(finish_read)
		);




endmodule : convolutor