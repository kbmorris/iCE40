module counter #(
    // Parameters
    parameter COUNTER_SIZE = 8,
    parameter START_VALUE = 8'b00000000,
    parameter STOP_VALUE = 8'b11111111,
    parameter STEP_VALUE = 1'b1
) (
    // Inputs
    input clock,
    input reset,
    input start,
    
    // Outputs
    output reg done,
    output reg enabled,
    output reg [COUNTER_SIZE-1:0] value
);

    // States
    localparam STATE_WAIT = 1'b0;
    localparam STATE_COUNT = 1'b1;
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    // Internal Storage
    reg state;

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            state <= STATE_WAIT;
            enabled <= OFF;
            done <= OFF;
        end else begin
            case (state)
                STATE_WAIT: begin
                    if (start) begin
                        state <= STATE_COUNT;
                        value <= START_VALUE;
                        enabled <= ON;
                    end else begin
                        done <= OFF;
                        enabled <= OFF;
                    end
                end
                STATE_COUNT: begin
                    // Prep done line
                    if (value == STOP_VALUE - STEP_VALUE) begin
                        value <= value + STEP_VALUE;
                        enabled <= ON;
                        done <= ON;
                    // Transition to Wait State
                    end else if (value == STOP_VALUE) begin
                        enabled <= OFF;
                        done <= ON;
                        state <= STATE_WAIT;
                    // or Cycle the Counter
                    end else begin
                        value <= value + STEP_VALUE;
                        enabled <= ON;
                    end
                end
            endcase
        end
    end
endmodule