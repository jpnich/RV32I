module imem(
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [1023:0];

    initial begin
           for(int i = 0; i < 1024; i++)
            memory[i] = 32'h00000013; 
        $readmemh("program.hex", memory);
    end

    always_comb begin
        instruction = memory[address[11:2]];
    end

endmodule
