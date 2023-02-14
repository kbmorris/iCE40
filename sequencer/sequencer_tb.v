`timescale 1 ns / 1 ns

module sequencer_tb ();
    // Instantiate the clock
    reg clock = 0;
    always begin
        #41
        clock = ~clock;
    end

    // Initiate a reset
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
        $dumpfile("sequencer_tb.vcd");
        $dumpvars(0, sequencer_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end

    // Local localparams
    localparam OFF = 1'b0;
    localparam ON = 1'b1;
    reg [3:0] r_delay;

    reg slow_clock = 0;
    always begin
        #328
        slow_clock <= ~slow_clock;
    end

    always @ (posedge r_en or posedge reset) begin
        if (reset) begin
        end if (r_en) begin
            r_rdy <= OFF;
            r_delay <= $urandom_range(1,4);
            r_data <= $urandom_range(1,255);
        end
    end

    always @ (posedge clock) begin
        if (r_en) begin
            if (~(r_delay==0)) begin
                r_delay <= r_delay - 1;
            end else begin
                r_rdy <= ON;
            end
        end
    end

    // SUT Parameters
    localparam WORD_SIZE = 8;
    localparam ADDRESS_SIZE = 4;
    localparam MEMORY_QTY = 16;

    //SUT Signals
    wire r_en;
    reg [WORD_SIZE-1:0] r_data;
    reg r_rdy;
    wire [ADDRESS_SIZE - 1:0] r_addr;
    wire [7:0] sequence;

    sequencer #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEMORY_QTY(MEMORY_QTY)
    ) sequencer_uut (
        //Inputs
        .clock(clock),
        .slow_clock(slow_clock),
        .reset(reset),
        .r_data(r_data),
        .r_rdy(r_rdy),
        //Outputs
        .r_addr(r_addr),
        .r_en(r_en),
        .sequence(sequence)
    );
endmodule