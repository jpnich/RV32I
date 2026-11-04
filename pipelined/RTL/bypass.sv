module bypass(
    input logic [4:0] idex_rs1,
    input logic [4:0] idex_rs2,
    input logic [4:0] exmem_rd,
    input logic exmem_RegWrite,
    input logic [4:0] memwb_rd,
    input logic memwb_RegWrite,

    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

    always_comb begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        //execute hazards - give priority over mem hazards since newest value
        if(exmem_RegWrite && (exmem_rd != 5'd0) && (exmem_rd == idex_rs1))
            ForwardA = 2'b10;
        else if(memwb_RegWrite && (memwb_rd != 5'd0) && (memwb_rd == idex_rs1))
            ForwardA = 2'b01;

        if(exmem_RegWrite && (exmem_rd != 5'd0) && (exmem_rd == idex_rs2))
            ForwardB = 2'b10;    
        else if(memwb_RegWrite && (memwb_rd != 5'd0) && (memwb_rd == idex_rs2))
            ForwardB = 2'b01;
        
    end
endmodule
