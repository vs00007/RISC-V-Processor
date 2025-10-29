module data_mem #(
    parameter int REG_WIDTH = 64,
    parameter int ADDR_WIDTH = 10, // 2^10 = 1024 locations (each 8 bytes)
    parameter int MEM_DEPTH  = 1 << ADDR_WIDTH
)(
    input clk,
    input MemRead,
    input MemWrite,
    input MemSign,
    input [1:0] MemWidth,
    input [REG_WIDTH-1:0] wdata,
    input [REG_WIDTH-1:0] full_addr,
    output reg [REG_WIDTH-1:0] rdata
);

    logic [7:0] mem [0:MEM_DEPTH-1];
    wire [ADDR_WIDTH-1:0] addr = full_addr[ADDR_WIDTH-1:0]; // effective address for simulation
    logic [15:0] half;
    logic [31:0] word;
    // synchronous writes
    always @(posedge clk) begin
            if (MemWrite) begin
        case (MemWidth)
            2'd0: mem[addr] <= wdata[7:0]; // sb
            2'd1: begin // sh
                mem[addr]     <= wdata[7:0];
                mem[addr+1]   <= wdata[15:8];
            end
            2'd2: begin // sw
                mem[addr]     <= wdata[7:0];
                mem[addr+1]   <= wdata[15:8];
                mem[addr+2]   <= wdata[23:16];
                mem[addr+3]   <= wdata[31:24];
            end
            2'd3: begin // sd
                mem[addr]     <= wdata[7:0];
                mem[addr+1]   <= wdata[15:8];
                mem[addr+2]   <= wdata[23:16];
                mem[addr+3]   <= wdata[31:24];
                mem[addr+4]   <= wdata[39:32];
                mem[addr+5]   <= wdata[47:40];
                mem[addr+6]   <= wdata[55:48];
                mem[addr+7]   <= wdata[63:56];
            end
        endcase
    end
    end

    // asynchronous read
    always @ (*) begin
        half = 0;
        word = 0;
        rdata = {(REG_WIDTH){1'b0}};
        if (MemRead) begin
            case(MemWidth)
                2'd0: // lb and lbu
                    rdata = ~MemSign ? {{(REG_WIDTH - 8){mem[addr][7]}}, mem[addr]} : {{(REG_WIDTH - 8){1'b0}}, mem[addr]};
                2'd1: begin // lh and lhu
                    half = {mem[addr+1], mem[addr]};
                    rdata = ~MemSign ? {{(REG_WIDTH - 16){half[15]}}, half} : {{(REG_WIDTH - 16){1'b0}}, half};
                end
                2'd2: begin // lw and lwu
                    word = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
                    rdata = ~MemSign ? {{(REG_WIDTH - 32){word[31]}}, word} : {{(REG_WIDTH - 32){1'b0}}, word};
                end
                2'd3: begin // ld
                    rdata = {mem[addr+7], mem[addr+6], mem[addr+5], mem[addr+4], mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
                end
            endcase
        end
    end

endmodule
