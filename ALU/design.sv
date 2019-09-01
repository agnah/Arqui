// Code your design here

module ALU #(parameter NB_DATA=5,
            parameter NB_OPERADOR=6)
(
  input signed [NB_DATA-1 : 0]i_dato_a,
  input signed [NB_DATA-1 : 0]i_dato_b,
  input [NB_OPERADOR-1 : 0]i_operador,
  output reg [NB_DATA-1: 0] o_resultado 
);
  
localparam ADD = 6'b100000;
localparam SUB = 6'b100010;
localparam AND = 6'b100100;
localparam OR = 6'b100101;
localparam XOR= 6'b100110;
localparam NOR = 6'b100111;
localparam SRA = 6'b000011;
localparam SRL = 6'b000010;
  
always @(*)
begin
  case(i_operador)
    ADD: o_resultado = i_dato_a + i_dato_b;		
    SUB: o_resultado = i_dato_a - i_dato_b; //preguntar
    AND: o_resultado = i_dato_a & i_dato_b;
    OR: o_resultado = i_dato_a | i_dato_b;
    XOR: o_resultado = i_dato_a ^ i_dato_b;
    NOR: o_resultado = ~(i_dato_a | i_dato_b);
    SRA: o_resultado = i_dato_a >>> i_dato_b;
    SRL: o_resultado = i_dato_a >> i_dato_b;
    default: o_resultado = {NB_DATA{1'b0}};
  endcase
end
endmodule
  