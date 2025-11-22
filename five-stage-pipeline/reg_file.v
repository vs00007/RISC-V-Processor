module reg_file #(
    parameter int REG_WIDTH = 64,
    parameter int REG_COUNT = 32
)
(
    input clk,
    input rst,

    // Write port
    input writeEnable,
    input [$clog2(REG_COUNT) - 1 : 0] waddr,
    input [REG_WIDTH - 1 : 0] wdata,

    // Read ports
    input [$clog2(REG_COUNT) - 1 : 0] raddr1,
    input [$clog2(REG_COUNT) - 1 : 0] raddr2,

    // Read outputs
    output reg [REG_WIDTH - 1 : 0] rdata1,
    output reg [REG_WIDTH - 1 : 0] rdata2
);

    logic [REG_WIDTH - 1 : 0] reg_array [REG_COUNT - 1 : 0];

    // Write operation
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < REG_COUNT; i++) begin
                reg_array[i] <= 0;
            end
        end 
        else if (writeEnable && (waddr != 0)) begin
            reg_array[waddr] <= wdata;
        end
    end

    assign rdata1 = (raddr1 == 0) ? 0 : ((writeEnable && waddr == raddr1) ? wdata : reg_array[raddr1]); // the second conditional is to remove the delay when the data is ready but the output is wrong because of the clock
    assign rdata2 = (raddr2 == 0) ? 0 : ((writeEnable && waddr == raddr2) ? wdata : reg_array[raddr2]); // the second conditional is to remove the delay when the data is ready but the output is wrong because of the clock

endmodule
