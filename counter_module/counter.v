module counter #(
    // Parameters
    parameter COUNTER_SIZE = 8,
    parameter START_VALUE = 8'b0,
    parameter STOP_VALUE = 8'b1,
    parameter STEP_VALUE = 1'b1
) (
    // // Inputs
    // input clock,
    // input reset,
    // input start,
    input reset_in,
    input start_in,
    input clock_in,
    input pmod3,


    // Outputs
    // output reg done,
    // output reg enabled,
    // output reg [COUNTER_SIZE-1:0] value
    // Outputs
    output [7:0] led,

    // Debug Outputs
    output D1,
    output D2,
    output D3,
    output D4,
    output D5
);
    // Debug Assignments
    wire clock = ~pmod3;
    wire reset = ~reset_in;
    wire start = ~start_in;
    reg done;
    assign D1 = done;
    reg enabled;
    assign D2 = enabled;
    reg [7:0] value;
    assign led = value;


    // Internal Storage
    reg state;


    // States
    localparam STATE_WAIT = 1'b0;
    localparam STATE_COUNT = 1'b0;
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    // // Instantiate the clock
    // clock_divider clock1 (
    //     .clock_in(clock_in),
    //     .reset(reset),
    //     .clock_out(clock)
    // );

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            enabled <= OFF;
            done <= ON;
            state <= STATE_WAIT;
        end else 

        case (state)
            STATE_WAIT: begin
                //Transition to Count State
                if (start & ~reset) begin
                    enabled <= ON;
                    value <= START_VALUE;
                    state <= STATE_COUNT;
                end
            end
            STATE_COUNT: begin
                // Transition to Wait State
                if (value == STOP_VALUE)begin
                    enabled <= OFF;
                    done <= ON;
                    state <= STATE_WAIT;

                // Or Cycle Counter
                end else begin          
                    value <= value + STEP_VALUE;
                end
            end
        endcase
    end
endmodule