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

    // pipeline register output wires
    logic [31:0] ifid_instruction;
    logic [31:0] ifid_pc;

    logic [31:0] idex_rd1;
    logic [31:0] idex_rd2;
    logic [31:0] idex_imm;
    logic [4:0] idex_alu;
    alu_ctrl_code idex_alu_op;
    logic [1:0] idex_ALUop;
    logic idex_ALUsrc;
    logic idex_Branch;
    logic idex_MemRead;
    logic idex_MemtoReg;
    logic idex_MemWrite;
    logic [4:0] idex_rd;                  //destination for writeback
    logic idex_RegWrite;
    logic [31:0] idex_instruction;
    logic [31:0] idex_pc;
    logic [4:0] idex_rs1;
    logic [4:0] idex_rs2;

    logic [31:0] exmem_ALUresult;
    logic exmem_zero;
    logic [31:0] exmem_rd2;
    logic exmem_Branch;
    logic exmem_MemRead;
    logic exmem_MemtoReg;
    logic exmem_MemWrite;
    logic [31:0] exmem_pc_branch;
    logic exmem_RegWrite;
    logic [4:0] exmem_rd;

    logic [31:0] memwb_rdata;
    logic [31:0] memwb_ALUresult;
    logic memwb_MemtoReg;
    logic memwb_Memread;    
    logic memwb_RegWrite;
    logic [4:0] memwb_rd;

    logic [1:0] ForwardA;
    logic [1:0] ForwardB;
    logic [31:0] FdA;
    logic [31:0] FdB;

    logic stall;
    logic pc_enable;

    logic b_type;       // took a while to add in other b-type instructions
    
    pc pc_inst(
        .clk(clk),
        .rst(rst),
        .jump(branch_taken),
        .new_pc(pc_next),
        .pc(pc),
        .enable(enable && (!stall || branch_taken))
    );

    assign pc_4 = pc +32'd4;

    imem imem_inst(
        .address(pc),
        .instruction(instruction)
    );

    assign instruction_out = instruction;
    assign pc_out = pc;

    if_id if_id_inst(
        .clk(clk),
        .rst(rst),
        .enable(enable && !stall),
        .flush(branch_taken),
        .instruction(instruction),
        .pc(pc),
        .instruction_out(ifid_instruction),
        .pc_out(ifid_pc)
    );

    control control_inst(
        .op(ifid_instruction[6:0]),
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
        .we(memwb_RegWrite && enable),
        .rs1(ifid_instruction[19:15]),
        .rs2(ifid_instruction[24:20]),
        .rd(memwb_rd),                      //destination set after instruction results gained otherwise youre setting the destination register when you dont have the opperands
        .wd(rw),
        .rd1(rd1),
        .rd2(rd2)
    );

    immgen immgen_inst(
        .instr(ifid_instruction),
        .imm_out(immediate)
    );

    id_ex id_ex_inst(
        .clk(clk),
        .rst(rst),
        .flush(stall || branch_taken),
        .enable(enable && !stall),
        .rd1(rd1),
        .rd2(rd2),
        .rs1(ifid_instruction[19:15]),
        .rs2(ifid_instruction[24:20]),
        .imm(immediate),
        .ALUop(ALUop),
        .ALUsrc(ALUsrc),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .rd(ifid_instruction[11:7]),
        .instruction(ifid_instruction),
        .pc(ifid_pc),
        .rd1_out(idex_rd1),
        .rd2_out(idex_rd2),
        .imm_out(idex_imm),
        .ALUop_out(idex_ALUop),
        .ALUsrc_out(idex_ALUsrc),
        .Branch_out(idex_Branch),
        .MemRead_out(idex_MemRead),
        .MemtoReg_out(idex_MemtoReg),
        .MemWrite_out(idex_MemWrite),
        .RegWrite_out(idex_RegWrite),
        .rd_out(idex_rd),
        .instruction_out(idex_instruction),
        .pc_out(idex_pc),
        .rs1_out(idex_rs1),
        .rs2_out(idex_rs2)
    );

    // ALU MUX - needs to account for forwarding bypass now
    always_comb begin
        case(ForwardA)
            2'b00: FdA = idex_rd1;
            2'b10: FdA = exmem_ALUresult;
            2'b01: FdA = rw;
            default: FdA = idex_rd1;
        endcase
    end

    always_comb begin
        case(ForwardB)
            2'b00: FdB = idex_rd2;
            2'b10: FdB = exmem_ALUresult;
            2'b01: FdB = rw;
            default: FdB = idex_rd2;
        endcase
    end
    
    always_comb begin
        if(idex_ALUsrc)
            alu_b = idex_imm;
        else
            alu_b = FdB;
    end

    alu_ctrl alu_ctrl_inst(
        .ALUsel(idex_ALUop),
        .funct7(idex_instruction[30]),
        .funct3(idex_instruction[14:12]),
        .alu_op(alu_operation)
    );

    alu alu_inst(
        .a(FdA),
        .b(alu_b),
        .alu_op(alu_operation),
        .result(alu_result),
        .zero (zero)
    );

    always_comb begin
        case(idex_instruction[14:12])
            3'b000: b_type = zero;              // BEQ
            3'b001: b_type = !zero;             // BNE
            3'b100: b_type = !zero;             // BLT
            3'b101: b_type = zero;              // BGE
            3'b110: b_type = !zero;             //BLTU
            3'b111: b_type = zero;              // BGEU
            default: b_type = 1'b0;
        endcase
    end


    ex_mem ex_mem_inst(
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .flush(branch_taken),
        .ALUresult(alu_result),
        .zero(b_type),
        .rd2(FdB),
        .Branch(idex_Branch),
        .MemRead(idex_MemRead),
        .MemtoReg(idex_MemtoReg),
        .MemWrite(idex_MemWrite),
        .RegWrite(idex_RegWrite),
        .rd(idex_rd),
        .pc_branch(pc_branch),
        .ALUresult_out(exmem_ALUresult),
        .zero_out(exmem_zero),
        .rd2_out(exmem_rd2),
        .Branch_out(exmem_Branch),
        .MemRead_out(exmem_MemRead),
        .MemtoReg_out(exmem_MemtoReg),
        .MemWrite_out(exmem_MemWrite),
        .RegWrite_out(exmem_RegWrite),
        .rd_out(exmem_rd),
        .pc_branch_out(exmem_pc_branch)
    );

    dmem dmem_inst(
        .clk(clk),
        .address(exmem_ALUresult),
        .wdata(exmem_rd2),
        .wmem(exmem_MemWrite && enable),
        .rmem(exmem_MemRead),
        .rdata(rdata)
    );
    
    mem_wb mem_wb_inst(
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .rdata(rdata),
        .ALUresult(exmem_ALUresult),
        .MemtoReg(exmem_MemtoReg),
        .MemRead(exmem_MemRead),
        .RegWrite(exmem_RegWrite),
        .rd(exmem_rd),
        .rdata_out(memwb_rdata),
        .ALUresult_out(memwb_ALUresult),
        .MemtoReg_out(memwb_MemtoReg),
        .Memread_out(memwb_Memread),      
        .RegWrite_out(memwb_RegWrite),  
        .rd_out(memwb_rd)
    );

    //WB MUX
    always_comb begin
        if(memwb_MemtoReg)
            rw = memwb_rdata;
        else
            rw = memwb_ALUresult;
    end

    // IMM ADDER
    assign pc_branch = idex_pc + idex_imm;

    //BRANCH AND 
    assign branch_taken = exmem_Branch & exmem_zero;

    //PC MUX
    always_comb begin
        if(branch_taken)
            pc_next = exmem_pc_branch;
        else
            pc_next = pc_4;
    end

    bypass bypass_inst(
        .idex_rs1(idex_rs1),
        .idex_rs2(idex_rs2),
        .exmem_rd(exmem_rd),
        .exmem_RegWrite(exmem_RegWrite),
        .memwb_rd(memwb_rd),
        .memwb_RegWrite(memwb_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    stall stall_inst(
        .idex_MemRead(idex_MemRead),
        .idex_rd(idex_rd),
        .ifid_rs1(ifid_instruction[19:15]),
        .ifid_rs2(ifid_instruction[24:20]),
        .stall(stall)
    );

endmodule    

