/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module control(
	input logic clk,
	input logic rst,
	input logic start_operation,
	input logic finish_read,


	output logic read_enable,
	output logic conv_start
	);

	CTRL_STATE_t ctrl_state, next_ctrl_state;

	/* verilator lint_off UNUSED */
	logic start_conv;	
	/* verilator lint_off UNUSED */

	// ctrl_state fsm
	always_ff @(posedge clk or negedge rst) begin : ctrl_state_fsm
		if(~rst) begin
			ctrl_state 				<= IDLE;
			read_enable 			<= 0;
		end else begin
			/* verilator lint_off CASEINCOMPLETE */
			case (ctrl_state)
				
				IDLE: read_enable 	<= 0;

				READ: read_enable 	<= 1;

				CONV: begin
					conv_start 		<= 1;
					read_enable 	<= 0;
				end
			/* verilator lint_off CASEINCOMPLETE */
			endcase
		end
	end


	// next_ctrl_state fsm
	always_ff @(posedge clk or negedge rst) begin : next_ctrl_state_fsm
		if(~rst) begin
			next_ctrl_state 		<= IDLE;
		end else begin
			/* verilator lint_off CASEINCOMPLETE */
			case (ctrl_state)
				IDLE: begin
					if(start_operation) next_ctrl_state <= READ;
				end

				READ: begin
					if(finish_read) next_ctrl_state 	<= CONV;
				end

				CONV: start_conv 						<= 1;
			/* verilator lint_off CASEINCOMPLETE */
			endcase
			ctrl_state 				<= next_ctrl_state;
		end
	end

endmodule : control