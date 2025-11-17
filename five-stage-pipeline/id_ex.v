// the second register between ID and EX stages
module id_ex_reg#(
    parameter int PC_WIDTH = 64,
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32,
    parameter int EX_Ctrl_bits = 5,
    parameter int M_Ctrl_bits = 5,
    parameter int WB_Ctrl_bits = 5
)
(
    input clk,
    input rst,
    input [WB_Ctrl_bits-1:0] WB_Ctrl_in,
    input [M_Ctrl_bits-1:0] M_Ctrl_in,
    input [EX_Ctrl_bits-1:0] EX_Ctrl_in,
    input [PC_WIDTH - 1 : 0] PC_in,
    input [REG_WIDTH - 1 : 0] rs1_data_in,
    input [REG_WIDTH - 1 : 0] rs2_data_in,
    input [REG_WIDTH - 1 : 0] imm_in,
    input [2:0] funct3_in,
    input [$clog2(REG_COUNT) - 1 : 0] rd_addr_in,
    input [$clog2(REG_COUNT) - 1 : 0] rs1_addr_in,
    input [$clog2(REG_COUNT) - 1 : 0] rs2_addr_in,
    input stall,

    output reg [PC_WIDTH - 1 : 0] PC_out,
    output reg [REG_WIDTH - 1 : 0] rs1_data_out,
    output reg [REG_WIDTH - 1 : 0] rs2_data_out,
    output reg [REG_WIDTH - 1 : 0] imm_out,
    output reg [2:0] funct3_out,
    output reg [$clog2(REG_COUNT) - 1 : 0] rd_addr_out,
    output reg [WB_Ctrl_bits-1:0] WB_Ctrl_out,
    output reg [M_Ctrl_bits-1:0] M_Ctrl_out,
    output reg [EX_Ctrl_bits-1:0] EX_Ctrl_out,
    output reg [$clog2(REG_COUNT) - 1 : 0] rs1_addr_out,
    output reg [$clog2(REG_COUNT) - 1 : 0] rs2_addr_out
);
    always @ (posedge clk, posedge rst) begin
        if(rst | stall) begin // reset or insert nop when stall
            PC_out <= 0;
            rs1_data_out <= 0;
            rs2_data_out <= 0;
            imm_out <= 0;
            funct3_out <= 0;
            rd_addr_out <= 0;
            WB_Ctrl_out <= 0;
            M_Ctrl_out <= 0;
            EX_Ctrl_out <= 0;
            rs1_addr_out <= 0;
            rs2_addr_out <= 0;
        end
        else begin
            PC_out <= PC_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            imm_out <= imm_in;
            funct3_out <= funct3_in;
            rd_addr_out <= rd_addr_in;
            WB_Ctrl_out <= WB_Ctrl_in;
            M_Ctrl_out <= M_Ctrl_in;
            EX_Ctrl_out <= EX_Ctrl_in;
            rs1_addr_out <= rs1_addr_in;
            rs2_addr_out <= rs2_addr_in;
        end
    end
endmodule