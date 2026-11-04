module alu_ctrl(
    input logic [1:0] ALUsel,
    input logic funct7,
    input logic [2:0] funct3,
    output alu_ctrl_code alu_op
);

    always_comb begin
        alu_op = ADD; //default

        case(ALUsel)
            2'b00: begin
                alu_op = ADD;
            end

            2'b01: begin
                case(funct3)
                    3'b000 ,3'b001: alu_op = SUB;
                    3'b100, 3'b101: alu_op = SLT;
                    3'b110, 3'b111: alu_op = SLTU;
                    default:        alu_op = SUB;
                endcase
            end

            2'b10: begin
                case(funct3)
                    3'b000: alu_op = funct7 ? SUB : ADD;
                    3'b001: alu_op = SLL;
                    3'b010: alu_op = SLT;
                    3'b011: alu_op = SLTU;
                    3'b100: alu_op = XOR;
                    3'b101: alu_op = funct7 ? SRA: SRL;                       
                    3'b110: alu_op = OR;
                    3'b111: alu_op = AND;
                    default: alu_op = ADD;
                endcase
            end

            2'b11: begin
                case(funct3)
                    3'b000: alu_op = (funct7 && !ALUsel[0]) ? SUB : ADD; // there isnt an immediate sub
                    3'b001: alu_op = SLL;
                    3'b010: alu_op = SLT;
                    3'b011: alu_op = SLTU;
                    3'b100: alu_op = XOR;
                    3'b101: alu_op = funct7 ? SRA : SRL;
                    3'b110: alu_op = OR;
                    3'b111: alu_op = AND;
                    default: alu_op = ADD;
                endcase
            end

        endcase
                            
    end
    
endmodule
