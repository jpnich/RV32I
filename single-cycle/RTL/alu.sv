module alu(
    input logic [31:0] a,
    input logic [31:0] b,
    input alu_ctrl_code alu_op,
    output logic [31:0] result,
    output logic        zero
);

    always_comb begin
        unique case(alu_op)
            ADD:    result = a + b;    
            SUB:    result = a - b; 
            AND:    result = a & b;  
            OR:     result = a | b;    
            XOR:    result = a ^ b;    
            SLT:    result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLTU:   result = (a < b) ? 32'd1 : 32'd0;
            SLL:    result = a << b[4:0];    
            SRL:    result = a >> b[4:0];
            SRA:    result = $signed(a) >>> b[4:0];
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule

