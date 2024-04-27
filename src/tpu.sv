
module tpu #(
    parameter K=2)
(
    input logic                           clk,
    input logic                           rst,
    input logic [K-1:0][K-1:0][7:0]       data,
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
    logic            [7:0]          wr_data_pe3_in_dly;

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

    logic                           valid_pe1_in_dly;

    logic                           valid_pe0_out;
    logic                           valid_pe1_out;  
    logic                           valid_pe2_out;
    logic                           valid_pe3_out; 

    logic                           valid_pe1_out_dly;
    logic                           valid_pe3_out_dly;

    logic               [2:0]       count2;
    logic                           start_count;
    //logic [K-1:0][K-1:0][7:0]       out_lsfr
    logic [K-1:0][K-1:0][7:0]       data_reg;  
    logic        [K-1:0][7:0]       data_row_in;  
    logic        [K-1:0][7:0]       row_1;
    logic        [K-1:0][7:0]       row_2;

    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_reg        <= 'h0;
        end
        else begin
            data_reg        <= data;
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_row_in        <= 'h0;
        end
        else begin
            data_row_in        <= data[count2];
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            count2           <= 3'h0;
            start_count      <= 0;
        end
        else if(count2 < K && start) begin
            count2           <= count2 + 1;
        end
        else begin 
            count2           <= 3'h0;
            start_count      <= 1;
            //start           <= 0;
        end
    end

    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            valid           <= 1'b0;
            count           <= 3'b0;
            load_weights    <= 1'b0;
        end
        else begin
            if(start && start_count) count <= count + 1;
            wr_data_pe1_in_dly <= wr_data_pe1_in;
            wr_data_pe3_in_dly <= wr_data_pe3_in;
            valid_pe1_in_dly   <= valid_pe1_in;
            valid_pe1_out_dly  <= valid_pe1_out;
            valid_pe3_out_dly  <= valid_pe3_out;
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            valid           <= 1'b0;
        end
        else begin
            if(count == K) begin
                valid       <= 1'b1;
                count       <= 3'b0;
            end
            else valid <= 1'b0;
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
         .valid                     (valid_pe1_in_dly   ),
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
         .data_in                   (wr_data_pe2_in     ),
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
            //out_lsfr           <= 32'h0;
            row_1              <= 16'h0;
        end
        else begin
            //if(!valid_pe1_out_dly) out_lsfr[0]        <= {wr_data_col_pe1_out, out_lsfr[0][1]};
            //if(!valid_pe3_out_dly) out_lsfr[1]        <= {wr_data_col_pe3_out, out_lsfr[1][1]};
            if(!valid_pe1_out)  row_1               <= {wr_data_col_pe1_out, row_1[1]};
            if(!valid_pe3_out)  row_2               <= {wr_data_col_pe3_out, row_2[1]};
        end
    end

    assign wr_data_in = data_row_in;
    assign out = valid_pe3_out ? {row_2, row_1} : 32'0;

endmodule