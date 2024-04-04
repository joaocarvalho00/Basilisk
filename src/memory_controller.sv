/* verilator lint_off IMPORTSTAR */
import data_types_pkg::*;
/* verilator lint_off IMPORTSTAR */
import helper_functions_pkg::display_weights_logfile;

module memory_controller
            #(  DATA_WIDTH                              = `WIDTH,
                ADDR_WIDTH                              = `ADDR_WIDTH_RAM)
             (
                input logic                             clk,
                input logic                             rst,
                input logic [ADDR_WIDTH-1:0]            paddr,
                input logic [DATA_WIDTH-1:0]            pwdata,
                input logic                             pwrite,
                input logic                             psel,
                input logic                             penable,

                output logic [DATA_WIDTH-1:0]           prdata
);


    logic pready;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            prdata <= 0;
            state <= SETUP; 
        end else begin
            case(state)
            SETUP : begin
                prdata <= 0;
                if (psel & !penable) begin
                    if (pwrite) begin
                        state <= WRITE;
                    end else begin
                state <= READ;
                    end
                end
            end
            WRITE: begin
                if (psel & penable & pwrite) begin
                    mem[paddr] <= pwdata; 
                end
                state <= SETUP; 
            end
            READ : begin
                if (psel & penable & !pwrite) begin
                    prdata <= mem[paddr];
                end
                state <= SETUP;
                end
            endcase
        end
    end





endmodule