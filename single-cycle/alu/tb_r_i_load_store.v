module tb1();

logic [31:0] instruction;
logic clk, rst;
logic [63:0] imm;
logic [63:0] alu_out;
logic alu_zero;
logic branch, MemRead, MemtoReg, MemWrite, RegWrite;
logic [4:0] ALUCtrl;
logic [63:0] rs1, rs2;
logic [63:0] mem_write_data;
logic [63:0] mem_read_data;

top_module top_module_dut(
    .instruction(instruction),
    .clk(clk),
    .rst(rst)
);

always #5 clk = ~clk;

task print_regfile();
    integer i;
    begin
        $display("\n================= Register File =================");
        for (i = 0; i < 32; i = i + 1)
            $display("x%0d : 0x%016h", i, top_module_dut.reg_file_dut.reg_array[i]);
        $display("=================================================\n");
    end
endtask

integer file, status;
reg [31:0] instr_mem [0:255];
integer instr_count, i;

initial begin
    clk = 0;
    rst = 1;
    #10 rst = 0;
    $readmemh("data_mem_init.hex", top_module_dut.data_mem_dut.mem);

    // Load instructions from file
    $display("Loading instructions from 'instructions.txt'...");
    $readmemh("instructions.txt", instr_mem);
    
    instr_count = 0;
    // Count how many lines (until uninitialized value)
    while (instr_mem[instr_count] !== 32'bx)
        instr_count++;

    $display("Loaded %0d instructions.\n", instr_count);

    // Execute each instruction
    for (i = 0; i < instr_count; i = i + 1) begin
        instruction = instr_mem[i];
        $display("Executing instruction %0d: 0x%08h", i, instruction);
        
        #10; // simulate one "cycle" per instruction
        print_regfile();
    end

    $display("Finished simulation.");
    $display("Writing final data memory contents to file...");
    $writememh("data_mem_final.hex", top_module_dut.data_mem_dut.mem);
    $finish;
end

endmodule
