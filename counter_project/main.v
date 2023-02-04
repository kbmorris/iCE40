module main (
    // Inputs
    input reset_in,
    input start_in,
    input clock_in,

    // Outputs
    output [7:0] led,

    // Debug Outputs
    output D1,
    output D2,
    output D3,
    output D4,
    output D5

);

    // Wires
    // Imput Wires
    wire reset = ~reset_in;
    wire start = ~start_in;
    // clock divider wires
    wire clock;
    // counter module wires
    wire done_up;
    wire done_dn;
    wire enabled_up;
    wire enabled_dn;
    wire [7:0] value_up;
    wire [7:0] value_dn;
    // Startup Logic
    wire start_up = start & ~(enabled_up | enabled_dn | reset);
    // Transition Logic
    wire start_dn = done_up;
    // LED Driver Logic
    assign led = ({8{enabled_up}}&value_up)|({8{enabled_dn}}&value_dn);

    // Debugging
    assign D1 = start;
    assign D2 = reset;
    assign D3 = clock;
    assign D4 = enabled_up;
    assign D5 = enabled_dn;

    // Instantiate the clock
    clock_divider #(
        .CLOCK_INTERVAL(750000)
    ) clock1 (
        .clock_in(clock_in),
        .reset(reset),
        .clock_out(clock)
    );

    // Instantiate the Up Counter
    counter #(
        .COUNTER_SIZE(8),
        .START_VALUE(8'b00000001),
        .STOP_VALUE(8'b11111111),
        .STEP_VALUE(8'b00000001)
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
        .COUNTER_SIZE(8),
        .START_VALUE(8'b11111110),
        .STOP_VALUE(8'b00000000),
        .STEP_VALUE(8'b11111111)
    ) counter_dn (
        .clock(clock),
        .reset(reset),
        .start(start_dn),
        .done(done_dn),
        .enabled(enabled_dn),
        .value(value_dn)
    );

endmodule
