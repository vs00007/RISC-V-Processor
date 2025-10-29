`timescale 1ns/1ps
module imm_gen_tb();

    reg  [31:0] instruction;
    wire [63:0] imm;
    reg clk = 0;

    // clock: 10ns period
    initial begin
        forever #5 clk = ~clk;
    end

    // instantiate DUT (uses default parameters REG_WIDTH=64, INSTRUCTION_WIDTH=32)
    imm_gen uut (
        .clk(clk),
        .instruction(instruction),
        .imm(imm)
    );

    integer passed = 0;
    integer failed = 0;

    // set instruction (immediate in bits [31:20]) and wait for next posedge to sample imm
    task check;
        input [31:0] instr;
        input [63:0] expected;
        begin
            instruction = instr;
            @(posedge clk);
            #1; // stable after clock edge
            if (imm !== expected) begin
                $display("FAIL: instr=0x%08h, imm=0x%016h, expected=0x%016h", instr, imm, expected);
                failed = failed + 1;
            end else begin
                $display("PASS: instr=0x%08h -> imm=0x%016h", instr, imm);
                passed = passed + 1;
            end
        end
    endtask

    initial begin
        $display("Starting imm_gen testbench");

        // immediate placed in bits [31:20] (imm << 20)
        // Test: zero immediate
        check(32'h0000_0000, 64'h0000_0000_0000_0000);

        // Test: all ones in 12-bit immediate (12'hFFF) => sign-extended -1
        check(32'hFFF0_0000, 64'hFFFF_FFFF_FFFF_FFFF);

        // Test: maximum positive 12-bit immediate (12'h7FF)
        check(32'h7FF0_0000, 64'h0000_0000_0000_07FF);

        // Test: most negative 12-bit immediate (12'h800) => sign-extended -2048
        check(32'h8000_0000, 64'hFFFF_FFFF_FFFF_F800);

        // Random pattern: immediate bits = 12'h123
        check(32'h1230_0000, 64'h0000_0000_0000_0123);

        // Another pattern: mixed bits
        check(32'hA55A_0000, 64'hFFFFFFFFFFFFFA55); // 12'hA55 -> sign bit=1 => negative

        $display("imm_gen results: passed=%0d failed=%0d", passed, failed);
        if (failed == 0) $display("ALL TESTS PASSED");
        else $display("SOME TESTS FAILED");
        #1 $finish;
    end

endmodule