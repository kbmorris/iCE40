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
    input r_ready,

    //Outputs
    output reg r_en,
    output reg [ADDRESS_SIZE - 1:0] r_addr,
    output reg [WORD_SIZE - 1:0] sequence
);
    localparam ON = 1'b1;
    localparam OFF = 1'b0;
    localparam READING = 1'b1;
    reg read_state = OFF;
    
    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            sequence <= 0;
            r_addr <= -1;
            r_en <= OFF;
        end else begin
            case (read_state)
                OFF: begin
                    if (r_ready & slow_clock) begin
                        r_addr <= r_addr + 1;
                        r_en <= ON;
                        read_state <= READING;
                    end
                end
                READING: begin
                    if (r_ready & r_en) begin
                        sequence <= r_data;
                        r_en <= OFF;
                    end
                    if (~slow_clock) begin
                        read_state <= OFF;
                        r_en <= OFF;
                    end
                end
            endcase
        end
    end
endmodule

