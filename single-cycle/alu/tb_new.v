module tb1();

    logic clk, rst;

    top_module top_module_dut(
        .clk(clk),
        .rst(rst)
    );

    // VCD Dump
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb1);
    end

    // Clock Generation
    always #5 clk = ~clk;

    // Task to print register file
    task print_regfile();
        integer i;
        begin
            $display("\n================= Register File =================");
            for (i = 0; i < 32; i = i + 1)
                $display("x%0d : 0x%016h", i, top_module_dut.reg_file_dut.reg_array[i]);
            $display("=================================================\n");
        end
    endtask

    // Initialization
    initial begin
        clk = 0;
        rst = 1;

        // Load instruction and data memory
        $display("Loading instruction and data memory...");
        $readmemh("instructions.txt", top_module_dut.instruction_mem_dut.instr_mem);
        $readmemh("data_mem_init.hex", top_module_dut.data_mem_dut.mem);

        #20 rst = 0;  // keep reset for 2 clock cycles
        $display("Reset deasserted. Starting simulation.\n");

        // Run for a fixed number of cycles
        repeat (10) begin  // Adjust depending on your program length
            @(posedge clk);
            $display("PC = 0x%016h, Instruction = 0x%08h",
                     top_module_dut.pc_reg_dut.pc_out,
                     top_module_dut.instruction_mem_dut.instruction);
            print_regfile();
        end

        // Dump final memory contents
        $display("Simulation finished. Writing final memory contents...");
        $writememh("data_mem_final.hex", top_module_dut.data_mem_dut.mem);

        $finish;
    end

endmodule
