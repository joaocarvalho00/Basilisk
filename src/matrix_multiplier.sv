`include "src/defines.sv"
`timescale 1ns/1ps

module matrix_multiplier #(
    parameter N_ROWS = `N_ROWS,
    parameter N_COLUMNS = `N_COLUMNS,
    parameter WIDTH = `WIDTH,
    parameter C_WIDTH = (2 * WIDTH) * $clog2(N_ROWS)
)(
    input logic                 clk,
    input logic                 rst,
    input logic                 valid_i,
    output logic                valid_o,
    input [WIDTH-1:0]           a_i[N_ROWS][N_COLUMNS],
    input [WIDTH-1:0]           b_i[N_ROWS][N_COLUMNS],
    output logic [C_WIDTH-1:0]  c_o[N_ROWS][N_COLUMNS]
);

    logic [C_WIDTH-1:0] c_calc[N_ROWS][N_COLUMNS];

    always @(*) begin : multiply
        for (int i = 0; i < N_ROWS; i = i + 1) begin : C_ROWS
            for (int j = 0; j < N_COLUMNS; j = j + 1) begin : C_COLUMNS
                c_calc[i][j]= 0;
                for (int k = 0; k < N_ROWS; k = k + 1) begin : PRODUCT
                    c_calc[i][j] = c_calc[i][j] + (a_i[i][k] * b_i[k][j]);
                end
            end
        end
    end

    always_ff @(posedge clk or negedge rst) begin : proc_reg
	    if(!rst) begin
            valid_o <= 1'b0;

            for (int i = 0; i < N_ROWS; i = i + 1) begin
                for (int j = 0; j < N_ROWS; j = j +1) begin
                    c_o[i][j] <= '0;
                end
            end else begin
                valid_o <= valid_i;

                for (int i = 0; i < N_ROWS; i = i + 1) begin
                    for (int j = 0; j < N_COLUMNS; j = j + 1) begin
                        c_o[i][j] <= c_calc[i][j];
                    end
                end
            end
        end
    end

endmodule: matrix_multiplier