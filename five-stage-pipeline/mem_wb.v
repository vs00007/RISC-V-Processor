// the fourth register between MEM and WB stages
module mem_wb_reg#(
    parameter int REG_WIDTH = 64,
    parameter int WB_Ctrl_bits = 5
)
(
    input clk,
    input [WB_Ctrl_bits - 1 : 0] WB_Ctrl_in,
    input [REG_WIDTH - 1 : 0] mem_read_data_in,
    input [REG_WIDTH - 1 : 0] ALU_res_in,
    input [$clog2(REG_WIDTH) - 1 : 0] rd_addr_in,

    output reg [WB_Ctrl_bits - 1 : 0] WB_Ctrl_out,
    output reg [REG_WIDTH - 1 : 0] mem_read_data_out,
    output reg [REG_WIDTH - 1 : 0] ALU_res_out,
    output reg [$clog2(REG_WIDTH) - 1 : 0] rd_addr_out
);
    always @ (posedge clk, posedge rst) begin
        if(rst) begin
            WB_Ctrl_out <= 0;
            mem_read_data_out <= 0;
            ALU_res_out <= 0;
            rd_addr_out <= 0;
        end
        else begin
            WB_Ctrl_out <= WB_Ctrl_in;
            mem_read_data_out <= mem_read_data_in;
            ALU_res_out <= ALU_res_in;
            rd_addr_out <= rd_addr_in;
        end
    end
endmodule