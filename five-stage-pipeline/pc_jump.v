module pc_jump #(
    parameter int PC_WIDTH = 64,
    parameter int REG_WIDTH = 64
) 
(
    input [PC_WIDTH - 1 : 0] pc,
    input [REG_WIDTH - 1 : 0] imm,
    input [REG_WIDTH - 1 : 0] rs1,
    input is_jal,
    input is_jalr,
    
    output reg [PC_WIDTH - 1 : 0] pc_jump
);
    wire temp0, temp1; // temp wires


    always @ (*) begin
        pc_jump = pc;
        if (is_jal) pc_jump = pc + imm;
        else if (is_jalr) pc_jump = rs1 + imm;
    end
endmodule