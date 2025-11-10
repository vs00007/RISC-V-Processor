module pc_add_imm #(
    parameter int REG_WIDTH = 64,
    parameter int PC_WIDTH = 64
)
(
    input [PC_WIDTH - 1 : 0] pc,
    input [REG_WIDTH - 1 : 0] imm,

    output reg [PC_WIDTH - 1 : 0] pc_out
);
    always @ (*) begin
        pc_out = pc + imm;
    end
endmodule