module pc_reg #(
    parameter int PC_WIDTH = 64
)
(
    input clk,
    input rst,
    input [PC_WIDTH - 1 : 0] pc_in,
    input stall,
    input flush,

    output reg [PC_WIDTH - 1 : 0] pc_out
);
    always @ (posedge clk, posedge rst) begin
        if(rst) pc_out <= 0;
        else if (flush) pc_out <= pc_in;
        else if (!stall) begin // do not change pc value when stall is high, if stall, value is already stored (since reg :))
            pc_out <= pc_in;
        end
    end
endmodule