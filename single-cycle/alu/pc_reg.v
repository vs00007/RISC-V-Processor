module pc_reg #(
    parameter int PC_WIDTH = 64
)
(
    input clk,
    input rst,
    input [PC_WIDTH - 1 : 0] pc_in,
    output [PC_WIDTH - 1 : 0] pc_out
);
    always @ (posedge clk, posedge rst) begin
        if(rst) pc_out <= 0;
        else begin
            pc_out <= pc_in;
        end
    end
endmodule