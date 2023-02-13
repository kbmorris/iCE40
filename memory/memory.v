module memory #(
    parameter WORD_SIZE = 8,
    parameter WORD_INIT = 8'b0,
    parameter ADDRESS_SIZE = 4,
    parameter MEMORY_QTY = 16,
    parameter DELAY_SIZE = 1,
    parameter READ_DELAY = 1,
    parameter WRITE_DELAY = 1
) (
    //Inputs
    input clock,
    input w_en,
    input r_en,
    input reset,
    input [ADDRESS_SIZE-1:0] w_addr,
    input [ADDRESS_SIZE-1:0] r_addr,
    input [WORD_SIZE-1:0] w_data,
    //Outputs
    output reg [WORD_SIZE-1:0] r_data,
    output reg r_rdy,
    output reg w_rdy
);
    // Local Parameters
    localparam OFF = 1'b0;
    localparam ON = 1'b1;
    
    //Allocate memory and timing registers
    reg [WORD_SIZE-1:0] mem [0:MEMORY_QTY-1];
    reg [ADDRESS_SIZE-1:0] counter;
    //Memory access block
    reg init_state = OFF;
    always @ (posedge clock or posedge reset) begin
        // Reset initiates memory initialization
        if (reset) begin
            init_state <= ON;
            counter <= MEMORY_QTY - 1;
            w_delay <= WRITE_DELAY;
        // Initialize memory on init_state
        end else if (init_state) begin
            if (counter==0 & w_delay==0) begin
                init_state <= OFF;
            end else if (w_delay==0) begin
                counter <=counter - 1;
                w_delay <= WRITE_DELAY;
            end else begin
                mem[counter] <= WORD_INIT;
                w_delay <= w_delay - 1;
            end
        end else begin
            if (w_en) begin
            mem[w_addr] <= w_data;
            end
            if (r_en) begin
                r_data <= mem[r_addr];
            end
        end
    end

    //Memory Timing
    //Read/Write Timing State Machines
    localparam WAIT = 1'b0;
    localparam READ = 1'b1;
    localparam WRITE = 1'b1;
    reg [DELAY_SIZE-1:0] r_delay;
    reg [DELAY_SIZE-1:0] w_delay;
    reg r_state = WAIT;
    reg w_state = WAIT;

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            r_state <= WAIT;
            r_rdy <= OFF;
            r_delay <= 0;
            w_state <= WAIT;
            w_rdy <= OFF;
            w_delay <= 0;
        end else if (init_state) begin
        end else begin
            case (r_state)
            WAIT:
                if (r_en) begin
                    r_state <= READ;
                    r_delay <= READ_DELAY;
                    r_rdy <= OFF;
                end else begin
                    r_rdy <= OFF;
                end
            READ:
                if (r_delay==0) begin
                    r_rdy <= ON;
                    r_state <= WAIT;
                end else begin
                    r_delay <= r_delay - 1;
                end
            endcase
            case (w_state)
            WAIT:
                if (w_en) begin
                    w_state <= WRITE;
                    w_delay <= WRITE_DELAY;
                    w_rdy <= OFF;
                end
            WRITE:
                if (w_delay==0) begin
                    w_rdy <= ON;
                    w_state <= WAIT;
                end else begin
                    w_delay <= w_delay - 1;
                end
            endcase
        end
    end
endmodule