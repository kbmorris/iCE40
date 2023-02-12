module clock_divider #(
    // Parameters
    parameter COUNTER_SIZE = 24,
    parameter CLOCK_INTERVAL =  12000000,
    parameter CLOCK_MAXCOUNT = CLOCK_INTERVAL - 1
) (
    // Inputs
    input clock_in,
    input reset,
    // Outputs
    output reg clock_out
);

    // Internal Storage
    reg state;
    reg [COUNTER_SIZE-1:0] clock_counter;

    //
    always @ (posedge clock_in or posedge reset) begin
        if (reset) begin
            clock_counter <= 1'b0;
            clock_out <= 1'b0;
        end else if (clock_counter == CLOCK_MAXCOUNT) begin
            clock_counter <= 1'b0;
            clock_out <= ~clock_out;
        end else begin
            clock_counter <= clock_counter + 1'b1;
        end
    end
endmodule

