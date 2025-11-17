module hazard_unit #(
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32
)
(
    input ID_EX_MemRead,
    input [$clog2(REG_COUNT) - 1 : 0] ID_EX_rd,
    input [$clog2(REG_COUNT) - 1 : 0] IF_ID_rs1,
    input [$clog2(REG_COUNT) - 1 : 0] IF_ID_rs2,
    input branch_taken,
    input is_jal,
    input is_jalr,

    output reg stall, // stall should freeze if_id reg and pc, nop should be inserted in id_ex, remaining stages remain same
    // change input ports of if_id, pc, id_ex registers
    output reg flush // change input ports of if_id, pc, id_ex
);

    // load hazard detection and stall
    always @ (*) begin
        stall = 0; // default
        flush = 0; // default
        if(ID_EX_MemRead && (ID_EX_rd != 0) && (ID_EX_rd == IF_ID_rs1 || ID_EX_rd == IF_ID_rs2)) stall = 1'b1;
        if(branch_taken | is_jal | is_jalr) flush = 1'b1;
    end


endmodule