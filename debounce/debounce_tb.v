`timescale 1 ns / 1 ns

module debounce_tb ();
    localparam DURATION = 1000000;
    reg reset = 0;
    reg in = 0;
    reg clock = 0;
    reg [4] i;
    wire button;

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
        // Random period where the button is off
        #($urandom_range(18000,6000));
        // Bounce Loop
        // Random sequence of button Bounce
        for (i = $urandom_range(5,9);i>0;i--) begin
            // Button Bounce
            in = 1;
            #($urandom_range(130,50));
            in = 0;
            #($urandom_range(130,50));
        end
        in = 1;
        #($urandom_range(13000,5000));
        in = 0;

    end

    initial begin
        $dumpfile("debounce_tb.vcd");
        $dumpvars(0, debounce_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end

    debounce #(
        // Parameters
        .CLOCK_SIZE(24),
        .CLOCK_START(24'd0),
        .CLOCK_LIMIT(24'd59)
    ) debounce_sut (
        .reset(reset),
        .in(in),
        .clock(clock),
        .out(button)
    );
endmodule
