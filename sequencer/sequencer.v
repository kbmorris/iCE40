module sequencer #(
    parameter WORD_SIZE = 8,
    parameter ADDRESS_SIZE = 4,
    parameter MEMORY_QTY = 16
) (
    //Inputs
    input clock,
    input slow_clock,
    input [WORD_SIZE - 1:0] r_data,
    input reset,
    input r_rdy,

    //Outputs
    output reg r_en,
    output reg [ADDRESS_SIZE - 1:0] r_addr,
    output reg [WORD_SIZE - 1:0] sequence
);
    localparam ON = 1'b1;
    localparam OFF = 1'b0;

    always @ (posedge slow_clock or posedge reset) begin
        if (reset) begin
            r_addr <= 0;
            r_en <= ON;
        end else begin
            r_addr <= r_addr + 1;
            r_en <= ON;
        end
    end

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            sequence <= 0;
        end else begin
            if (r_en & r_rdy) begin
                sequence <= r_data;
                r_en <= OFF;
            end
        end
    end
endmodule

