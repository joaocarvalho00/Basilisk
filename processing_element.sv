module processing_element(
    input logic clk,
    input logic rst,
    input logic [31:0] M_input,
    input logic [31:0] N_input,
    output logic [31:0] P_output,
    output logic [31:0] Q_output,
    logic [31:0] R
)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            R <= 0;
        end
        else begin
            R <= R + M_input * N_input;

        end
    end

    assign P_output = M_input;
    assign Q_output = N_input;
    
endmodule