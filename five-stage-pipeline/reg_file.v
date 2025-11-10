module reg_file #(
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32
)
(
    input logic clk,
    input logic rst,

    // Write port
    input logic writeEnable,
    input logic [$clog2(REG_COUNT) - 1 : 0] waddr,
    input logic [REG_WIDTH - 1 : 0] wdata,

    // Read ports
    input logic [$clog2(REG_COUNT) - 1 : 0] raddr1,
    input logic [$clog2(REG_COUNT) - 1 : 0] raddr2,

    // Read outputs
    output logic [REG_WIDTH - 1 : 0] rdata1,
    output logic [REG_WIDTH - 1 : 0] rdata2
);

    logic [REG_WIDTH - 1 : 0] reg_array [REG_COUNT - 1 : 0];

    // Write operation
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < REG_COUNT; i++) begin
                reg_array[i] <= '0;
            end
        end 
        else if (writeEnable && (waddr != '0)) begin
            reg_array[waddr] <= wdata;
        end
    end

    assign rdata1 = (raddr1 == '0) ? '0 : reg_array[raddr1];
    assign rdata2 = (raddr2 == '0) ? '0 : reg_array[raddr2];

endmodule
