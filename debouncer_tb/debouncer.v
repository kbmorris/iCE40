//------------------------------------------------------------------
//-- Debounce Module
//------------------------------------------------------------------

//-- Template for the top entity
module debouncer #(
    // Parameters
    parameter CLOCK_SIZE = 24,
    parameter CLOCK_LENGTH = 12000,
    parameter CLOCK_START = 24'd0,
    parameter CLOCK_LIMIT = 24'd5999
) (
    // Inputs
    input   reset,
    input   button_in,
    input   clock_in,
    // Outputs
    output  reg button_out
);

    // States
    localparam OFF   = 1'b0;
    localparam ON   = 1'b1;

    // Internal Storage
    reg [(CLOCK_SIZE - 1):00] clock_counter;
    reg state;
    reg debounce_clk;

    // Debounce Clock
    always @ (posedge clock_in or posedge reset) begin
        if (reset) begin
            clock_counter <= CLOCK_START;
            debounce_clk <= 0;
        end else if (clock_counter == CLOCK_LIMIT) begin
            clock_counter <= CLOCK_START;
            debounce_clk <= ~debounce_clk;
        end else begin
            clock_counter <= clock_counter + 1'b1;
        end
    end

    // Debounce FSM
    always @ (posedge debounce_clk or posedge reset) begin
        //Reset to Idle
        if (reset) begin
            state <= OFF;
            button_out <= OFF;
        end else begin
            case (state)
                OFF: begin
                    //Transition to Debounce
                    if (button_in==ON) begin
                        state <= ON;
                        button_out <= ON;
                    end
                end

                ON: begin
                    //Transition to Idle
                    if (button_in==OFF) begin
                        state <= OFF;
                        button_out <= OFF;
                    end
                end
            endcase
        end
    end
endmodule