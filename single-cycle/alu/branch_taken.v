module branch_taken#(
    parameter int REG_WIDTH = 64
)
(
    input [REG_WIDTH - 1 : 0] rs1,
    input [REG_WIDTH - 1 : 0] rs2,
    input [2:0] funct3,

    output reg branch_taken_out
);
    always @ (*) begin
        case(funct3)
            3'd0: // beq
                branch_taken_out = (rs1 == rs2);
            3'd1: // bne
                branch_taken_out = ~(rs1 == rs2);
            3'd4: // blt
                branch_taken_out = ($signed(rs1) < $signed(rs2));
            3'd5: // bge
                branch_taken_out = ($signed(rs1) >= $signed(rs2));
            3'd6: // bltu
                branch_taken_out = (rs1 < rs2);
            3'd7: // bgeu
                branch_taken_out = (rs1 >= rs2);
            default:
                branch_taken_out = 0;
        endcase
    end
endmodule