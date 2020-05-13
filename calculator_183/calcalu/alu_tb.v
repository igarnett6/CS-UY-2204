`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2019 04:55:04 PM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();
reg K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb, M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb, ADDtb, SUBtb, MULtb, DIVtb, EXPtb ;
wire R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb, OVFtb ;
//wire signed [7:0] Atb ;
//wire signed [7:0] Btb ;
//reg signed [15:0] Ctb ;
reg Overflowtb = 0;
integer i, j, c;
reg signed [15:0] OUT ;


    
    alu UUT (.K7(K7tb), .K6(K6tb), .K5(K5tb), .K4(K4tb), .K3(K3tb),
        .K2(K2tb), .K1(K1tb), .K0(K0tb), .M7(M7tb), .M6(M6tb),
        .M5(M5tb), .M4(M4tb), .M3(M3tb), .M2(M2tb),
        .M1( M1tb), .M0(M0tb), .ADD(ADDtb), .SUB(SUBtb),
        .MUL(MULtb), .DIV(DIVtb), .EXP(EXPtb),
        .R15(R15tb), .R14(R14tb), .R13(R13tb), .R12(R12tb), .R11(R11tb),
        .R10(R10tb), .R9(R9tb), .R8(R8tb), .R7(R7tb), .R6(R6tb), .R5(R5tb),
        .R4(R4tb), .R3(R3tb), .R2(R2tb), .R1(R1tb), .R0(R0tb), .OVF(OVFtb)); 
    
//    assign Atb = {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} ;
//   assign Btb = {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} ;
    
    initial begin: alu_tb
        for (i = -128; i < 127; i = i + 1) //addition test
            begin
             for (j = -128; j < 127; j = j +1)
                begin
                    {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                    {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = j;
                    // c = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};

                    EXPtb <= 0;
                    ADDtb <= 1;
                    #10
                    OUT = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb} ;
                    $display("K: %8d + M: %8d Result: %16d Overflow: %1b", i, j, OUT, OVFtb);
                    
                    ADDtb <= 0;
                    SUBtb <= 1;
                    #10
                     $display("K: %8d - M: %8d Result: %16d Overflow: %1b ", i, j,  {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb}, OVFtb);
                    
                    SUBtb <= 0;
                    MULtb <= 1;
                    #10
                     $display("K: %8d * M: %8d Result: %16d  Overflow: %1b ", i, j, {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb}, OVFtb);
                    MULtb <= 0;
                    DIVtb <= 1;
                    #10
                     $display("K: %8d / M: %8d Result: %16d Overflow: %1b ", i, j, {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb}, OVFtb);
                    DIVtb <= 0;
                    EXPtb <=1;
                    #10
                    $display("K: %8d ^ M: %8d Result: %16d Overflow: %1b ", i, j, {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb}, OVFtb);
               end
             end
        end
 
endmodule