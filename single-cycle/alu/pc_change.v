module pc_change #(
    parameter int PC_WIDTH = 64,
    parameter int REG_WIDTH = 64
) 
(
    input [PC_WIDTH - 1 : 0] pc,
    input [REG_WIDTH - 1 : 0] imm,
    input branch,
    input [REG_WIDTH - 1 : 0] rs1,
    input [REG_WIDTH - 1 : 0] rs2,
    input [2:0] funct3,
    output reg [PC_WIDTH - 1 : 0] pc_next
);
    wire [PC_WIDTH - 1 : 0] pc_4, pc_branch;
    wire temp0, temp1; // temp wires

    assign {temp0, pc_4} = pc + 4;
    assign {temp1, pc_branch} = pc + imm;

    always @ (*) begin
        pc_next = pc_4;
        if (branch) begin
            case(funct3)
                3'd0: // beq
                    pc_next = (rs1 == rs2) ? pc_branch : pc_4;
                3'd1: // bne
                    pc_next = (rs1 == rs2) ? pc_4 : pc_branch;
                3'd4: // blt
                    pc_next = ($signed(rs1) < $signed(rs2)) ? pc_branch : pc_4;
                3'd5: // bge
                    pc_next = ($signed(rs1) >= $signed(rs2)) ? pc_branch : pc_4;
                3'd6: // bltu
                    pc_next = (rs1 < rs2) ? pc_branch : pc_4;
                3'd7: // bgeu
                    pc_next = (rs1 >= rs2) ? pc_branch : pc_4;
                default:
                    pc_next = pc_4;
            endcase
        end
    end

endmodule