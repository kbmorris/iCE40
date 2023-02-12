`timescale 1 ns / 1 ns

module counter_tb ();
    localparam DURATION = 10000;
    localparam LED_COUNT = 4;

    reg reset = 0;
    reg start = 0;
    reg clock = 0;
    wire [LED_COUNT - 1:0] led;

    wire done_up;
    wire done_dn;
    wire enabled_up;
    wire enabled_dn;
    wire [LED_COUNT - 1:0] value_up;
    wire [LED_COUNT - 1:0] value_dn;
    // Startup Logic
    wire start_up = start & ~(enabled_up | enabled_dn | reset);
    // Transition Logic
    wire start_dn = done_up;
    // LED Driver Logic
    assign led = ({LED_COUNT{enabled_up}}&value_up)|({LED_COUNT{enabled_dn}}&value_dn);

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
        #10
        start = 1'b1;
        #20
        start = 1'b0;
    end

    initial begin
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end


    // clock_divider #(
    //     .CLOCK_INTERVAL(5)
    // ) clock1 (
    //     .clock_in(clock_in),
    //     .reset(reset),
    //     .clock_out(clock)
    // );

    // Instantiate the Up Counter
    counter #(
        .COUNTER_SIZE(4),
        .START_VALUE(4'd1),
        .STOP_VALUE(4'b1111),
        .STEP_VALUE(4'd1)
    ) counter_up (
        .clock(clock),
        .reset(reset),
        .start(start_up),
        .done(done_up),
        .enabled(enabled_up),
        .value(value_up)
    );

    // Instantiate the Down Counter
    counter #(
        .COUNTER_SIZE(4),
        .START_VALUE(4'b1110),
        .STOP_VALUE(4'b0000),
        .STEP_VALUE(4'b1111)
    ) counter_dn (
        .clock(clock),
        .reset(reset),
        .start(start_dn),
        .done(done_dn),
        .enabled(enabled_dn),
        .value(value_dn)
    );

endmodule
