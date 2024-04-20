
module TPU #(
    parameter K=2);
(
    input logic                     clk,
    input logic                     rst,
    input logic [K-1][7:0]          data,
    input logic [K-1][K-1][7:0]     weights;

    output logic [K-1][K-1][7:0]    out;    
);

    logic                           valid;
    logic                           load_weights;
    logic            [2:0]          count;
    logic       [K-1][7:0]          wr_data_in;
    logic            [7:0]          wr_pe_in_0;
    logic            [7:0]          wr_pe_in_1;

    always_ff @(posedge clk or negedge rst) begin
        if (rst) begin
            valid           <= 1'b0;
            count           <= 3'b0;
            load_weights    <= 1'b0;
            wr_data_in      <= '0;
        end
        else begin
            wr_data_in  <= data;
        end
    end

    processing_element pe0
        (.clk(clk),
         .rst(rst),
         .load_weights(load_weights),
         .valid(valid),
         .data_in(),
         .weights_in(),
         .valid_out(),
         .out_row(),
         .out_column()
        );
    
    processing_element pe1
        (.clk(clk),
         .rst(rst),
         .load_weights(load_weights),
         .valid(valid),
         .data_in(),
         .weights_in(),
         .valid_out(),
         .out_row(),
         .out_column()
        );

    processing_element pe2
        (.clk(clk),
         .rst(rst),
         .load_weights(load_weights),
         .valid(valid),
         .data_in(),
         .weights_in(),
         .valid_out(),
         .out_row(),
         .out_column()
        );

    processing_element pe3
        (.clk(clk),
         .rst(rst),
         .load_weights(load_weights),
         .valid(valid),
         .data_in(),
         .weights_in(),
         .valid_out(),
         .out_row(),
         .out_column()
        );

    assign wr_pe_in_0 = wr_data_in[0];
    assign wr_pe_in_1 = wr_data_in[1];


endmodule