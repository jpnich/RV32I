module pc(
    input logic clk,
    input logic rst,
    input logic enable,
    input logic jump,
    input logic [31:0] new_pc,
    output logic [31:0] pc
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            pc <= 32'b0;
        else if (enable) begin
            if(jump)
            pc <= new_pc;
            else pc <= pc + 32'd4;
        end
    end

endmodule
