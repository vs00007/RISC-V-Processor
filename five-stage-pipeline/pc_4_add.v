module pc_4_add #(
    parameter int PC_WIDTH = 64
)
(
    input [PC_WIDTH - 1 : 0] pc_in,
    output reg [PC_WIDTH - 1 : 0] pc_out
);
    assign pc_out = pc_in + 4;
endmodule