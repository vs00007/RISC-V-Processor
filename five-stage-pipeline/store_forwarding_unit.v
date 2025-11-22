module store_forwarding_unit#(
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32
)
// if the rd of writeback stage is the same as rs2 for id/ex or ex/mem reg (2 cycles), then we forward the new rd value to write it into the memory 
(
    // inputs
    input [$clog2(REG_COUNT) - 1 : 0] MEM_WB_rd_addr,
    input [$clog2(REG_COUNT) - 1 : 0] EX_MEM_rd_addr,
    input [$clog2(REG_COUNT) - 1 : 0] ID_EX_rs2_addr,
    // output
    output reg [1:0] flag
); 
// if flag is 10 forwarded from the mem_wb register, 
// if flag is 01 forwarded from the ex_mem register,
// else, no change, stay as is
// no regwrite input because the output of this unit only affects only the data memory write data

always @(*) begin
    flag = 0;
    if((EX_MEM_rd_addr != 0) &&(EX_MEM_rd_addr == ID_EX_rs2_addr)) flag = 2'b01;
    else if((MEM_WB_rd_addr != 0) && MEM_WB_rd_addr == ID_EX_rs2_addr) flag = 2'b10;
end

endmodule