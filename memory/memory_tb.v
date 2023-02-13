`timescale 1 ns / 1 ns

module memory_tb #(
    parameter WORD_SIZE = 8,
    parameter WORD_INIT = 8'b0,
    parameter ADDRESS_SIZE = 4,
    parameter MEMORY_QTY = 16,
    parameter DELAY_SIZE = 1,
    parameter READ_DELAY = 1,
    parameter WRITE_DELAY = 1,
    parameter DURATION = 10000
) (

);
    // Local Parameters
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    reg reset = 0;
    reg clock = 0;
    reg w_en = 0;
    reg r_en = 0;
    reg [ADDRESS_SIZE-1:0] w_addr = -1;
    reg [ADDRESS_SIZE-1:0] r_addr = -2;
    reg [WORD_SIZE-1:0] w_data = 0;
    reg [WORD_SIZE-1:0] read_out = 0;
    wire [WORD_SIZE-1:0] r_data;
    wire r_rdy;
    wire w_rdy;

    // Instantiate the clock
    always begin
        #41
        clock = ~clock;
    end

    initial begin
        #10
        reset = 1'b1;
        #10
        reset = 1'b0;
    end

    always @ (posedge clock) begin
        if (w_rdy) begin
            w_addr <= w_addr + 1;
            w_data <= $urandom_range(0,255);
        end else if (~w_en) begin
            w_en <= ON;
            w_addr <= w_addr + 1;
            w_data <= $urandom_range(0,255);
        end

        if (r_rdy) begin
            read_out <= r_data;
            r_addr <= r_addr +1;
        end else if (~r_en) begin
            r_en <= ON;
            r_addr <= r_addr +1;
        end
    end

    initial begin
        $dumpfile("memory_tb.vcd");
        $dumpvars(0, memory_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end
    
    memory #(
        .WORD_SIZE(WORD_SIZE),
        .WORD_INIT(WORD_INIT),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEMORY_QTY(MEMORY_QTY),
        .DELAY_SIZE(DELAY_SIZE),
        .READ_DELAY(READ_DELAY),
        .WRITE_DELAY(WRITE_DELAY)
    ) memory_uut (
        //Inputs
        .clock(clock),
        .w_en(w_en),
        .r_en(r_en),
        .reset(reset),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_data(w_data),
        //Outputs
        .r_data(r_data),
        .r_rdy(r_rdy),
        .w_rdy(w_rdy)
    );
endmodule