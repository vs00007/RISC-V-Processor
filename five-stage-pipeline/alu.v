// alu module. alu is purely combinational.
module alu #(
    parameter int REG_WIDTH = 64,    // register width
    parameter int ALU_CTRL_BITS = 5  // number of alu control bits
) (
    input [REG_WIDTH - 1 : 0] rs1, rs2, imm,
    input [ALU_CTRL_BITS - 1 : 0] ALUCtrl,
    
    output reg [REG_WIDTH - 1 : 0] alu_out
);
    wire [REG_WIDTH - 1 : 0] add_ans, sub_ans, xor_ans, or_ans, and_ans, sll_ans, srl_ans, sra_ans, slt_ans, sltu_ans;
    wire [REG_WIDTH - 1 : 0] addi_ans, xori_ans, ori_ans, andi_ans, slli_ans, srli_ans, srai_ans, slti_ans, sltui_ans;
    wire t0, t1, t2, t3; // temp wires

    // compute all the operation results (R-Type)
    assign {t0, add_ans} = rs1 + rs2;
    assign {t1, sub_ans} = rs1 - rs2;
    assign xor_ans = rs1 ^ rs2;
    assign or_ans = rs1 | rs2;
    assign and_ans = rs1 & rs2;
    assign sll_ans = rs1 << rs2[5:0];
    assign srl_ans = rs1 >> rs2[5:0];
    assign sra_ans = $signed(rs1) >>> rs2[5:0];
    assign slt_ans = ($signed (rs1) < $signed(rs2)) ? {{(REG_WIDTH-1){1'b0}}, 1'b1}: 0;
    assign sltu_ans = (rs1 < rs2) ? {{(REG_WIDTH-1){1'b0}}, 1'b1}: 0;


    // compute all the operation results (I-Type)
    assign {t2, addi_ans} = rs1 + imm;
    assign xori_ans = rs1 ^ imm;
    assign ori_ans = rs1 | imm;
    assign andi_ans = rs1 & imm;
    assign slli_ans = rs1 << imm[5:0];
    assign srli_ans = rs1 >> imm[5:0];
    assign srai_ans = $signed(rs1) >>> imm[5:0];
    assign slti_ans = ($signed (rs1) < $signed(imm)) ? {{(REG_WIDTH-1){1'b0}}, 1'b1}: 0;
    assign sltui_ans = (rs1 < imm) ? {{(REG_WIDTH-1){1'b0}}, 1'b1}: 0;

    // assign output based on the ALUCtrl

    always @ (*) begin
        case (ALUCtrl)
            5'b00000: alu_out = add_ans;
            5'b00001: alu_out = sub_ans;
            5'b00010: alu_out = xor_ans;
            5'b00011: alu_out = or_ans;
            5'b00100: alu_out = and_ans;
            5'b00101: alu_out = sll_ans;
            5'b00110: alu_out = srl_ans;
            5'b00111: alu_out = sra_ans; 
            5'b01000: alu_out = slt_ans;
            5'd01001: alu_out = sltu_ans; // R-Type

            5'b10000: alu_out = addi_ans;
            5'b10001: alu_out = xori_ans;
            5'b10010: alu_out = ori_ans;
            5'b10011: alu_out = andi_ans;
            5'b10100: alu_out = slli_ans;
            5'b10101: alu_out = srli_ans;
            5'b10110: alu_out = srai_ans;
            5'b10111: alu_out = slti_ans; 
            5'b11000: alu_out = sltui_ans; // I-type

            5'b11110: alu_out = rs1 + 4; // jal: rs1 is pc in this case due to the alu_op1_sel module
            5'b11111: alu_out = imm; // lui

            default: alu_out = {REG_WIDTH{1'bx}};
        endcase
    end
endmodule