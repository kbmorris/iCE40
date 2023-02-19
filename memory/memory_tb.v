`timescale 1 ns / 1 ns

module memory_tb #(
    parameter WORD_SIZE = 8,
    parameter WORD_INIT = 8'b0,
    parameter ADDRESS_SIZE = 4,
    parameter MEMORY_QTY = 16,
    parameter WAIT_SIZE = 2,
    parameter READ_WAIT = 0,
    parameter WRITE_WAIT = 0,
    parameter DURATION = 10000
) (

);
    // Local Parameters
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    reg reset = 0;
    reg clock = 1;
    reg slow_clock = 1;
    reg w_en = 0;
    reg r_en = 0;
    reg [ADDRESS_SIZE-1:0] w_addr = -1;
    reg [ADDRESS_SIZE-1:0] r_addr = -2;
    reg [WORD_SIZE-1:0] w_data = 0;
    reg [WORD_SIZE-1:0] read_out = 0;
    wire [WORD_SIZE-1:0] r_data;
    wire r_ready;
    wire w_ready;
    reg read_cycle;
    reg write_cycle;

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

    always begin
        #410
        slow_clock = ~slow_clock;
    end

    always @ (posedge slow_clock) begin
        if (r_ready) begin
            read_cycle <= 1;
        end
        if (w_ready) begin
            write_cycle <= 1;
        end
    end

    always @ (posedge clock) begin
        if (write_cycle) begin
            w_en <= ON;
            w_addr <= w_addr + 1;
            w_data <= $urandom_range(0,255);
            write_cycle <= OFF;
        end else if (w_ready) begin
            w_en <= OFF;
        end

        if (read_cycle) begin
            r_en <= ON;
            r_addr <= r_addr +1;
            r_addr <= r_addr +1;
            read_cycle <= OFF;
        end else if (r_ready) begin
            read_out <= r_data;
            r_en <= OFF;
        // end else begin
        //     r_en <= OFF;
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
        .WAIT_SIZE(WAIT_SIZE),
        .READ_WAIT(READ_WAIT),
        .WRITE_WAIT(WRITE_WAIT)
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
        .r_ready(r_ready),
        .w_ready(w_ready)
    );
endmodule