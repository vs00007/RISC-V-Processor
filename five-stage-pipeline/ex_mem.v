// the third register between EX and MEM stages
module ex_mem_reg#(
    parameter int PC_WIDTH = 64,
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32,
    parameter int M_Ctrl_bits = 5,
    parameter int WB_Ctrl_bits = 5
)
(
    input clk,
    input rst,
    input [WB_Ctrl_bits - 1 : 0] WB_Ctrl_in,
    input [M_Ctrl_bits - 1: 0] M_Ctrl_in,
    input [PC_WIDTH - 1 : 0] PC_in,
    input [REG_WIDTH - 1 : 0] ALU_res_in,
    input [REG_WIDTH - 1 : 0] rs2_data_in,
    input [$clog2(REG_COUNT) - 1 : 0] rd_addr_in,

    output reg [WB_Ctrl_bits - 1 : 0] WB_Ctrl_out,
    output reg [M_Ctrl_bits - 1 : 0] M_Ctrl_out,
    output reg [PC_WIDTH - 1 : 0] PC_out,
    output reg [REG_WIDTH - 1 : 0] ALU_res_out,
    output reg [REG_WIDTH - 1 : 0] rs2_data_out,
    output reg [$clog2(REG_COUNT) - 1 : 0] rd_addr_out
);
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            WB_Ctrl_out <= 0;
            M_Ctrl_out <= 0;
            PC_out <= 0;
            ALU_res_out <= 0;
            rs2_data_out <= 0;
            rd_addr_out <= 0;
        end
        else begin
            WB_Ctrl_out <= WB_Ctrl_in;
            M_Ctrl_out <= M_Ctrl_in;
            PC_out <= PC_in;
            ALU_res_out <= ALU_res_in;
            rs2_data_out <= rs2_data_in;
            rd_addr_out <= rd_addr_in;
        end
    end
endmodule