module clock_divider #(
    parameter COUNTER_SIZE = 24,
    parameter COUNTER_LIMIT = 6000000-1
) (
    //Inputs
    input clock,
    input reset,
    //Outputs
    output reg div_clock
);

    reg [COUNTER_SIZE - 1:0] counter = 0;

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            counter <= 0;
            div_clock <= 0;
        end else if (counter == COUNTER_LIMIT) begin
            counter <=0;
            div_clock <= ~div_clock;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule