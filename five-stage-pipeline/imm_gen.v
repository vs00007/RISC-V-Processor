// the immediate generation block. Takes bits from the imm field of 
// the instruction and sign extends it to fill the register width (for easier addition with registers)

module imm_gen #(
    parameter int REG_WIDTH = 64
) (
    input [31 : 0] instruction,
    output reg [REG_WIDTH - 1 : 0] imm 
);
    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    
    always @ * begin
        case(opcode)
            7'b0010011: // i-type
                imm = {{(REG_WIDTH - 12){instruction[31]}}, instruction[31:20]};
            7'b0000011: // load instructions
                imm = {{(REG_WIDTH - 12){instruction[31]}}, instruction[31:20]};
            7'b0100011: // s-type
                imm = {{(REG_WIDTH - 12){instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: // b-type
                imm = {{(REG_WIDTH - 13){instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            7'b1101111: // jal
                imm = {{(REG_WIDTH - 21){instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            7'b1100111: // jalr
                imm = {{(REG_WIDTH - 12){instruction[31]}}, instruction[31:20]};
            7'b0110111: // lui
                imm = {{(REG_WIDTH - 32){instruction[31]}}, instruction[31:12], 12'd0};
            7'b0010111: // auipc
                imm = {{(REG_WIDTH - 32){instruction[31]}}, instruction[31:12], 12'd0};
            default:
                imm = 0;
        endcase
    end
endmodule