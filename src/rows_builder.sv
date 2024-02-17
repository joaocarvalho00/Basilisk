/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module rows_builder
	#(
	parameter N_ROWS=4	
	)
	(
	input logic 						   clk,
	input logic 						   rst,
	input logic [3:0] 					  addr,
	input logic    				   read_enable,

	output logic [`N_ROWS-1:0][`WIDTH-1:0] out,
	output logic 				   finish_read
	);

		ram ram1(	.clk(clk),
		  			.addr(addr),
		  			.data_out(data_out_ram),
		  			.read_enable(read_enable),

		  			/* verilator lint_off PINCONNECTEMPTY */
		  			.data_in(),
		  			.write_enable()
		  			/* verilator lint_off PINCONNECTEMPTY */
			);


		logic [`N_ROWS-1:0][`WIDTH-1:0] 		rows ;
		logic [`WIDTH-1:0] 			 data_out_ram;

		logic [3:0] 			 	 rows_counter;
		logic [3:0] 		 	 read_mem_counter;

		logic 			   	   start_rows_counter;


		always_comb begin
			if(!finish_read) begin
				rows[rows_counter] = data_out_ram;
				$display("rows = %x", rows);
			end
		end



		always_ff @(posedge clk or negedge rst) begin
			if (~rst) begin
				rows_counter 	<= 0;
				finish_read 	<= 0;
			end
			if (rows_counter == N_ROWS-1) begin
				finish_read  <= 1;
				rows_counter <= 0;
			end else if (start_rows_counter) begin
				rows_counter <= rows_counter +1 ;
			end
		end

		always_ff @(posedge clk or negedge rst) begin
			if (~rst) begin 
				read_mem_counter <= '0;
				start_rows_counter <= '0;
			end
			else if(read_mem_counter == 0) begin 
				start_rows_counter <= 1;
			end else read_mem_counter <= read_mem_counter + 1;
		end

		assign out = finish_read ? rows : '0;


endmodule