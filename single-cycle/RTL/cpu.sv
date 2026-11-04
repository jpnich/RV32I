typedef enum logic [3:0] {
    ADD    = 4'b0000,
    SUB    = 4'b0001,
    AND    = 4'b0010,
    OR     = 4'b0011,
    XOR    = 4'b0100,
    SLT    = 4'b0101,
    SLTU   = 4'b0110,
    SLL    = 4'b0111,
    SRL    = 4'b1000,
    SRA    = 4'b1001
} alu_ctrl_code;

module cpu(
    input logic clk,
    input logic rst,
    input logic enable,

    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    logic [31:0] pc;
    logic [31:0] pc_4;
    logic [31:0] pc_branch;
    logic [31:0] pc_next;

    logic [31:0] instruction;

    logic [31:0] rd1;
    logic [31:0] rd2;
    logic [31:0] rw;

    logic [31:0] immediate;
    logic [31:0] alu_b;
    logic [31:0] alu_result;
    logic zero;

    logic [31:0] rdata;

    logic Branch;
    logic MemRead;
    logic MemtoReg;
    logic [1:0] ALUop;
    logic MemWrite;
    logic ALUsrc;
    logic RegWrite;

    alu_ctrl_code alu_operation;

    logic branch_taken;

    pc pc_inst(
        .clk(clk),
        .rst(rst),
        .jump(branch_taken),
        .new_pc(pc_next),
        .pc(pc),
        .enable(enable)
    );

    assign pc_4 = pc +32'd4;

    imem imem_inst(
        .address(pc),
        .instruction(instruction)
    );

    assign instruction_out = instruction;
    assign pc_out = pc;

    control control_inst(
        .op(instruction[6:0]),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUop(ALUop),
        .MemWrite(MemWrite),
        .ALUsrc(ALUsrc),
        .RegWrite(RegWrite)
    );

    register register_inst(
        .clk(clk),
        .we(RegWrite && enable),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .wd(rw),
        .rd1(rd1),
        .rd2(rd2)
    );

    immgen immgen_inst(
        .instr(instruction),
        .imm_out(immediate)
    );

    // ALU MUX
    always_comb begin
        if(ALUsrc)
            alu_b = immediate;
        else
            alu_b = rd2;
    end

    alu_ctrl alu_ctrl_inst(
        .ALUsel(ALUop),
        .funct7(instruction[30]),
        .funct3(instruction[14:12]),
        .alu_op(alu_operation)
    );

    alu alu_inst(
        .a(rd1),
        .b(alu_b),
        .alu_op(alu_operation),
        .result(alu_result),
        .zero (zero)
    );

    dmem dmem_inst(
        .clk(clk),
        .address(alu_result),
        .wdata(rd2),
        .wmem(MemWrite && enable),
        .rmem(MemRead),
        .rdata(rdata)
    );
    
    //WB MUX
    always_comb begin
        if(MemtoReg)
            rw = rdata;
        else
            rw = alu_result;
    end

    // IMM ADDER
    assign pc_branch = pc + immediate;

    //BRANCH AND 
    assign branch_taken = Branch & zero;

    //PC MUX
    always_comb begin
        if(branch_taken)
            pc_next = pc_branch;
        else
            pc_next = pc_4;
    end
endmodule    

