// write the top module
module top_module(
    // input [31:0] instruction,
    input clk, rst
);
    logic [63:0] imm;
    logic [63:0] alu_out;
    logic alu_zero;
    logic branch, MemRead, MemtoReg, MemWrite, RegWrite;
    logic [4:0] ALUCtrl;
    logic [63:0] rs1, rs2;
    logic [63:0] mem_write_data;
    logic [63:0] mem_read_data;
    logic MemSign;
    logic [1:0] MemWidth;
    logic [63:0] pc_in;
    logic [63:0] pc_out;
    logic [31:0] instruction;
    logic branch_taken_out;
    logic is_jal;
    logic is_jalr;
    logic is_auipc;
    logic [63:0] operand1;

    reg_file reg_file_dut (
        // inputs 
        .clk(clk), 
        .rst(rst),
        .writeEnable(RegWrite),
        .waddr(instruction[11:7]),
        .wdata(MemtoReg ? mem_read_data : alu_out),
        .raddr1(instruction[19:15]), 
        .raddr2(instruction[24:20]),

        // outputs
        .rdata1(rs1),
        .rdata2(rs2)
    );

    control_unit control_unit_dut (
        // input
        .instruction(instruction),

        // outputs
        .ALUCtrl(ALUCtrl),
        .branch(branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .is_auipc(is_auipc),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .MemSign(MemSign),
        .MemWidth(MemWidth)
    );

    imm_gen imm_gen_dut(
        // input
        .instruction(instruction),

        // output
        .imm(imm)
    );

    alu alu_dut(
        // inputs
        .rs1(operand1),
        .rs2(rs2),
        .imm(imm),
        .ALUCtrl(ALUCtrl),

        // outputs
        .alu_out(alu_out),
        .alu_zero(alu_zero)
    );

    data_mem data_mem_dut(
        // inputs
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemSign(MemSign),
        .MemWidth(MemWidth),
        .wdata(rs2),
        .full_addr(alu_out),

        // output (read data)
        .rdata(mem_read_data)
    );

    pc_reg pc_reg_dut(
        // inputs
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),

        // output
        .pc_out(pc_out)
    );

    instruction_mem instruction_mem_dut(
        // inputs
        .clk(clk),
        .pc(pc_out),

        // output
        .instruction(instruction)
    );

    branch_taken branch_taken_dut(
        // inputs 
        .rs1(rs1),
        .rs2(rs2),
        .funct3(instruction[14:12]),

        // output
        .branch_taken_out(branch_taken_out)
    );

    pc_change pc_change_dut(
        // inputs
        .pc(pc_out),
        .imm(imm),
        .rs1(rs1),
        .branch(branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .branch_taken(branch_taken_out),

        // output
        .pc_next(pc_in)
    );

    alu_op1_mux alu_op1_mux_dut(
        // inputs
        .jump(is_jal | is_jalr | is_auipc),
        .rs1(rs1),
        .pc(pc_out),

        // output
        .operand1(operand1)
    );
endmodule