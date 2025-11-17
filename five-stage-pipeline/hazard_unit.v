module hazard_unit #(
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32
)
(
    input ID_EX_MemRead,
    input [$clog2(REG_COUNT) - 1 : 0] ID_EX_rd,
    input [$clog2(REG_COUNT) - 1 : 0] IF_ID_rs1,
    input [$clog2(REG_COUNT) - 1 : 0] IF_ID_rs2,

    output reg stall // stall should freeze if_id reg and pc, nop should be inserted in id_ex, remaining stages remain same
    // change input ports of if_id, pc, id_ex registers
);

    // load hazard detection and stall
    always @ (*) begin
        stall = 0; // default
        if(ID_EX_MemRead && (ID_EX_rd != 0) && (ID_EX_rd == IF_ID_rs1 || ID_EX_rd == IF_ID_rs2)) stall = 1'b1;
    end


endmodule