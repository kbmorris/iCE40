module sequencer_project(
    // Inputs
    input clock,
    input Reset,
    input Store,
    input [WORD_SIZE-1:0] Sequence,

    // Outputs
    output wire [WORD_SIZE-1:0] display
);

    localparam WORD_SIZE = 2;
    localparam ADDRESS_SIZE = 4;
    localparam MEMORY_QTY = 16;

    wire [WORD_SIZE - 1:0] sequence;
    assign sequence = ~Sequence;

    wire reset;
    assign reset = ~Reset;

    wire store;
    assign store = ~Store;

    wire seconds;
    wire db_store;
    wire [ADDRESS_SIZE - 1:0] w_addr;
    wire w_en;
    wire [WORD_SIZE - 1:0] w_data;
    wire r_en;
    wire [ADDRESS_SIZE - 1:0] r_addr;
    wire w_ready;
    wire r_ready;
    wire [WORD_SIZE - 1:0] r_data;

    clock_divider #(

    ) second_clock (
        .clock(clock),
        .reset(reset),
        .div_clock(seconds)
    );

    debounce #(
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