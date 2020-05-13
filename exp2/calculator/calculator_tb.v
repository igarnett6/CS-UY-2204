`timescale 1ns / 1ps

module alu_tb();
    reg K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb, 
           M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb, 
           ADDtb, SUBtb, MULtb, DIVtb, EXPtb;
    wire R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb, OVFtb;
    
    //reg signed [7:0] A;
    //reg signed [7:0] B;
    //integer Overflow;
    
        
        alu UUT (.K7(K7tb), .K6(K6tb), .K5(K5tb), .K4(K4tb), .K3(K3tb), .K2(K2tb), .K1(K1tb), .K0(K0tb), .M7(M7tb), .M6(M6tb), .M5(M5tb), .M4(M4tb), .M3(M3tb), .M2(M2tb), .M1(M1tb), .M0(M0tb), .ADD(ADDtb), .SUB(SUBtb), .MUL(MULtb), .DIV(DIVtb), .EXP(EXPtb), .R15(R15tb), .R14(R14tb), .R13(R13tb), .R12(R12tb), .R11(R11tb), .R10(R10tb), .R9(R9tb), .R8(R8tb), .R7(R7tb), .R6(R6tb), .R5(R5tb), .R4(R4tb), .R3(R3tb), .R2(R2tb), .R1(R1tb), .R0(R0tb), .OVF(OVFtb));
        initial begin : alu_test_bench
           integer i, j;
           
           reg signed [15:0] C;
           reg signed [15:8] C1;
           reg signed [7:0] C2;
           ADDtb = 0;
           SUBtb = 0;
           MULtb = 0;
           DIVtb = 0;
           EXPtb = 0;
               
               for (i=-128; i<127; i=i+1) 
               begin
                 //{K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                 
                 for (j=-128; j<127; j=j+1) 
                 begin
                 
                   
                   {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                   {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = j;
                   ADDtb = 1;
                   #10                       // Wait for 10 ns then print the results
                   C = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
                   $display ("Time: %4d ns K: %6d  +  M: %6d Result: %8d Overflow? %1b", $time, i, j, C, OVFtb) ; 
                   ADDtb = 0;
                   
                   {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                   {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = j;
                   SUBtb = 1;
                   #10                       // Wait for 10 ns then print the results
                   C = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
                   $display ("Time: %4d ns K: %6d  -  M: %6d Result: %8d Overflow? %1b", $time, i, j, C, OVFtb) ; 
                   SUBtb = 0;
                   
                   {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                   {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = j;
                   MULtb = 1;
                   #10                       // Wait for 10 ns then print the results
                   C = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
                   $display ("Time: %4d ns K: %6d  *  M: %6d Result: %8d Overflow? %1b", $time, i, j, C, OVFtb) ; 
                   MULtb = 0;
                   
                   {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                   {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = j;
                   DIVtb = 1;
                   #10                       // Wait for 10 ns then print the results
                   C = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
                   C1 = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb};
                   C2 = {R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
                   $display ("Time: %4d ns K: %6d  /  M: %6d Result: %4dr%3d Overflow? %1b", $time, i, j, C1, C2, OVFtb) ; 
                   DIVtb = 0;
                   
                   {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = i;
                   {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = j;
                   EXPtb = 1;
                   #10                       // Wait for 10 ns then print the results
                   C = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
                   $display ("Time: %4d ns K: %6d  ^  M: %6d Result: %8d Overflow? %1b", $time, i, j, C, OVFtb) ; 
                   EXPtb = 0;
                   
//                   {K7tb, K6tb, K5tb, K4tb, K3tb, K2tb, K1tb, K0tb} = 2;
//                   {M7tb, M6tb, M5tb, M4tb, M3tb, M2tb, M1tb, M0tb} = 3;
//                   EXPtb = 1;
//                   #10                       // Wait for 10 ns then print the results
//                   C = {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb};
//                   $display ("Time: %4d ns K: %0d  M: %0d Result: %0b Overflow? %1b", $time, 2, 3, {R15tb, R14tb, R13tb, R12tb, R11tb, R10tb, R9tb, R8tb, R7tb, R6tb, R5tb, R4tb, R3tb, R2tb, R1tb, R0tb}, OVFtb) ; 
//                   EXPtb = 0;
                   
                   
                 end
               end
             end     
           
endmodule