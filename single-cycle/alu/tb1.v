module tb1();

logic [31:0] instruction;

logic clk, rst;
logic [63:0] imm;
logic [63:0] alu_out;
logic alu_zero;


logic branch, MemRead, MemtoReg, MemWrite, RegWrite;
logic [4:0] ALUCtrl;
logic [63:0] rs1, rs2;

reg_file reg_file_dut (
    // clock and reset inputs
    .clk(clk), 
    .rst(rst),

    // write inputs
    .writeEnable(RegWrite),
    .waddr(instruction[11:7]),
    .wdata(alu_out),

    // read inputs
    .raddr1(instruction[19:15]), 
    .raddr2(instruction[24:20]),
    
    // outputs
    .rdata1(rs1),
    .rdata2(rs2)
);

control_unit control_unit_dut (
    // instruction input
    .instruction(instruction),

    // control outputs
    .ALUCtrl(ALUCtrl),
    .branch(branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite)
);

imm_gen imm_gen_dut(
    // instruction input
    .instruction(instruction),

    // immediate value output
    .imm(imm)
);

alu alu_dut(
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .ALUCtrl(ALUCtrl),
    .alu_out(alu_out),
    .alu_zero(alu_zero)
);

initial begin
    instruction = 32'b11111111111100000000011100010011; // addi x14, x0, -1
    clk = 0;
    rst = 0;
    #2;
    rst = 1;
    #2;
    rst = 0;
    #1;
    #4;
    instruction = 32'b01000000111000000000000010110011; // addi x14, x14, 100
    #10;
    instruction = 32'b00000001000001110101011010010011;
end

initial begin
    forever #5 clk = ~clk;
end

task print_regfile();
    integer i;
    begin
        $display("\n================= Register File =================");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x%0d : 0x%016h", i, reg_file_dut.reg_array[i]);
        end
        $display("======================================================\n");
    end
endtask

initial begin
    integer i;
    #3;
    // print_regfile();
    #5;
    print_regfile();
    #5;
    print_regfile();
    #10;
    print_regfile();
end

initial begin
    $display("Starting the testbench:");
    $display("The initial state of the Register file is:");
    #50;
    // print_regfile(reg_array);
    $display("Finished Simulation.");
    $finish;
end

endmodule