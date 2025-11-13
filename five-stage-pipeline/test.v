module tb;
    reg [31:0] mem [0:5];
    initial begin
        $readmemh("instructions.txt", mem);
        $display("mem[0] = %h", mem[1]);
        $finish;
    end
endmodule
