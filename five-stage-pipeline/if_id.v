// the first register between IF and ID stages
module if_id_reg #(
    parameter int PC_WIDTH = 64,
)
(
    input clk,
    input rst,
    input [PC_WIDTH - 1 : 0] PC_in,
    input [31 : 0] instruction_in,

    output reg [PC_WIDTH - 1 : 0] PC_out,
    output reg [INSTRUCTION_WIDTH - 1 : 0] instruction_out
);
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            PC_out <= 0;
            instruction_out <= 0;
        end
        else begin
            PC_out <= PC_in;
            instruction_out <= instruction_in;
        end
    end
endmodule