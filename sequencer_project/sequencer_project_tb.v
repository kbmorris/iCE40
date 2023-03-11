`timescale 1 ns / 1 ns

module sequencer_project_tb #(
    parameter COUNTER_LIMIT = 6-1,
    parameter CLOCK_LIMIT = 24'd3
) (

);
    // Instantiate the clock
    reg clock = 1;
    always begin
        #41
        clock <= ~clock;
    end

    // Initiate a reset
    reg reset = 0;
    initial begin
        #10
        reset <= 1'b1;
        #10
        reset <= 1'b0;
    end

    // Initialize the dump file and duration
    localparam DURATION = 10000;
    initial begin
        $dumpfile("sequencer_project_tb.vcd");
        $dumpvars(0, sequencer_project_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end

    reg store_button = 0;
    reg [1:0] sequence = 0;
    wire [1:0] display;

    sequencer_project #(
        .COUNTER_LIMIT(COUNTER_LIMIT),
        .CLOCK_LIMIT(CLOCK_LIMIT)
    ) sequencer_project_uut (
        .clock(clock),
        .Reset(~reset),
        .Store(~store_button),
        .Sequence(~sequence),
        .display(display)
    );

    always begin
        #400
        store_button <= 1;
        sequence <= $urandom_range(0,3);
        #100
        store_button <= 0;
    end

endmodule