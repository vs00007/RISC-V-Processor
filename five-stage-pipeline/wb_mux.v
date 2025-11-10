module wb_mux#(
    parameter int REG_WIDTH = 64
)
(
    input [REG_WIDTH - 1 : 0] ALU_res,
    input [REG_WIDTH - 1 : 0] mem_read_data,
    input MemtoReg,

    output reg [REG_WIDTH - 1 : 0] reg_wb_data
);

    always @ (*) begin
        if(MemtoReg) begin
            reg_wb_data = mem_read_data;
        end
        else begin
            reg_wb_data = ALU_res;
        end
    end

endmodule