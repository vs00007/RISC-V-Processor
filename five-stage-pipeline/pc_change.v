module pc_change #(
    parameter int PC_WIDTH = 64,
    parameter int REG_WIDTH = 64
) 
(
    input [PC_WIDTH - 1 : 0] pc,
    input [REG_WIDTH - 1 : 0] imm,
    input [REG_WIDTH - 1 : 0] rs1, //
    input branch,
    input is_jal,
    input is_jalr, //
    input branch_taken,
    
    output reg [PC_WIDTH - 1 : 0] pc_next
);
    wire [PC_WIDTH - 1 : 0] pc_4, pc_branch;
    wire temp0, temp1; // temp wires

    assign {temp0, pc_4} = pc + 4;
    assign {temp1, pc_branch} = pc + imm;

    always @ (*) begin
        pc_next = pc_4;
        if (branch & branch_taken) pc_next = pc_branch;
        else if (is_jal) pc_next = pc_branch;
        else if (is_jalr) pc_next = rs1 + imm; //
    end

endmodule