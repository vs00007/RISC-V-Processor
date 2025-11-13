module pc_next_mux #(
    parameter int PC_WIDTH = 64
)
(
    input branch_taken,
    input jump,
    input [PC_WIDTH - 1 : 0] pc_plus_4,
    input [PC_WIDTH - 1 : 0] branch_addr,
    input [PC_WIDTH - 1 : 0] pc_jump_addr,

    output reg [PC_WIDTH - 1 : 0] pc_next
);

    // always @ (*) begin
    //     if(branch_taken) begin
    //         pc_next = branch_addr;
    //     end
    //     else begin
    //         pc_next = pc_plus_4;
    //     end
    // end
    always @ (*) begin
        if (jump) begin
            pc_next = pc_jump_addr;
        end
        else if(branch_taken) begin
            pc_next = branch_addr;
        end
        else begin
            pc_next = pc_plus_4;
        end
    end

endmodule