`timescale 1 ns / 1 ns

module debouncer_tb ();
    localparam DURATION = 1000000;
    reg reset = 0;
    reg button_in = 0;
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
            button_in = 1;
            #($urandom_range(130,50));
            button_in = 0;
            #($urandom_range(130,50));
        end
        button_in = 1;
        #($urandom_range(13000,5000));
        button_in = 0;

    end

    initial begin
        $dumpfile("debouncer_tb.vcd");
        $dumpvars(0, debouncer_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end

    debouncer #(
        // Parameters
        .CLOCK_SIZE(24),
        .CLOCK_LENGTH(120),
        .CLOCK_START(24'd0),
        .CLOCK_LIMIT(24'd59)
    ) debouncer_sut (
        .reset(reset),
        .button_in(button_in),
        .clock_in(clock),
        .button_out(button)
    );
endmodule
