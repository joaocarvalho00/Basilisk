/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module ram
	#(parameter ADDR_WIDTH = 5,
	  parameter DATA_WIDTH = 8,
	  parameter DEPTH = 16)

	( input clk,
	  input logic [ADDR_WIDTH-1:0] addr,
	  input logic [DATA_WIDTH-1:0] data_in,
	  input read_enable,
	  input write_enable,

	  output logic [DATA_WIDTH-1:0] data_out
	);

	logic [DATA_WIDTH-1:0] mem [DEPTH];
	int file;

	initial begin
		file = $fopen("logs/ram_init_contents.txt","w");
		$fdisplay(file, "#### RAM INITIALIZATION ####\n");

		$readmemh("src/ram_init.txt", mem);
		for (int i = 0; i < DEPTH; i++) begin
			$fdisplay(file, "RAM[%1d] = %x", i, mem[i]);
		end
		$fdisplay(file, "\n#### FINISHED RAM INITIALIZATION ####\n\n");
		$fclose(file);
	end

	always_ff @ (posedge clk) begin
		if (write_enable)
			mem[addr] <= data_in;
	end

	always_ff @ (posedge clk) begin
		if (read_enable)
			data_out <= mem[addr];
	end


endmodule;