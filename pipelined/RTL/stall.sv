module stall(
    input logic idex_MemRead,
    input logic [4:0] idex_rd,
    input logic [4:0] ifid_rs1,
    input logic [4:0] ifid_rs2,

    output logic stall
);

    always_comb begin
        stall = 1'b0;

        if(idex_MemRead && (idex_rd != 5'd0) && ((idex_rd == ifid_rs1) || (idex_rd ==ifid_rs2)))
            stall = 1'b1;
    end
endmodule
