module if_id(
    input logic clk,
    input logic rst,
    input logic enable, // needed for stall
    input logic flush,

    input logic [31:0] instruction,
    input logic [31:0] pc,
    output logic [31:0] instruction_out,
    output logic [31:0] pc_out
);

    always_ff @(posedge clk or posedge rst) begin
        if(rst)  begin
            instruction_out <= 32'b0;
            pc_out <= 32'b0;
        end

        else if(flush)  begin
            instruction_out <= 32'b0;
            pc_out <= 32'b0;
        end

        else if (enable) begin
            instruction_out <= instruction;
            pc_out <= pc;
        end
    end
endmodule

