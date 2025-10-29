module control_unit#(
    parameter int REG_WIDTH = 64,
    parameter int ALU_CTRL_BITS = 5
)
(
    input [31:0] instruction, 
 
    output reg [ALU_CTRL_BITS - 1 : 0] ALUCtrl, 
    output branch,
    output MemRead, 
    output MemtoReg,
    output MemWrite,
    output RegWrite, // writeEnable
    output reg MemSign, // data type for memory accesses (signed / unsigned)
    output reg [1:0] MemWidth // data width for memory accessess (half, word, double)
);
    // rs2 if ALUCtrl[ALU_CTRL_BITS - 1] = 0 and imm if ALUCtrl[ALU_CTRL_BITS - 1] = 1
    wire [6:0] opcode;
    wire [2:0] funct3; // funct3 for r-type
    wire [6:0] funct7; // funct7 for r-type
    wire [5:0] funct6; // funct6 for i-type
    wire r_type, i_type, s_type, b_type, j_type, load_type, is_jal, is_jalr, is_lui, is_auipc;

    // opcode from the instruction
    assign opcode = instruction[6:0];

    //funct3 from the instruction
    assign funct3 = instruction[14:12];

    // checking the type of the instruction
    assign r_type = (opcode == 7'b0110011);
    assign i_type = (opcode == 7'b0010011);
    assign load_type = (opcode == 7'b0000011); // load instructions
    assign s_type = (opcode == 7'b0100011);
    assign b_type = (opcode == 7'b1100011);
    assign is_jal = (opcode == 7'b1101111);
    assign is_jalr = (opcode == 7'b1100111);
    assign is_lui = (opcode == 7'b0110111);
    assign is_auipc = (opcode == 7'b0010111);

    // for r-type
    assign funct7 = instruction[31:25];
    
    // for a few i-type instructions
    assign funct6 = instruction[31:26];

    always @ (*) begin
        MemSign = 1'b0;
        MemWidth = 2'd0;
        // ALUCtrl logic for r-type instructions
        if(r_type) begin
            case(funct7[5])
                1'b0:
                    begin
                        case(funct3)
                            3'd0:
                                ALUCtrl = 5'b00000; // add
                            3'd1:
                                ALUCtrl = 5'b00101; // sll 
                            3'd2:
                                ALUCtrl = 5'b01000; // slt
                            3'd3:
                                ALUCtrl = 5'b01001; // sltu
                            3'd4:
                                ALUCtrl = 5'b00010; // xor
                            3'd5:
                                ALUCtrl = 5'b00110; // srl
                            3'd6:
                                ALUCtrl = 5'b00011; // or
                            3'd7:
                                ALUCtrl = 5'b00100; // and
                            default:
                                ALUCtrl = 5'b0xxxx;
                        endcase
                    end
                1'b1:
                    if(funct3 == 3'd0) ALUCtrl = 5'b00001; // sub
                    else if(funct3 == 3'd5) ALUCtrl = 5'b00111; // sra
                    else ALUCtrl = 5'b0xxxx;
            endcase
        end
        // ALUCtrl logic for i-type instructions

        if(i_type) begin
            case(funct3)
                3'd0:
                    ALUCtrl = 5'b10000; // addi
                3'd1:
                    ALUCtrl = 5'b10100; // slli
                3'd2:
                    ALUCtrl = 5'b10111; // slti
                3'd3:
                    ALUCtrl = 5'b11000; // sltiu
                3'd4:
                    ALUCtrl = 5'b10001; // xori
                3'd5: begin
                    if(funct6[4]) ALUCtrl = 5'b10110; // srai
                    else ALUCtrl = 5'b10101; // srli
                end
                3'd6:
                    ALUCtrl = 5'b10010; // ori
                3'd7:
                    ALUCtrl = 5'b10011; // andi
                default: 
                    ALUCtrl = 5'b1xxxx;
            endcase
        end
        
        // ALUCtrl logic for load instructions
        if(load_type) begin
            ALUCtrl = 5'b10000; // require addi: rd = M[rs1 + imm][whatever bits]
            {MemSign, MemWidth} = funct3;
        end

        // ALUCtrl logic for s-type instructions
        if(s_type) begin
            ALUCtrl = 5'b10000; // require addi: M[rs1+imm][whatever bits] = rs2[whatever bits]
            {MemSign, MemWidth} = funct3;
        end
    end

assign branch = b_type | is_jal | is_jalr | is_lui | is_auipc;
assign MemRead = load_type;
assign MemtoReg = load_type;
assign MemWrite = s_type;
assign RegWrite = (r_type | i_type | load_type | is_jal | is_jalr | is_lui | is_auipc);

endmodule