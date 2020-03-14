`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 09:53:35
// Design Name: 
// Module Name: tl_instruction_fetch
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


module tl_instruction_fetch 
    #(
        parameter len = 32,
        parameter INIT_FILE_IM="/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/instruction_memory.txt"
    )
    (
        input i_clk,
        input i_rst,
        input [len-1:0] i_branch_dir, //Salto condicional
        input i_PCSrc,
        output [len-1:0] o_instruccion,
        output [len-1:0] o_adder
    );
    
    wire [len-1:0] mux_pc;
    wire [len-1:0] o_contador_programa;
    wire rsta_mem;
    wire regcea_mem;
    wire [len-1:0] cablecito1;
    wire cablecito;
    
    //Control Memoria
    assign rsta_mem =0;
    assign regcea_mem=1;
    assign cablecito =1;
    assign cablecito1 =0;
    
 //mux_PC
 mux
 #(
    .len(len)
  )
  u_mux
  (
    .i_a(o_adder),
    .i_b(i_branch_dir),  
    .i_selector(i_PCSrc),  
    .o_mux(mux_pc)
  );
 
 //pc
 pc
 #(
    .len(len)
  )
  u_pc
  (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_mux(mux_pc),
    .o_pc(o_contador_programa)
  );
  
 //ram_instrucciones
 ram_instrucciones
 #(
    .RAM_WIDTH(len),
    .RAM_DEPTH(2048),
    .RAM_PERFORMANCE("LOW_LATENCY"), //No hace uso de registros (ahorra un ciclo de clock al no usar reg)
    .INIT_FILE(INIT_FILE_IM)        
 )
 u_ram_instrucciones
 (
  .i_addra(o_contador_programa),
  .i_dina(cablecito1), //Ver de donde viene
  .i_clka(i_clk),
  .i_wea(cablecito1),  //Ver de donde viene
  .i_ena(cablecito), //Ver de donde viene
  .i_rsta(rsta_mem),
  .i_regcea(regcea_mem), 
  .o_douta(o_instruccion)  
 );
 
 //sumador
 adder 
 #(
    .len(len)
  )
  u_adder
  (
    .i_a(o_contador_programa), 
    .i_b(32'h00000001),
    .o_adder(o_adder) 
  );
    
    
endmodule
