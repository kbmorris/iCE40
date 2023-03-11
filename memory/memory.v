module memory #(
    parameter WORD_SIZE = 8,
    parameter WORD_INIT = 8'b0,
    parameter ADDRESS_SIZE = 4,
    parameter MEMORY_QTY = 16,
    parameter WAIT_SIZE = 2,
    parameter READ_WAIT = 0,
    parameter WRITE_WAIT = 0
) (
    //Inputs
    input clock,
    input w_en,
    input r_en,
    input reset,
    input [ADDRESS_SIZE-1:0] w_addr,
    input [ADDRESS_SIZE-1:0] r_addr,
    input [WORD_SIZE-1:0] w_data,
    //Outputs
    output reg [WORD_SIZE-1:0] r_data,
    output reg r_ready,
    output reg w_ready
);
    // Local Parameters
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    //Memory Timing
    //Read/Write Timing State Machines
    localparam WAIT = 1'b0;
    localparam READ = 1'b1;
    localparam WRITE = 2'b01;
    localparam INIT = 2'b10;
    reg [WAIT_SIZE-1:0] r_delay;
    reg [WAIT_SIZE-1:0] w_delay;
    reg r_state = WAIT;
    reg [1:0] w_state = WAIT;

    //Allocate memory and timing registers
    reg [WORD_SIZE-1:0] mem [0:MEMORY_QTY-1];
    reg [ADDRESS_SIZE-1:0] counter;

    always @ (negedge clock or posedge reset) begin
        if (reset) begin
            w_state <= INIT;
            r_state <= WAIT;
            r_ready <= OFF;
            w_ready <= OFF;
            counter <= MEMORY_QTY - 1;
            w_delay <= WRITE_WAIT + 1;
        end else begin
            case (r_state)
            WAIT:
                if (r_en) begin
                    r_state <= READ;
                    r_delay <= READ_WAIT;
                    r_ready <= OFF;
                    r_data <= mem[r_addr];
                end
            READ:
                if (r_delay==0) begin
                    r_ready <= ON;
                    r_state <= WAIT;
                end else begin
                    r_delay <= r_delay - 1;
                end
            endcase
            case (w_state)
            WAIT:
                if (w_en) begin
                    w_state <= WRITE;
                    w_delay <= WRITE_WAIT;
                    w_ready <= OFF;
                    mem[w_addr] <= w_data;
                end
            WRITE:
                if (w_delay==0) begin
                    w_ready <= ON;
                    w_state <= WAIT;
                end else begin
                    w_delay <= w_delay - 1;
                end
            INIT:
                if (counter==0 & w_delay==0) begin
                    w_state <= WAIT;
                    r_ready <= ON;
                    w_ready <= ON;
                end else if (w_delay==0) begin
                    counter <=counter - 1;
                    w_delay <= WRITE_WAIT + 1;
                end else begin
                    mem[counter] <= WORD_INIT;
                    w_delay <= w_delay - 1;
                end
            endcase
        end
    end
endmodule