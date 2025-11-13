`timescale 1ns/1ps
module top_module_tb;

    // parameters
    localparam int REG_WIDTH     = 64;
    localparam int PC_WIDTH      = 64;
    localparam int ALU_CTRL_BITS = 5;

    // signals
    logic clk, rst;
    integer i, cycle, instr_count, pc_index;
    logic [31:0] current_instr;

    // instantiate DUT
    top_module #(
        .REG_WIDTH(REG_WIDTH),
        .PC_WIDTH(PC_WIDTH),
        .ALU_CTRL_BITS(ALU_CTRL_BITS)
    ) top_module_dut (
        .clk(clk),
        .rst(rst)
    );

    // clock generation: 10ns period
    always #5 clk = ~clk;

    // waveform dump
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, top_module_tb);
    end

    // pretty print register file contents
    task print_regfile();
        integer j;
        begin
            $display("\n================= Register File =================");
            for (j = 0; j < 32; j = j + 1)
                $display("x%0d : 0x%016h", j, top_module_dut.reg_file_dut.reg_array[j]);
            $display("=================================================\n");
        end
    endtask

    // initialize memories
    initial begin
        clk = 0;
        rst = 1;
        cycle = 0;

        // Load instruction memory
        $display("Loading instructions from 'instructions.txt'...");
        $readmemh("instructions.txt", top_module_dut.instruction_mem_dut.instr_mem);
        instr_count = 0;
        while (top_module_dut.instruction_mem_dut.instr_mem[instr_count] !== 32'bx)
            instr_count++;
        $display("Loaded %0d instructions.\n", instr_count);

        // Load data memory
        $display("Loading data memory from 'data_mem_init.hex'...");
        $readmemh("data_mem_init.hex", top_module_dut.data_mem_dut.mem);
        $display("Data memory initialized.\n");

        // Release reset after a short delay
        #17 rst = 0;
        $display("[%0t] Reset released, starting simulation...\n", $time);
    end

    // simulation run
    initial begin
        // wait until reset deasserted
        @(negedge rst);

        // run for enough cycles to drain the pipeline
        // (N instructions + 4 pipeline stages)
        repeat (17) begin
            @(posedge clk);
            cycle = cycle + 1;

            // small delay to allow combinational logic to settle
            #1;

            pc_index = top_module_dut.pc_reg_dut.pc_out >> 2;
            current_instr = top_module_dut.instruction_mem_dut.instr_mem[pc_index];

            $display("----- Cycle %0d -----", cycle);
            $display("PC = 0x%016h | instr = 0x%08h", top_module_dut.pc_reg_dut.pc_out, current_instr);
            print_regfile();
        end

        $display("Simulation finished after %0d cycles.", cycle);
        $display("Dumping final data memory contents to 'data_mem_final.hex'...");
        $writememh("data_mem_final.hex", top_module_dut.data_mem_dut.mem);
        $finish;
    end

endmodule
