module module_test (
    output wire D1,
    output wire D2,
    output wire D3,
    output wire D4,
    output wire D5,
    output wire TR3,
    output wire TR4,
    output wire TR5,
    output wire TR6,
    output wire TR7,
    output wire TR8,
    output wire TR9,
    output wire TR10,
   
    input PMOD1,
    input PMOD2,
    input PMOD3,
    input PMOD4,
    input CLK
   
);

clock_divider #(
    .CLOCK_INTERVAL(750000)
) clock_1 (
    .clock_in(CLK),
    .reset(reset),
    .clock_out(clock1)
);

counter counter1 (
    .clock(clock1),
    .reset(reset),
    .start(start),

    .done(D4),
    .enabled(D5),
    .value(LED)
);

    wire reset = ~PMOD1;
    wire start = ~PMOD2;
    wire clock = PMOD3;
    wire [7:0] LED;
    wire clock1;

    assign {TR10,TR9,TR8,TR7,TR6,TR5,TR4,TR3} = LED;

    assign D1 = reset;
    assign D2 = start;
    assign D3 = clock1;
endmodule





