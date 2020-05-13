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


module calculator_tb();

//initialization of testbench variables
reg DIGITENTEREDtb, ENTERtb, ADDtb, SUBtb, MULtb, DIVtb, CLEARtb, EXPtb, CLK100MHZtb ;
wire [7:0] KEYINPOUTtb ;
wire AN7tb, AN6tb, AN5tb, AN4tb, AN3tb, AN2tb, AN1tb, AN0tb,SEGAtb, SEGBtb, SEGCtb, SEGDtb, SEGEtb, SEGFtb, SEGGtb ; 
wire ADDITIONtb, SUBTRACTIONtb, MULTIPLICATIONtb, DIVISIONtb, EXPONENTtb ;
wire [3:0] STREGVALtb ;

reg OVFtb = 0;  //overflow for test bench
integer i, j, c; //for loop variables
reg signed [15:0] OUT ;  // output variable
reg signed [7:0] OUT1 ;
reg signed [7:0] OUT2 ;

    calculator UUT (.KEYINPOUT(KEYINPOUTtb), .DIGITENTERED(DIGITENTEREDtb), .ENTER(ENTERtb),
           .ADD(ADDtb), .SUB(SUBtb), .MUL(MULtb), .DIV(DIVtb), .CLEAR(CLEARtb), .EXP(EXPtb), .CLK100MHZ(CLK100MHZtb),
           .ADDITION(ADDITIONtb), .SUBTRACTION(SUBTRACTIONtb), .MULTIPLICATION(MULTIPLICATIONtb), .DIVISION(DIVISIONtb), .EXPONENT(EXPONENTtb),
           .AN7(AN7tb), .AN6(AN6tb), .AN5(AN5tb), .AN4(AN4tb), .AN3(AN3tb), .AN2(AN2tb), .AN1(AN1tb), .AN0(AN0tb),
           .SEGA(SEGAtb), .SEGB(SEGBtb), .SEGC(SEGCtb), .SEGD(SEGDtb), .SEGE(SEGEtb), .SEGF(SEGFtb), .SEGG(SEGGtb),
           .STREGVAL(STREGVALtb));
         

    initial begin: calculator_tb
        for (i = -128; i < 127; i = i + 1) 
            begin
             for (j = -128; j < 127; j = j +1)
                begin

                    //addition start
                    force calculator_tb.UUT.A = i;  //force first number
                    force calculator_tb.UUT.ADDOP = 1;  //force addition
                    force calculator_tb.UUT.B = j;  //force second number
                    #10
                    OUT = calculator_tb.UUT.D ;
                    OVFtb = calculator_tb.UUT.OVF;
                    $display("Time: %4d ns K: %8d + M: %8d Result: %16d Overflow: %1b",$time, i, j, OUT, OVFtb);
                    force calculator_tb.UUT.ADDOP = 0;
                    release calculator_tb.UUT.ADDOP;
                    //addition end
                    
                    //subtraction start                 
                    force calculator_tb.UUT.SUBOP = 1;  //force subtraction                       
                    #10 
                    OUT = calculator_tb.UUT.D ;
                    OVFtb = calculator_tb.UUT.OVF;
                    $display("Time: %4d ns K: %8d - M: %8d Result: %16d Overflow: %1b",$time, i, j, OUT, OVFtb);                                                                       
                    force calculator_tb.UUT.SUBOP = 0;                  
                    release calculator_tb.UUT.SUBOP;                    
                    //subtraction end
                    
                    //multiplication start                 
                    force calculator_tb.UUT.MULOP = 1;  //force multiplication
                    #10 
                    OUT = calculator_tb.UUT.D ;
                    OVFtb = calculator_tb.UUT.OVF;
                    $display("Time: %4d ns K: %8d * M: %8d Result: %16d Overflow: %1b",$time, i, j, OUT, OVFtb);                                                                        
                    force calculator_tb.UUT.MULOP = 0;                  
                    release calculator_tb.UUT.MULOP;                    
                    //multiplication end
                    
                    
                    //division start                 
                    force calculator_tb.UUT.DIVOP = 1;  //force division
                    #10 
                    OUT = calculator_tb.UUT.D ;
                    OUT1 = OUT[15:8]; 
                    OUT2 = OUT[7:0]; // used for signed remainder
                    OVFtb = calculator_tb.UUT.OVF;
                    $display("Time: %4d ns K: %8d / M: %8d Result: %9d r:%4d Overflow: %1b",$time, i, j, OUT1, OUT2, OVFtb);                                                                        
                    force calculator_tb.UUT.DIVOP = 0;                  
                    release calculator_tb.UUT.DIVOP;                    
                    //division end
                    
                    //exponentiation start                 
                    force calculator_tb.UUT.EXPOP = 1;  //force exponentiation
                    #10
                    OUT = calculator_tb.UUT.D ;
                    OVFtb = calculator_tb.UUT.OVF;
                    $display("Time: %4d ns K: %8d ^ M: %8d Result: %16d Overflow: %1b",$time, i, j, OUT, OVFtb);                                                                        
                    force calculator_tb.UUT.EXPOP = 0;                  
                    release calculator_tb.UUT.EXPOP;                    
                    //exponentiation end
                    
     
                      release calculator_tb.UUT.A;  
                      release calculator_tb.UUT.B;  
               end
             end
       end
 
endmodule

