module processing_element (

    input   logic clk,
    input   logic rst,
    input   logic load_weights,
    input   logic valid,
    input   logic [7:0] data_in,
    input   logic [7:0] weights_in,

    output  logic valid_out,
    output  logic [7:0] out_row,
    output  logic [7:0] out_column
);

    logic [7:0] accumulate;
    logic [7:0] weights;

    // Load weights
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            weights     <= 8'h0;
        end
        else if(load_weights) begin
            weights     <= weights_in;
        end
    end

    // Multiply accumulate (MAC)
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            accumulate  <= 8'h0;
        end
        else begin
            accumulate  <= accumulate + data_in * weights;
        end
    end

    assign out_row      = data_in;
    assign out_column   = accumulate;
    assign valid_out    = valid;
endmodule