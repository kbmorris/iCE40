module sequencer_project #(
    parameter COUNTER_LIMIT = 6000000 - 1,
    parameter CLOCK_LIMIT = 6000 - 1

) (
    // Inputs
    input clock,
    input Reset,
    input Store,
    input [WORD_SIZE-1:0] Sequence,

    // Outputs
    output wire [WORD_SIZE-1:0] display,
    output wire [ADDRESS_SIZE-1:0] r_addr,
    output wire reset,
    output wire store,
    output wire [WORD_SIZE-1:0] sequence
); 

    localparam WORD_SIZE = 2;
    localparam ADDRESS_SIZE = 4;
    localparam MEMORY_QTY = 16;

    assign sequence = ~Sequence;
    assign reset = ~Reset;
    assign store = ~Store;

    wire seconds;
    wire db_store;
    wire [ADDRESS_SIZE - 1:0] w_addr;
    wire w_en;
    wire [WORD_SIZE - 1:0] w_data;
    wire r_en;
    wire w_ready;
    wire r_ready;
    wire [WORD_SIZE - 1:0] r_data;

    clock_divider #(
        .COUNTER_LIMIT(COUNTER_LIMIT)
    ) second_clock (
        .clock(clock),
        .reset(reset),
        .div_clock(seconds)
    );

    debounce #(
        .CLOCK_LIMIT(CLOCK_LIMIT)
    ) debounce_store (
        .reset(reset),
        .in(store),
        .clock(clock),
        .out(db_store)
    );

    store #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEMORY_QTY(MEMORY_QTY)
    ) sequence_store (
        .clock(clock),
        .reset(reset),
        .store(db_store),
        .w_ready(w_ready),
        .sequence(sequence),
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data)
    );

    sequencer #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEMORY_QTY(MEMORY_QTY)
    ) display_sequencer (
        .clock(clock),
        .slow_clock(seconds),
        .reset(reset),
        .r_data(r_data),
        .r_ready(r_ready),

        .r_en(r_en),
        .r_addr(r_addr),
        .sequence(display)
    );

    memory #(
        .WORD_SIZE(WORD_SIZE),
        .WORD_INIT(2'b10),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEMORY_QTY(MEMORY_QTY)
    ) sequnencer_memory (
        .clock(clock),
        .reset(reset),
        .w_addr(w_addr),
        .w_en(w_en),
        .w_data(w_data),
        .r_en(r_en),
        .r_addr(r_addr),

        .w_ready(w_ready),
        .r_ready(r_ready),
        .r_data(r_data)
    );
endmodule