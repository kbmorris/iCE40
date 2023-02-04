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
            value <= START_VALUE;
            state <= STATE_WAIT;
            enabled <= OFF;
            done <= OFF;
        end else begin
            case (state)
                STATE_WAIT: begin
                    if (start) begin
                        done <= OFF;
                        enabled <= ON;
                        value <= START_VALUE;
                        state <= STATE_COUNT;
                    end else begin
                        done <= OFF;
                        enabled <= OFF;
                    end
                end
                STATE_COUNT: begin
                    // Transition to Wait State
                    if (value == STOP_VALUE) begin
                        enabled <= OFF;
                        done <= ON;
                        state <= STATE_WAIT;
                    // or Cycle the Counter
                    end else begin
                        value <= value + STEP_VALUE;
                        enabled <= ON;
                        done <= OFF;
                    end
                end
            endcase
        end
    end
endmodule