module alu_op1_mux #(
    parameter int REG_WIDTH = 64,
    parameter int PC_WIDTH = 64
)
(
    input jump,
    input [REG_WIDTH - 1 : 0] rs1,
    input [PC_WIDTH - 1 : 0] pc,

    output reg [REG_WIDTH - 1 : 0] operand1
);
    assign operand1 = jump ? pc : rs1;
endmodule