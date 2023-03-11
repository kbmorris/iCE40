module store #(
    parameter WORD_SIZE = 8,
    parameter ADDRESS_SIZE = 4,
    parameter MEMORY_QTY = 16
) (
    //Inputs
    input clock,
    input store,
    input reset,
    input w_ready,
    input [WORD_SIZE - 1:0] sequence,

    //Outputs
    output reg w_en,
    output reg [ADDRESS_SIZE - 1:0] w_addr,
    output reg [WORD_SIZE - 1:0] w_data
);
    localparam ON = 1'b1;
    localparam OFF = 1'b0;
    localparam STORING = 1'b1;

    reg store_state = OFF;

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            w_addr <= -1;
            w_en <= OFF;
            store_state <= OFF;
        end else begin
            case (store_state)
                OFF: begin
                    if (store & w_ready) begin
                        store_state <= STORING;
                        w_addr <= w_addr + 1;
                        w_data <= sequence;
                        w_en <= ON;
                    end
                end
                STORING: begin
                    if (~store) begin
                        store_state <= OFF;
                        w_en <= OFF;
                    end else if (w_ready) begin
                        w_en <= OFF;
                    end
                end
            endcase
        end
    end
endmodule

