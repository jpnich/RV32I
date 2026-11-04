module register(                //not a fan of these port names after pipelining
    input logic clk,
    input logic we,             //control signal needs sending through pipeline
    input logic [4:0] rs1,      
    input logic [4:0] rs2,
    input logic [4:0] rd,       // rd = register destination
    input logic [31:0] wd,      //writeback
    output logic [31:0] rd1,    // rd = register data
    output logic [31:0] rd2     
);

    logic [31:0] regs [31:0];

    integer i;
    initial begin
        for(i = 0; i < 32; i++)
            regs[i] = 32'b0;
    end

    always_comb begin
        rd1 = (rs1 == 5'd0) ? 32'b0 : (we && rd == rs1) ? wd : regs[rs1];   //need to account new write
        rd2 = (rs2 == 5'd0) ? 32'b0 : (we && rd == rs2) ? wd : regs[rs2];
    end

    always_ff @(posedge clk) begin
        if(we && (rd != 5'd0))
            regs[rd] <= wd;
    end

endmodule
