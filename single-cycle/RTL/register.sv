module register(
    input logic clk,
    input logic we,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] wd,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] regs [31:0];

    integer i;
    initial begin
        for(i = 0; i < 32; i++)
            regs[i] = 32'b0;
    end

    always_comb begin
        rd1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
        rd2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];
    end

    always_ff @(posedge clk) begin
        if(we && (rd != 5'd0))
            regs[rd] <= wd;
    end

endmodule
