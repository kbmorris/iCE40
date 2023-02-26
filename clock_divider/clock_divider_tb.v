`timescale 1 ns / 1 ns

module clock_divider_tb (
);
    reg clock = 0;
    always begin
        #41
        clock <= ~clock;
    end

    reg reset = 0;
    initial begin
        #10
        reset = 1'b1;
        #10
        reset = 1'b0;
    end

    // Initialize the dump file and duration
    localparam DURATION = 10000;
    initial begin
        $dumpfile("clock_divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end

    // Local localparams
    localparam OFF = 1'b0;
    localparam ON = 1'b1;
    reg [3:0] r_delay;


    localparam COUNTER_SIZE = 24;
    localparam COUNTER_LIMIT = 6 - 1;

    clock_divider #(
        .COUNTER_SIZE(COUNTER_SIZE),
        .COUNTER_LIMIT(COUNTER_LIMIT)
    ) slow_clock (
        .clock(clock),
        .reset(reset),
        .div_clock(slow_clock)
    );
endmodule
