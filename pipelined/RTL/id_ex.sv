module id_ex(
    input logic clk,
    input logic rst,
    input logic flush,
    input logic enable,

    input logic [31:0] rd1,
    input logic [31:0] rd2,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [31:0] imm,
    input logic [4:0] rd, //im realising now that my port/signal labelling is pretty terrible 

    input logic [1:0] ALUop,
    input logic ALUsrc,
    input logic Branch,
    input logic MemRead,
    input logic MemtoReg,
    input logic MemWrite,
    input logic RegWrite,       //this would be very confusing if not put with other control signals

    input logic [31:0] instruction,
    input logic [31:0] pc,

    output logic [31:0] rd1_out,
    output logic [31:0] rd2_out,
    output logic [4:0] rs1_out,
    output logic [4:0] rs2_out,
    output logic [31:0] imm_out,
    output logic [4:0] rd_out,

    output logic [1:0] ALUop_out,
    output logic ALUsrc_out,
    output logic Branch_out,
    output logic MemRead_out,
    output logic MemtoReg_out,
    output logic MemWrite_out,
    output logic RegWrite_out,

    output logic [31:0] instruction_out,
    output logic [31:0] pc_out
);

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            rd1_out <= 32'b0;
            rd2_out <= 32'b0;
            imm_out <= 32'b0;
            ALUop_out <= 2'b0;
            ALUsrc_out <= 1'b0;
            Branch_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            RegWrite_out <= 1'b0;
            instruction_out <= 32'b0; 
            pc_out <= 32'b0;
            rd_out <= 5'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
        end

        else if(flush) begin
            rd1_out <= 32'b0;
            rd2_out <= 32'b0;
            imm_out <= 32'b0;
            ALUop_out <= 2'b0;
            ALUsrc_out <= 1'b0;
            Branch_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            RegWrite_out <= 1'b0;
            instruction_out <= 32'b0; 
            pc_out <= 32'b0;
            rd_out <= 5'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
        end

        else if (enable) begin
            rd1_out <= rd1;
            rd2_out <= rd2;
            imm_out <= imm;
            ALUop_out <= ALUop;
            ALUsrc_out <= ALUsrc;
            Branch_out <= Branch;
            MemRead_out <= MemRead;
            MemtoReg_out <= MemtoReg;
            MemWrite_out <= MemWrite;
            RegWrite_out <= RegWrite;
            instruction_out <= instruction;
            pc_out <= pc;
            rd_out <= rd;
            rs1_out <= rs1;
            rs2_out <= rs2;
        end
    end
endmodule

