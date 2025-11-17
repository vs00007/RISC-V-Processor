// the first register between IF and ID stages
module if_id_reg #(
    parameter int PC_WIDTH = 64
)
(
    input clk,
    input rst,
    input [PC_WIDTH - 1 : 0] PC_in,
    input [31 : 0] instruction_in,
    input stall,
    input flush,

    output reg [PC_WIDTH - 1 : 0] PC_out,
    output reg [31 : 0] instruction_out
);
    always @(posedge clk, posedge rst) begin
        if(rst | flush) begin
            PC_out <= 0;
            instruction_out <= 0;
        end
        else if (!stall) begin // logic similar to in pc_reg
            PC_out <= PC_in;
            instruction_out <= instruction_in;
        end
    end
endmodule