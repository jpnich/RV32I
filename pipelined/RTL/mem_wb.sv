module mem_wb(
    input logic clk,
    input logic rst,
    input logic enable,

    input logic [31:0] rdata,
    input logic [31:0] ALUresult,
    input logic MemtoReg,
    input logic MemRead,
    input logic [4:0] rd,
    input logic RegWrite,

    output logic [31:0] rdata_out,
    output logic [31:0] ALUresult_out,
    output logic MemtoReg_out,
    output logic Memread_out,
    output logic [4:0] rd_out,
    output logic RegWrite_out
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rdata_out <= 32'b0;
            ALUresult_out <= 32'b0;
            MemtoReg_out <= 1'b0;
            Memread_out <= 1'b0;
            rd_out <= 5'b0;
            RegWrite_out <= 1'b0;
        end

        else if (enable) begin
            rdata_out <= rdata;
            ALUresult_out <= ALUresult;
            MemtoReg_out <= MemtoReg;
            Memread_out <= MemRead;
            rd_out <= rd;
            RegWrite_out <= RegWrite;
        end
    end
endmodule
