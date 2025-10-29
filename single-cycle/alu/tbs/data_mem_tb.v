`timescale 1ns/1ps

module tb_data_mem;

    // Parameters
    localparam int REG_WIDTH = 64;
    localparam int ADDR_WIDTH = 10;
    localparam int MEM_DEPTH = 1 << ADDR_WIDTH;

    // DUT signals
    logic clk;
    logic rst;
    logic MemRead, MemWrite, MemSign;
    logic [1:0] MemWidth;
    logic [REG_WIDTH-1:0] wdata;
    logic [REG_WIDTH-1:0] full_addr;
    logic [REG_WIDTH-1:0] rdata;

    // Instantiate DUT
    data_mem #(
        .REG_WIDTH(REG_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemSign(MemSign),
        .MemWidth(MemWidth),
        .wdata(wdata),
        .full_addr(full_addr),
        .rdata(rdata)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for checking results
    task automatic check(input string test_name,
                         input [REG_WIDTH-1:0] expected,
                         input [REG_WIDTH-1:0] actual);
        if (expected === actual)
            $display("[PASS] %s | Expected: 0x%h, Got: 0x%h", test_name, expected, actual);
        else
            $display("[FAIL] %s | Expected: 0x%h, Got: 0x%h", test_name, expected, actual);
    endtask

    // Main test
    initial begin
        clk = 0;
        rst = 1;
        MemRead = 0;
        MemWrite = 0;
        MemSign = 0;
        MemWidth = 0;
        wdata = 0;
        full_addr = 0;

        // Reset and memory initialization
        #10;
        $display("\n[INFO] Loading memory from file...");
        $readmemh("data_mem_init.hex", dut.mem);
        rst = 0;

        // ====== TEST 1: Verify preload ======
        #10;
        MemRead = 1;
        MemWidth = 2'd0; // byte
        MemSign = 1'b1;  // unsigned
        full_addr = 64'h0;
        #1;
        check("Preload Byte @0x0", 64'h00, rdata);
        full_addr = 64'h1;
        #1;
        check("Preload Byte @0x1", 64'h1, rdata);
        MemRead = 0;

        // ====== TEST 2: Store doubleword and read back ======
        #10;
        full_addr = 64'h0000000000000008;
        wdata = 64'h1122334455667788;
        MemWidth = 2'd3; // sd
        MemWrite = 1;
        #10 MemWrite = 0;

        // Read back full doubleword
        #5;
        MemRead = 1;
        MemWidth = 2'd3;
        #1;
        check("Store+Load Doubleword", 64'h1122334455667788, rdata);
        MemRead = 0;

        // ====== TEST 3: Store word and read back (signed) ======
        #10;
        full_addr = 64'h0000000000000020;
        wdata = 64'hFFFF_FFFF_89ABCDEF; // only lower 32 bits written
        MemWidth = 2'd2; // sw
        MemWrite = 1;
        #10 MemWrite = 0;

        // Read as signed word
        #5;
        MemRead = 1;
        MemWidth = 2'd2;
        MemSign = 1'b0; // signed
        #1;
        check("Load Word Signed", {{32{1'b1}}, 32'h89ABCDEF}, rdata);

        // Read as unsigned word
        MemSign = 1'b1;
        #1;
        check("Load Word Unsigned", 64'h0000000089ABCDEF, rdata);
        MemRead = 0;

        // ====== TEST 4: Store and read halfword ======
        #10;
        full_addr = 64'h0000000000000040;
        wdata = 64'h000000000000CDEF;
        MemWidth = 2'd1; // sh
        MemWrite = 1;
        #10 MemWrite = 0;

        // Read as signed halfword
        #5;
        MemRead = 1;
        MemWidth = 2'd1;
        MemSign = 1'b0; // signed
        #1;
        check("Load Halfword Signed", {{48{1'b1}}, 16'hCDEF}, rdata);

        // Read as unsigned halfword
        MemSign = 1'b1;
        #1;
        check("Load Halfword Unsigned", 64'h000000000000CDEF, rdata);
        MemRead = 0;

        // ====== TEST 5: Store and read byte ======
        #10;
        full_addr = 64'h0000000000000060;
        wdata = 64'h00000000000000AA;
        MemWidth = 2'd0; // sb
        MemWrite = 1;
        #10 MemWrite = 0;

        // Read as signed byte
        #5;
        MemRead = 1;
        MemWidth = 2'd0;
        MemSign = 1'b0;
        #1;
        check("Load Byte Signed", {{56{1'b1}}, 8'hAA}, rdata);

        // Read as unsigned byte
        MemSign = 1'b1;
        #1;
        check("Load Byte Unsigned", 64'hAA, rdata);
        MemRead = 0;

        #20;
        $display("\n[INFO] All tests completed.");
        $finish;
    end

endmodule
