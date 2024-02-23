/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */
import helper_functions_pkg::display_weights_logfile;

module convolutor (
	input logic 																clk,    
	input logic 																rst,
	input logic 													start_operation,
	input logic 													 start_load_img,
	input logic [`ADDR_WIDTH_RAM-1:0] 			   			   				   addr,

	output logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] 						out
);

	logic 																read_enable;
	logic 																finish_read;

	logic [`WIDTH-1:0] 												   data_out_ram;
	logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0]					 rows_builder_o;

	/* verilator lint_off UNUSED */
	logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] 							img;
	/* verilator lint_off UNUSED */
	logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] 						weights;
	/* verilator lint_off UNOPTFLAT */
	logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] 				   prev_weights;
	/* verilator lint_off UNOPTFLAT */
	
	logic 															 img_weight_sel;


	ram #(
		.ADDR_WIDTH						(`ADDR_WIDTH_RAM),
		.DATA_WIDTH						(`WIDTH 		),
		.DEPTH							(`DEPTH_RAM 	))

		ram_m(
		// Inputs
		.clk 							(clk 			),
		.addr        					(addr 			),	
		.read_enable 					(read_enable	),
		// Outputs
		.data_out  						(data_out_ram	),
	
		/* verilator lint_off PINCONNECTEMPTY */
		.data_in						(				),
		.write_enable					(				)
		/* verilator lint_off PINCONNECTEMPTY */

		);


	control ctrl_m(
		// Inputs
		.clk							(clk			),
		.rst 							(rst 			),
		.start_operation				(start_operation),
		.start_load_img					(start_load_img ),
		.finish_read					(finish_read 	),
		// Outputs
		.read_enable    				(read_enable 	),
		.img_weight_sel					(img_weight_sel ), // 1 = Weight , 0 = Img


		/* verilator lint_off PINCONNECTEMPTY */
		.conv_start     		 		(				)
		/* verilator lint_off PINCONNECTEMPTY */
		);

	rows_builder #(
		.N_ROWS(`N_ROWS),
		.N_COLUMNS(`N_COLUMNS))

		rows_m(
		// Inputs
		.clk							(clk 			),
		.rst 							(rst 			),
		.data_in 			   			(data_out_ram 	),
		.read_enable   					(read_enable 	),
		// Outputs
		.out 							(rows_builder_o	),
		.finish_read 					(finish_read 	)
		);


	always_ff @(posedge clk or negedge rst) begin
		if(!rst) begin
			img 			<= '0;
			weights 		<= '0;
			
		end else if(!img_weight_sel) begin
			img 		<= rows_builder_o;
			//$display("img = %x\n", img);
		end else begin
			weights 	<= rows_builder_o;
			//display_matrix("weights", weights, `N_ROWS, `N_COLUMNS);
		end
	end


	// display new weights matrix on logfile
	initial prev_weights = 0;

	always @ (weights) begin
		if(weights != prev_weights) begin
			prev_weights = weights;
			$display("weights = %x\n", weights);
			display_weights_logfile("weights", weights, `N_ROWS, `N_COLUMNS);
		end
	end

	assign out = weights;

endmodule : convolutor