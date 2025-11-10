module instruction_mem #(
    parameter int PC_WIDTH = 64,
    parameter ADDR_WIDTH = 10
)
(   
    input clk,
    input [PC_WIDTH - 1 : 0] pc,
    output reg [31 : 0] instruction
);
    logic [31 : 0] instr_mem [0 : (1<<ADDR_WIDTH) - 1];

    // asynchronous read
    // should make this synchronous !! Think about this
    // always @ (posedge clk) begin
    always @ (*) begin
        instruction = instr_mem[pc[ADDR_WIDTH + 1: 2]];
    end
endmodule