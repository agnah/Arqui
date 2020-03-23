`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2020 09:55:36
// Design Name: 
// Module Name: control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control
#(  parameter NB_INSTRUCCION = 6,
    parameter NB_CTRL_WB = 2,
    parameter NB_CTRL_MEM = 9,
    parameter NB_CTRL_EX = 8,
    parameter NB_ALU_CONTROL = 4,
    parameter NB_ALU_OP = 2
)
(
    input [NB_INSTRUCCION-1:0] i_opcode,
    input [NB_INSTRUCCION-1:0] i_inst_funcion,
    output reg [NB_CTRL_WB-1:0] o_ctrl_wb,//RegWrite Y MemtoReg
    output reg [NB_CTRL_MEM-1:0] o_ctrl_mem,//BranchNotEqual, SB, SH, LB, LH, Unsigned , Branch , MemRead Y MemWrite
    output reg [NB_CTRL_EX-1:0] o_ctrl_ex // RegDst ,ALUSrc1(MUX de la entrada A de la ALU), ALUSrc2(MUX de la entrada B de la ALU), Jump y alu_code(4)
);

reg [NB_ALU_OP-1:0] alu_op;
wire [NB_ALU_CONTROL-1:0] o_alu_control;

always @(*)
begin
    case(i_opcode)
        6'b000000: //Tipo-R
        begin
            alu_op = 2'b10;
            o_ctrl_wb = 2'b10;
            o_ctrl_mem = 9'b000000000;
            if((i_inst_funcion == 6'b000000) || (i_inst_funcion == 6'b000010) || (i_inst_funcion == 6'b000011)) //SLL SRL SRA
                o_ctrl_ex = {4'b1100,o_alu_control};
            else    
                o_ctrl_ex = {4'b1000,o_alu_control};
        end
        
        6'b100000: //LOAD LB
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b11;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b000100010;
        end
        
        6'b100001: //LOAD LH
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b11;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b000010010; 
        end
        
        6'b100011: //LOAD LW, LWU
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b11;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b000000010;  
        end
        
        6'b100100: //LOAD LBU
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b11;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b000101010;
        end
        
        6'b100101: //LOAD LH
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b11;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b000011010; 
        end
        
        6'b101000: // Tipo-Store SB
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b00;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b010000001;
        end
        
        6'b101001: // Tipo-Store SH
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b00;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b001000001;
        end
        
        6'b101011: // Tipo-Store SW
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b00;
            o_ctrl_ex = {4'b0010,o_alu_control};
            o_ctrl_mem = 9'b000000001;
        end
        
        6'b001000: //ADDI
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b10;
            o_ctrl_mem = 9'b000000000;
            o_ctrl_ex = {4'b0010,o_alu_control};  
        end
        
        6'b001100: //ANDI
        begin
            alu_op = 2'b11;
            o_ctrl_wb = 2'b10;
            o_ctrl_mem = 9'b000000000;
            o_ctrl_ex = {4'b0010,o_alu_control};  
        end
        
        6'b001101: //ORI
        begin
            alu_op = 2'b11;
            o_ctrl_wb = 2'b10;
            o_ctrl_mem = 9'b000000000;
            o_ctrl_ex = {4'b0010,o_alu_control};  
        end
        
        6'b001110: //XORI
        begin
            alu_op = 2'b11;
            o_ctrl_wb = 2'b10;
            o_ctrl_mem = 9'b000000000;
            o_ctrl_ex = {4'b0010,o_alu_control};  
        end
        
        6'b001111: //LUI
        begin
            alu_op = 2'b11;
            o_ctrl_wb = 2'b10;
            o_ctrl_mem = 9'b000000000;
            o_ctrl_ex = {4'b0010,o_alu_control};  
        end
        
        /*6'b000100: // Tipo-branch
        begin
            alu_op = 2'b01;
            o_ctrl_wb = 2'b00;
            o_ctrl_mem = 3'b100; //CAMBIAR
            o_ctrl_ex = {4'b0000,o_alu_control};
        end
        
        6'b000010: // Tipo-Jump
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b00;
            o_ctrl_mem = 3'b000; //CAMBIAR
            o_ctrl_ex = {4'b0001,o_alu_control};
        end*/
        
        default:
        begin
            alu_op = 2'b00;
            o_ctrl_wb = 2'b00;
            o_ctrl_mem = 9'b000000000;
            o_ctrl_ex = {4'b0000,o_alu_control};
        end
    endcase
end

//ALU_CONTROL
alu_control
#(
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP),
    .NB_INSTRUCCION(NB_INSTRUCCION)
)
u_alu_control
(
    .i_inst_funcion(i_inst_funcion),
    .i_alu_op(alu_op),
    .o_alu_code(o_alu_control)
);
endmodule
