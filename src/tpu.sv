
module tpu #(
    parameter K=2)
(
    input logic                           clk,
    input logic                           rst,
    input logic [K-1:0][7:0]              data,
    input logic [K-1:0][K-1:0][7:0]       weights,
    input logic                           start,

    output logic [K-1:0][K-1:0][7:0]      out 
);

    logic                           valid;
    logic                           load_weights;
    logic            [2:0]          count;
    logic     [K-1:0][7:0]          wr_data_in;

    logic            [7:0]          wr_data_pe0_in;
    logic            [7:0]          wr_data_pe1_in;
    logic            [7:0]          wr_data_pe2_in;
    logic            [7:0]          wr_data_pe3_in;

    logic            [7:0]          wr_data_pe1_in_dly;

    logic            [7:0]          wr_data_row_pe0_out;
    logic            [7:0]          wr_data_row_pe1_out;
    logic            [7:0]          wr_data_row_pe2_out;
    logic            [7:0]          wr_data_row_pe3_out;

    logic            [7:0]          wr_data_col_pe0_out;
    logic            [7:0]          wr_data_col_pe1_out;
    logic            [7:0]          wr_data_col_pe2_out;
    logic            [7:0]          wr_data_col_pe3_out;

    logic            [7:0]          wr_weights_pe0_in; 
    logic            [7:0]          wr_weights_pe1_in; 
    logic            [7:0]          wr_weights_pe2_in; 
    logic            [7:0]          wr_weights_pe3_in;     

    logic                           valid_pe0_in;
    logic                           valid_pe1_in;  
    logic                           valid_pe2_in;
    logic                           valid_pe3_in;

    logic                           valid_pe0_out;
    logic                           valid_pe1_out;  
    logic                           valid_pe2_out;
    logic                           valid_pe3_out; 

    logic [K-1:0][K-1:0][7:0]       out_lsfr;     

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            valid           <= 1'b0;
            count           <= 3'b0;
            load_weights    <= 1'b0;
            wr_data_in      <= '0;
        end
        else begin
            if(start) count <= count + 1;
            wr_data_in         <= data;
            wr_data_pe1_in_dly <= wr_data_pe1_in;
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            valid           <= 1'b0;
        end
        else begin
            if(count == K) valid <= 1'b1;
            else if(valid_pe0_out & valid_pe1_out & valid_pe2_out & valid_pe3_out) valid <= 1'b0;
        end
    end

    processing_element pe0
        (.clk                       (clk                ),
         .rst                       (rst                ),
         .load_weights              (load_weights       ),
         .valid                     (valid_pe0_in       ),
         .data_in                   (wr_data_pe0_in     ),
         .data_in_accumulate        (                   ),
         .weights_in                (wr_weights_pe0_in  ),
         .valid_out                 (valid_pe0_out      ),
         .out_row                   (wr_data_row_pe0_out),
         .out_column                (wr_data_col_pe0_out)
        );
    
    processing_element pe1
        (.clk                       (clk                ),
         .rst                       (rst                ),
         .load_weights              (load_weights       ),
         .valid                     (valid_pe1_in       ),
         .data_in                   (wr_data_pe1_in_dly ),
         .data_in_accumulate        (wr_data_col_pe0_out),
         .weights_in                (wr_weights_pe1_in  ),
         .valid_out                 (valid_pe1_out      ),
         .out_row                   (wr_data_row_pe1_out),
         .out_column                (wr_data_col_pe1_out)
        );

    processing_element pe2
        (.clk                       (clk                ),
         .rst                       (rst                ),
         .load_weights              (load_weights       ),
         .valid                     (valid_pe2_in       ),
         .data_in                   (wr_data_pe3_in     ),
         .data_in_accumulate        (                   ),
         .weights_in                (wr_weights_pe2_in  ),
         .valid_out                 (valid_pe2_out      ),
         .out_row                   (wr_data_row_pe2_out),
         .out_column                (wr_data_col_pe2_out)
        );

    processing_element pe3
        (.clk                       (clk                ),
         .rst                       (rst                ),
         .load_weights              (load_weights       ),
         .valid                     (valid_pe3_in       ),
         .data_in                   (wr_data_pe3_in     ),
         .data_in_accumulate        (wr_data_col_pe2_out),
         .weights_in                (wr_weights_pe3_in  ),
         .valid_out                 (valid_pe3_out      ),
         .out_row                   (wr_data_row_pe3_out),
         .out_column                (wr_data_col_pe3_out)
        );

    assign valid_pe0_in   = valid;
    assign valid_pe1_in   = valid;
    assign valid_pe2_in   = valid_pe0_out;
    assign valid_pe3_in   = valid_pe1_out;

    assign wr_data_pe0_in = start ? wr_data_in[0] : 8'h0;
    assign wr_data_pe1_in = start ? wr_data_in[1] : 8'h0;
    assign wr_data_pe2_in = wr_data_row_pe0_out;
    assign wr_data_pe3_in = wr_data_row_pe1_out;

    assign wr_weights_pe0_in = load_weights ? weights[0][0] : 8'h0;
    assign wr_weights_pe1_in = load_weights ? weights[0][1] : 8'h0;
    assign wr_weights_pe2_in = load_weights ? weights[1][0] : 8'h0;
    assign wr_weights_pe3_in = load_weights ? weights[1][1] : 8'h0;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            out_lsfr           <= 32'h0;
        end
        else begin
            out_lsfr[0]        <= {out_lsfr[0][0], wr_data_col_pe1_out};
            out_lsfr[1]        <= {out_lsfr[1][0], wr_data_col_pe3_out};
        end
    end

    assign out = valid_pe3_out ? out_lsfr : 32'h0;

endmodule