module forward_mux #(
    parameter int REG_WIDTH = 64
)
(
    input [REG_WIDTH - 1 : 0] reg_data_rs1,
    input [REG_WIDTH - 1 : 0] reg_data_rs2,
    input [REG_WIDTH - 1 : 0] ex_alu_res,
    input [REG_WIDTH - 1 : 0] reg_wb_data,
    input [1:0] forwardA,
    input [1:0] forwardB,

    output reg [REG_WIDTH - 1 : 0] forwarded_rs1,
    output reg [REG_WIDTH - 1 : 0] forwarded_rs2
);

    always @ (*) begin
        case(forwardA)
            2'b01: forwarded_rs1 = reg_wb_data;
            2'b10: forwarded_rs1 = ex_alu_res;
            default: forwarded_rs1 = reg_data_rs1;
        endcase
        case(forwardB)
            2'b01: forwarded_rs2 = reg_wb_data;
            2'b10: forwarded_rs2 = ex_alu_res;
            default: forwarded_rs2 = reg_data_rs2;
        endcase
    end
endmodule