module ex_mem(
    input logic clk,
    input logic rst,
    input logic enable,
    input logic flush,

    input logic [31:0] ALUresult,
    input logic zero,
    input logic [31:0] rd2,
    input logic Branch,
    input logic MemRead,
    input logic MemtoReg,
    input logic MemWrite,
    input logic RegWrite,
    input logic [31:0] pc_branch,
    input logic [4:0] rd,

    output logic [31:0] ALUresult_out,
    output logic zero_out,
    output logic [31:0] rd2_out,
    output logic Branch_out,
    output logic MemRead_out,
    output logic MemtoReg_out,
    output logic MemWrite_out,
    output logic RegWrite_out,
    output logic [31:0] pc_branch_out,
    output logic [4:0] rd_out
);

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            ALUresult_out <= 32'b0;
            zero_out <= 1'b0;
            rd2_out <= 32'b0;
            Branch_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            RegWrite_out <= 1'b0;
            pc_branch_out <= 32'b0;
            rd_out <= 5'b0;
        end

        else if(flush) begin
            ALUresult_out <= 32'b0;
            zero_out <= 1'b0;
            rd2_out <= 32'b0;
            Branch_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            RegWrite_out <= 1'b0;
            pc_branch_out <= 32'b0;
            rd_out <= 5'b0;
        end

        else if (enable) begin
            ALUresult_out <= ALUresult;
            zero_out <= zero;
            rd2_out <= rd2;
            Branch_out <= Branch;
            MemRead_out <= MemRead;
            MemtoReg_out <= MemtoReg;
            MemWrite_out <= MemWrite;
            RegWrite_out <= RegWrite;
            pc_branch_out <= pc_branch;
            rd_out <= rd;
        end
    end
endmodule
        
