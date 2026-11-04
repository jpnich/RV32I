module dmem(
    input logic clk,
    input logic [31:0] address,
    input logic [31:0] wdata,
    input logic wmem,
    input logic rmem,
    output logic [31:0] rdata
);

    logic [31:0] mem [1023:0];
    logic [9:0] word_index;             // 10 bits to cover 1024 locations
    assign word_index = address[11:2];

    integer i;
    initial begin
        for(i = 0; i < 1024; i++)
        mem[i] = 32'b0;
    end

    always_comb begin
        if(rmem)
            rdata = mem[word_index];
        else
            rdata ='0;
    end

    always_ff @(posedge clk) begin
        if (wmem)
            mem[word_index] <= wdata;
    end
endmodule
