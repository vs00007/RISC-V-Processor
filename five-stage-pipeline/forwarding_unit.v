module forwarding_unit(
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    input [4:0] EX_MEM_rd,
    input [4:0] MEM_WB_rd,
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

    always @(*) begin
        forwardA = 0;
        forwardB = 0;

        // EX hazard
        if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)) 
        begin
            forwardA = 2'b10;
        end
        if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)) begin
            forwardB = 2'b10;
        end

        // MEM hazard
        if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && 
            !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)) && 
            (MEM_WB_rd == ID_EX_rs1)) begin
            forwardA = 2'b01;
        end
        if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && 
            !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)) && 
            (MEM_WB_rd == ID_EX_rs2)) begin
            forwardB = 2'b01;
        end
    end
endmodule