/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module rows_builder
	#(
	parameter N_ROWS=4,
	parameter N_COLUMNS=2
	)
	(
	input logic 						  		 				 clk,
	input logic 						  		 				 rst,
	input logic [`WIDTH-1:0] 		   					     data_in,
	input logic    				   		 				 read_enable,

	output logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] 		 out,
	output logic 				   		 				 finish_read
	);


		logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] 		matrix;

		logic [3:0] 			 	 					rows_counter;
		//logic 			   	   	 				  start_rows_counter;

		logic [3:0]									 columns_counter;
		logic								   start_columns_counter;


		always_comb begin
			if(!finish_read) begin
				matrix[rows_counter][columns_counter] = data_in;
				//$display("rows = %x", rows);
				//finish_read = 0;
			end
		end


		always_ff @(posedge clk or negedge rst) begin
			if (!rst) begin
				rows_counter 	<= 0;
				columns_counter <= 0;
				finish_read 	<= 0;
			end
			// both rows and columns counters went through all the values in the matrix -> finish reading operation
			if (rows_counter == N_ROWS-1 && columns_counter == N_COLUMNS-1) begin
				finish_read  	<= 1;
				rows_counter 	<= 0;
				columns_counter <= 0;
			end
			// Finished columns but not all rows, increment row counter
			else if (rows_counter != N_ROWS-1 && columns_counter == N_COLUMNS-1) begin
				rows_counter    <= rows_counter + 1;
				columns_counter <= 0;
			end
			// Increment column counter
			else if(start_columns_counter) columns_counter <= columns_counter + 1;


			// if (rows_counter == N_ROWS-1 && columns_counter == N_COLUMNS-1) begin
			// 	finish_read  	<= 1;
			// 	rows_counter 	<= 0;
			// 	columns_counter <= 0;
			// end else if (start_rows_counter) begin
			// 	rows_counter <= rows_counter +1 ;
			// end
		end

		always_ff @(posedge clk or negedge rst) begin
			if (!rst) begin 
				start_columns_counter <= '0;
			end
			else if(read_enable) begin 
				start_columns_counter <= 1;
			end
		end

		assign out = finish_read ? matrix : '0;


endmodule