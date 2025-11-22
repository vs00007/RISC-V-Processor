module top_module#(
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32,
    parameter int PC_WIDTH = 64,
    parameter int ALU_CTRL_BITS = 5
)
(
    input clk, rst
);
    logic [31:0] instruction_1_in, instruction_1_out;
    logic [PC_WIDTH - 1 : 0] pc_reg_in, pc_reg_out, pc_1_in, pc_1_out, pc_2_out;
    logic [REG_WIDTH - 1 : 0] rs1_2_in, rs1_2_out, rs2_2_in, rs2_2_out, rs2_3_out;
    logic [REG_WIDTH - 1 : 0] imm_2_in, imm_2_out;
    logic [ALU_CTRL_BITS - 1 : 0] ALUCtrl_2_in, ALUCtrl_2_out;
    logic branch_2_in, branch_2_out;
    logic is_jal_2_in, is_jal_2_out, is_jal_3_out, is_jal_4_out;
    logic is_jalr_2_in, is_jalr_2_out, is_jalr_3_out, is_jalr_4_out;
    logic is_auipc_2_in, is_auipc_2_out, is_auipc_3_out, is_auipc_4_out;
    logic MemRead_2_in, MemRead_2_out, MemRead_3_out;
    logic MemtoReg_2_in, MemtoReg_2_out, MemtoReg_3_out, MemtoReg_4_out;
    logic MemWrite_2_in, MemWrite_2_out, MemWrite_3_out;
    logic RegWrite_2_in, RegWrite_2_out, RegWrite_3_out, RegWrite_4_out;
    logic MemSign_2_in, MemSign_2_out, MemSign_3_out;
    logic [1:0] MemWidth_2_in, MemWidth_2_out, MemWidth_3_out;
    logic [2:0] funct3_2_out;
    logic [$clog2(REG_COUNT) - 1 : 0] rd_addr_2_out, rd_addr_3_out, rd_addr_4_out;
    logic [REG_WIDTH - 1 : 0] alu_res_3_in, alu_res_3_out, alu_res_4_out;
    logic branch_taken_3_in;
    logic [PC_WIDTH - 1 : 0] pc_branch_addr_3_in, pc_branch_addr_3_out;
    logic [REG_WIDTH - 1 : 0] mem_read_data_4_in, mem_read_data_4_out;
    logic [REG_WIDTH - 1 : 0] reg_wb_data;
    logic [PC_WIDTH - 1 : 0] pc_4;
    logic [REG_WIDTH - 1 : 0] alu_op1;
    logic [PC_WIDTH - 1 : 0] pc_jump_addr_3_in;
    logic [1:0] forwardA, forwardB;
    logic [$clog2(REG_COUNT)-1:0] rs1_addr_2_out, rs2_addr_2_out; 
    logic [REG_WIDTH-1:0] forwarded_rs1, forwarded_rs2;
    logic stall, flush;
    logic [4:0] rs2_addr_3_out;
    logic [1:0] flag;


    pc_reg pc_reg_dut(
        // inputs
        .clk(clk),
        .rst(rst),
        .pc_in(pc_reg_in),
        .stall(stall),
        .flush(flush),

        // output
        .pc_out(pc_1_in)
    );

    pc_next_mux pc_next_mux_dut(
        // inputs
        .branch_taken(branch_taken_3_in),
        .jump(is_jal_2_out | is_jalr_2_out),
        .pc_plus_4(pc_4),
        .branch_addr(pc_branch_addr_3_in),
        .pc_jump_addr(pc_jump_addr_3_in),

        // output
        .pc_next(pc_reg_in)
    );

    pc_4_add pc_4_add_dut(
        // input
        .pc_in(pc_1_in),

        // output
        .pc_out(pc_4)
    );

    instruction_mem instruction_mem_dut(
        // inputs
        .clk(clk),
        .pc(pc_1_in),

        // output
        .instruction(instruction_1_in)
    );

    if_id_reg if_id_reg_dut(
        // inputs
        .clk(clk),
        .rst(rst),
        .PC_in(pc_1_in),
        .instruction_in(instruction_1_in),
        .stall(stall),
        .flush(flush),

        // outputs
        .PC_out(pc_1_out),
        .instruction_out(instruction_1_out)
    );

    // ID Stage

    reg_file reg_file_dut (
        // inputs 
        .clk(clk), 
        .rst(rst),
        .writeEnable(RegWrite_4_out),
        // Check this logic !!!
        .waddr(rd_addr_4_out),
        .wdata(reg_wb_data),
        .raddr1(instruction_1_out[19:15]), 
        .raddr2(instruction_1_out[24:20]),

        // outputs
        .rdata1(rs1_2_in),
        .rdata2(rs2_2_in)
    );

    imm_gen imm_gen_dut(
        // input 
        .instruction(instruction_1_out),

        //output
        .imm(imm_2_in)
    );

    control_unit control_unit_dut(
        // input 
        .instruction(instruction_1_out),

        // outputs
        .ALUCtrl(ALUCtrl_2_in),
        .branch(branch_2_in),
        .is_jal(is_jal_2_in),
        .is_jalr(is_jalr_2_in),
        .is_auipc(is_auipc_2_in),
        .MemRead(MemRead_2_in),
        .MemtoReg(MemtoReg_2_in),
        .MemWrite(MemWrite_2_in),
        .RegWrite(RegWrite_2_in),
        .MemSign(MemSign_2_in),
        .MemWidth(MemWidth_2_in)
    );

    id_ex_reg id_ex_reg_dut(
        // inputs 
        .clk(clk),
        .rst(rst),
        .WB_Ctrl_in({is_jal_2_in, is_jalr_2_in, is_auipc_2_in, MemtoReg_2_in, RegWrite_2_in}),
        .M_Ctrl_in({MemRead_2_in, MemWrite_2_in, MemSign_2_in, MemWidth_2_in}),
        .EX_Ctrl_in({ALUCtrl_2_in, branch_2_in}),
        .PC_in(pc_1_out),
        .rs1_data_in(rs1_2_in),
        .rs2_data_in(rs2_2_in),
        .imm_in(imm_2_in),
        .funct3_in(instruction_1_out[14:12]), // for branch taken block
        .rd_addr_in(instruction_1_out[11:7]),
        .rs1_addr_in(instruction_1_out[19:15]),
        .rs2_addr_in(instruction_1_out[24:20]),
        .stall(stall),
        .flush(flush),

        // outputs
        .PC_out(pc_2_out),
        .rs1_data_out(rs1_2_out),
        .rs2_data_out(rs2_2_out),
        .imm_out(imm_2_out),
        .funct3_out(funct3_2_out),
        .rd_addr_out(rd_addr_2_out),
        .WB_Ctrl_out({is_jal_2_out, is_jalr_2_out, is_auipc_2_out, MemtoReg_2_out, RegWrite_2_out}),
        .M_Ctrl_out({MemRead_2_out, MemWrite_2_out, MemSign_2_out, MemWidth_2_out}),
        .EX_Ctrl_out({ALUCtrl_2_out, branch_2_out}),
        .rs1_addr_out(rs1_addr_2_out),
        .rs2_addr_out(rs2_addr_2_out)
    );

    // EX stage 

    alu_op1_mux alu_op1_mux_dut(
        // inputs
        .jump(is_jal_2_out | is_jalr_2_out | is_auipc_2_out),
        .rs1(forwarded_rs1),
        .pc(pc_2_out),

        // output
        .operand1(alu_op1)
    );

    alu alu_dut(
        // inputs 
        .rs1(alu_op1),
        .rs2(forwarded_rs2),
        .imm(imm_2_out),
        .ALUCtrl(ALUCtrl_2_out),

        // output
        .alu_out(alu_res_3_in)
    );

    branch_taken branch_taken_dut(
        // inputs
        .rs1(forwarded_rs1),
        .rs2(forwarded_rs2),
        .funct3(funct3_2_out),
        .branch(branch_2_out),

        // output
        .branch_taken_out(branch_taken_3_in)
    );

    pc_jump pc_jump_dut(
        // inputs
        .pc(pc_2_out),
        .imm(imm_2_out),
        .rs1(rs1_2_out),
        .is_jal(is_jal_2_out),
        .is_jalr(is_jalr_2_out),

        // output
        .pc_jump(pc_jump_addr_3_in)
    );

    pc_add_imm pc_add_imm_dut(
        // inputs
        .pc(pc_2_out),
        .imm(imm_2_out),
         
        // output
        .pc_out(pc_branch_addr_3_in)
    );

    ex_mem_reg ex_mem_reg_dut(
        // inputs
        .clk(clk),
        .rst(rst),
        .WB_Ctrl_in({is_jal_2_out, is_jalr_2_out, is_auipc_2_out, MemtoReg_2_out, RegWrite_2_out}),
        .M_Ctrl_in({MemRead_2_out, MemWrite_2_out, MemSign_2_out, MemWidth_2_out}),
        .PC_in(pc_branch_addr_3_in),
        .ALU_res_in(alu_res_3_in),
        .rs2_data_in(flag == 2'b10 ? reg_wb_data : (flag == 2'b01 ? alu_res_3_out : rs2_2_out)),
        .rd_addr_in(rd_addr_2_out),
        .rs2_addr_in(rs2_addr_2_out),

        // outputs
        .WB_Ctrl_out({is_jal_3_out, is_jalr_3_out, is_auipc_3_out, MemtoReg_3_out, RegWrite_3_out}),
        .M_Ctrl_out({MemRead_3_out, MemWrite_3_out, MemSign_3_out, MemWidth_3_out}),
        .PC_out(pc_branch_addr_3_out),
        .ALU_res_out(alu_res_3_out),
        .rs2_data_out(rs2_3_out),
        .rd_addr_out(rd_addr_3_out),
        .rs2_addr_out(rs2_addr_3_out)
    );

    // MEM stage

    data_mem data_mem_dut(
        // inputs
        .clk(clk),
        .MemRead(MemRead_3_out),
        .MemWrite(MemWrite_3_out),
        .MemSign(MemSign_3_out),
        .MemWidth(MemWidth_3_out),
        .wdata(rs2_3_out),
        .full_addr(alu_res_3_out),

        // outputs
        .rdata(mem_read_data_4_in)
    );

    mem_wb_reg mem_wb_reg_dut(
        // inputs
        .clk(clk),
        .WB_Ctrl_in({is_jal_3_out, is_jalr_3_out, is_auipc_3_out, MemtoReg_3_out, RegWrite_3_out}),
        .mem_read_data_in(mem_read_data_4_in),
        .ALU_res_in(alu_res_3_out),
        .rd_addr_in(rd_addr_3_out),

        // outputs 
        .WB_Ctrl_out({is_jal_4_out, is_jalr_4_out, is_auipc_4_out, MemtoReg_4_out, RegWrite_4_out}),
        .mem_read_data_out(mem_read_data_4_out),
        .ALU_res_out(alu_res_4_out),
        .rd_addr_out(rd_addr_4_out)
    );

    // WB stage
    
    wb_mux wb_mux_dut(
        // inputs
        .ALU_res(alu_res_4_out),
        .mem_read_data(mem_read_data_4_out),
        .MemtoReg(MemtoReg_4_out),

        // output
        .reg_wb_data(reg_wb_data)
    );

    forwarding_unit forwarding_unit_dut(
        // inputs
        .EX_MEM_RegWrite(RegWrite_3_out),
        .MEM_WB_RegWrite(RegWrite_4_out),
        .EX_MEM_rd(rd_addr_3_out),
        .MEM_WB_rd(rd_addr_4_out),
        .ID_EX_rs1(rs1_addr_2_out),
        .ID_EX_rs2(rs2_addr_2_out),

        // outputs
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    forward_mux forward_mux_dut(
        // inputs
        .reg_data_rs1(rs1_2_out),
        .reg_data_rs2(rs2_2_out),
        .ex_alu_res(alu_res_3_out),
        .reg_wb_data(reg_wb_data),
        .forwardA(forwardA),
        .forwardB(forwardB),

        // outputs
        .forwarded_rs1(forwarded_rs1),
        .forwarded_rs2(forwarded_rs2)
    );

    // hazard detection block
    hazard_unit hazard_unit_dut(
        // inputs
        .ID_EX_MemRead(MemRead_2_out),
        .ID_EX_rd(rd_addr_2_out),
        .IF_ID_rs1(instruction_1_out[19:15]),
        .IF_ID_rs2(instruction_1_out[24:20]),
        .branch_taken(branch_taken_3_in),
        .is_jal(is_jal_2_out),
        .is_jalr(is_jalr_2_out),

        // outputs
        .stall(stall),
        .flush(flush)
    );  

    // store forwarding 
    store_forwarding_unit store_forwarding_unit_dut(
        // inputs
        .MEM_WB_rd_addr(rd_addr_4_out),
        .EX_MEM_rd_addr(rd_addr_3_out),
        .ID_EX_rs2_addr(rs2_addr_2_out),
        // output
        .flag(flag)
    );
endmodule