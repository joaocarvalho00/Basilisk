/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */

module control(
	input logic clk,
	input logic rst,
	input logic start_operation,
	input logic start_load_img,
	input logic finish_read,


	output logic read_enable,
	output logic conv_start,
	output img_weights_sel_t img_weight_sel
	);

	CTRL_STATE_t state, next;
	
	logic load_weights_done;	


	logic n_read_enable;
	logic n_conv_start;
	img_weights_sel_t n_img_weight_sel;


	/* verilator lint_off UNUSED */
	logic start_conv;	
	logic load_img_done;
	/* verilator lint_off UNUSED */

	// state
	always_ff @(posedge clk or negedge rst) begin 
		if(!rst) state <= IDLE;
		else 	 state <= next;
	end

	// next state
	always_comb begin
		next = XXX;
		case (state)
				IDLE: begin
					if(start_operation && load_weights_done == 0) 	   next = LOAD_WEIGHTS;
					else if (start_load_img && load_weights_done == 1) next = LOAD_IMG;
				end
				LOAD_WEIGHTS: if(finish_read) 						   next = IDLE;
							  else 									   next = LOAD_WEIGHTS;
				LOAD_IMG:     if(finish_read) 						   next = CONV;
							  else 									   next = LOAD_IMG;
				default: 											   next = XXX;
			/* verilator lint_off CASEINCOMPLETE */
			endcase
	end

	// outputs
	/* verilator lint_off LATCH */
	always_comb begin
		n_read_enable 			= 0;
		//n_load_weights_done		= 0;
			/* verilator lint_off CASEINCOMPLETE */
		case (state)
				
			IDLE: 		n_read_enable 			= 0;

			LOAD_WEIGHTS: begin 
						n_read_enable 			= 1;
						n_img_weight_sel  		= SEL_WEIGHTS;
			end

			LOAD_IMG : begin 
						n_read_enable 			= 1;
						n_img_weight_sel  		= SEL_IMG;
			end

			CONV: begin
						n_conv_start 			= 1;
						n_read_enable 			= 0;
			end

			default: {read_enable, load_weights_done} = 'x;
			/* verilator lint_off CASEINCOMPLETE */
		endcase
	end
	/* verilator lint_off LATCH */

	always_ff @(posedge clk or negedge rst) begin 
		if(!rst) begin
			read_enable 		<= 0;
			img_weight_sel 		<= SEL_IMG;
			conv_start 			<= 0;
		end else begin
			read_enable 		<= n_read_enable;
			img_weight_sel		<= n_img_weight_sel;
			conv_start			<= n_conv_start;
		end
	end















	// // state fsm
	// always_ff @(posedge clk or negedge rst) begin : ctrl_state_fsm
	// 	if(!rst) begin
	// 		state 				<= IDLE;
	// 		read_enable 			<= 0;
	// 		load_weights_done		<= 0;
	// 		load_img_done			<= 0;
	// 	end else begin
	// 		/* verilator lint_off CASEINCOMPLETE */
	// 		case (state)
				
	// 			IDLE: read_enable 			<= 0;

	// 			LOAD_WEIGHTS: begin 
	// 				read_enable 			<= 1;
	// 				img_weight_sel  		<= 1;
	// 			end

	// 			LOAD_IMG : begin 
	// 				read_enable 			<= 1;
	// 				img_weight_sel  		<= 0;
	// 			end

	// 			CONV: begin
	// 				conv_start 				<= 1;
	// 				read_enable 			<= 0;
	// 			end
	// 		/* verilator lint_off CASEINCOMPLETE */
	// 		endcase
	// 	end
	// end


	// // next fsm
	// always_ff @(posedge clk or negedge rst) begin : next_ctrl_state_fsm
	// 	if(!rst) begin
	// 		next 		<= IDLE;
	// 	end else begin
	// 		/* verilator lint_off CASEINCOMPLETE */
	// 		case (state)
	// 			IDLE: begin
	// 				if(start_operation && load_weights_done == 0) next 		<= LOAD_WEIGHTS;
	// 				else if (start_load_img && load_weights_done == 1) next <= LOAD_IMG;
	// 			end

	// 			LOAD_WEIGHTS: begin
	// 				if(finish_read) next 	<= IDLE;
	// 			end

	// 			LOAD_IMG: begin
	// 				if(finish_read) next 	<= CONV;
	// 			end

	// 			CONV: start_conv 						<= 1;
	// 		/* verilator lint_off CASEINCOMPLETE */
	// 		endcase
	// 		state 				<= next;
	// 	end
	// end

endmodule : control