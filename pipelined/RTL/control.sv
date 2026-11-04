module control(
    input logic [6:0] op,
    output logic Branch,
    output logic MemRead,
    output logic MemtoReg,
    output logic [1:0] ALUop,
    output logic MemWrite,
    output logic ALUsrc,
    output logic RegWrite
);

    localparam logic [6:0] OP_R_TYPE = 7'b0110011;
    localparam logic [6:0] OP_LOAD   = 7'b0000011;
    localparam logic [6:0] OP_S_TYPE  = 7'b0100011;
    localparam logic [6:0] OP_B_TYPE = 7'b1100011;
    localparam logic [6:0] OP_I_TYPE = 7'b0010011;

    always_comb begin
        Branch = 1'b0;
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        ALUop = 2'b00;
        MemWrite = 1'b0;
        ALUsrc = 1'b0;
        RegWrite = 1'b0;

        case(op)

            OP_R_TYPE: begin
                RegWrite = 1'b1;
                ALUsrc   = 1'b0;
                ALUop    = 2'b10;
            end

             OP_LOAD: begin
                RegWrite = 1'b1;
                ALUsrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                ALUop    = 2'b00;
            end

            OP_S_TYPE: begin
                ALUsrc   = 1'b1;
                MemWrite = 1'b1;
                ALUop    = 2'b00;
            end

            OP_B_TYPE: begin
                Branch   = 1'b1;
                ALUsrc   = 1'b0;
                ALUop    = 2'b01;
            end

            OP_I_TYPE: begin
                RegWrite = 1'b1;
                ALUsrc   = 1'b1;
                ALUop    = 2'b11;
            end

            default: begin
                Branch   = 1'b0;
                MemRead  = 1'b0;
                MemtoReg = 1'b0;
                ALUop    = 2'b00;
                MemWrite = 1'b0;
                ALUsrc   = 1'b0;
                RegWrite = 1'b0;
            end

        endcase
    end

endmodule
