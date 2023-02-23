`timescale 1 ns / 1 ns

module store_tb ();
    // Instantiate the clock
    reg clock = 1;
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
        $dumpfile("store_tb.vcd");
        $dumpvars(0, store_tb);
        #(DURATION)
        $display("Finished!");
        $finish;
    end

    // Local localparams
    localparam OFF = 1'b0;
    localparam ON = 1'b1;
    reg [3:0] w_delay;
    reg [WORD_SIZE-1:0] stored_sequence;

    reg slow_clock = 1;
    always begin
        #328
        slow_clock <= ~slow_clock;
    end

// Simulate User Input
always @ (posedge slow_clock) begin
    if (~store) begin
        store_delay <= $urandom_range(7,15);
        store <= ON;
    end
    sequence <= $urandom_range(1,255);
end

always @ (posedge clock) begin
    if (store_delay == 0) begin
        store <= OFF;
    end else begin
        store_delay <= store_delay - 1;
    end
end

// Simulate Memory Module
    always @ (posedge w_en or posedge reset) begin
        if (reset) begin
            w_ready <= ON;
        end if (w_en) begin
            w_ready <= OFF;
            w_delay <= $urandom_range(1,4);
        end
    end

    always @ (posedge clock) begin
        if (w_en) begin
            if (w_delay==0) begin
                w_ready <= ON;
                stored_sequence <= w_data;
            end else begin
                w_delay <= w_delay - 1;
            end
        end else begin
            w_ready <= ON;
        end
    end

    // SUT Parameters
    localparam WORD_SIZE = 8;
    localparam ADDRESS_SIZE = 4;
    localparam MEMORY_QTY = 16;

    //SUT Signals
    wire w_en;
    wire [WORD_SIZE-1:0] w_data;
    reg w_ready;
    wire [ADDRESS_SIZE - 1:0] w_addr;
    reg [7:0] sequence;
    reg store = 0;
    reg [3:0] store_delay;

    store #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEMORY_QTY(MEMORY_QTY)
    ) store_uut (
        //Inputs
        .clock(clock),
        .store(store),
        .reset(reset),
        .w_ready(w_ready),
        .sequence(sequence),
        //Outputs
        .w_data(w_data),
        .w_addr(w_addr),
        .w_en(w_en)
    );
endmodule