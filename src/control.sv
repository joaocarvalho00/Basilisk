/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module control(
	input logic clk,
	input logic rst,
	input logic start_operation,
	input logic finish_read,


	output logic read_enable,
	output logic conv_start,
	output logic img_weight_sel
	);

	CTRL_STATE_t ctrl_state, next_ctrl_state;

	logic load_weights_done;
	

	/* verilator lint_off UNUSED */
	logic start_conv;	
	logic load_img_done;
	/* verilator lint_off UNUSED */

	// ctrl_state fsm
	always_ff @(posedge clk or negedge rst) begin : ctrl_state_fsm
		if(!rst) begin
			ctrl_state 				<= IDLE;
			read_enable 			<= 0;
			load_weights_done		<= 0;
			load_img_done			<= 0;
		end else begin
			/* verilator lint_off CASEINCOMPLETE */
			case (ctrl_state)
				
				IDLE: read_enable 			<= 0;

				LOAD_WEIGHTS: begin 
					read_enable 			<= 1;
					img_weight_sel  		<= 1;
				end

				LOAD_IMG : begin 
					read_enable 			<= 1;
					img_weight_sel  		<= 0;
				end

				CONV: begin
					conv_start 				<= 1;
					read_enable 			<= 0;
				end
			/* verilator lint_off CASEINCOMPLETE */
			endcase
		end
	end


	// next_ctrl_state fsm
	always_ff @(posedge clk or negedge rst) begin : next_ctrl_state_fsm
		if(!rst) begin
			next_ctrl_state 		<= IDLE;
		end else begin
			/* verilator lint_off CASEINCOMPLETE */
			case (ctrl_state)
				IDLE: begin
					if(start_operation && load_weights_done == 0) next_ctrl_state <= LOAD_WEIGHTS;
					else if (start_operation && load_weights_done == 1) next_ctrl_state <= LOAD_IMG;
				end

				LOAD_WEIGHTS: begin
					if(finish_read) next_ctrl_state 	<= IDLE;
				end

				LOAD_IMG: begin
					if(finish_read) next_ctrl_state 	<= CONV;
				end

				CONV: start_conv 						<= 1;
			/* verilator lint_off CASEINCOMPLETE */
			endcase
			ctrl_state 				<= next_ctrl_state;
		end
	end

endmodule : control