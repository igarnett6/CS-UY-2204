

module calculator (KEYINPOUT, DIGITENTERED,ENTER,
           ADD, SUB, MUL, DIV, CLEAR, EXP, CLK100MHZ,
           ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, EXPONENT,
           AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0,
           SEGA, SEGB, SEGC, SEGD, SEGE, SEGF, SEGG,
           STREGVAL) ;
         
      
         
///////////////////////////////////////////////////////////////// 
//              Module Declarations Start Below
/////////////////////////////////////////////////////////////////         
         
input DIGITENTERED, ENTER, ADD, SUB, MUL, DIV, CLEAR, EXP, CLK100MHZ ;
inout [7:0] KEYINPOUT ;
output AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0,SEGA, SEGB, SEGC, SEGD, SEGE, SEGF, SEGG ; 
output ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, EXPONENT ;
output [3:0] STREGVAL ;

wire signed [15:0] D ;
wire R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0 ;
wire [3:0] KEYVAL ;
wire OPRENTERED ;
reg signed [15:0] C ;
reg ADDOP, SUBOP, MULOP, DIVOP, EXPOP ;
reg [3:0] STREG ;
reg signed [7:0] A, B ;
reg ERROR ;

integer i ;
wire RST = 0 ;
wire CLK1HZ, CLK800HZ, CLK100HZ, CLK4HZ ;
reg AE7, AE6, AE5, AE4, AE3, AE2, AE1, AE0 ;
wire OVF ;


///////////////////////////////////////////////////////////////// 
//             Module Description Starts Below
/////////////////////////////////////////////////////////////////


// Constants are names below

   parameter [3:0] RESET = 4'b0000,
                   S1 = 4'b0001,
                   S2 = 4'b0010,
                   S3 = 4'b0011,
                   S4 = 4'b0100,
                   S5 = 4'b0101,
                   S6 = 4'b0110,
                   S7 = 4'b0111,
                   S8 = 4'b1000,
                   S9 = 4'b1001,
                   S10 = 4'b1010,
                   S11 = 4'b1011,
                   S12 = 4'b1100,
                   S13 = 4'b1101 ;
                
                                
// Data Unit and Control descriptions start below

// Instantiate the Frequency Divider in the Data Unit
   FREQDIV freq_divider (.ONEHUNDREDMEGAHERTZ(CLK100MHZ), .RESET(RST), 
                         .ONEHERTZ(CLK1HZ), .EIGHTHUNDREDHERTZ(CLK800HZ), .ONEHUNDREDHERTZ(CLK100HZ), .FOURHERTZ(CLK4HZ)) ;
 
 // Instantiate the Key Pad Pmod Controller in the Data Unit
    PmodKEYPAD KeyPad_ctrl (.clk(CLK100MHZ), .JA(KEYINPOUT), .Keypadout(KEYVAL)) ;
   

// Instantiate the ALU Block in the Data Unit
   alu alu_1 (.R15(D[15]), .R14(D[14]), .R13(D[13]), .R12(D[12]), .R11(D[11]), .R10(D[10]), .R9(D[9]), .R8(D[8]),
                         .R7(D[7]), .R6(D[6]), .R5(D[5]), .R4(D[4]), .R3(D[3]), .R2(D[2]), .R1(D[1]), .R0(D[0]), .OVF(OVF), 
                         .K7(A[7]), .K6(A[6]), .K5(A[5]), .K4(A[4]), .K3(A[3]), .K2(A[2]), .K1(A[1]), .K0(A[0]),
                         .M7(B[7]), .M6(B[6]), .M5(B[5]), .M4(B[4]), .M3(B[3]), .M2(B[2]), .M1(B[1]), .M0(B[0]),
                         .ADD(ADDOP), .SUB(SUBOP), .MUL(MULOP), .DIV(DIVOP), .EXP(EXPOP)); 
                         

// Instantiate the 7-Segment Controller in the Data Unit
   ssdCtrl seven_segment_ctrl(.AN7(AN7), .AN6(AN6), .AN5(AN5), .AN4(AN4), .AN3(AN3), .AN2(AN2), .AN1(AN1), .AN0(AN0),
                              .SEGA(SEGA), .SEGB(SEGB), .SEGC(SEGC), .SEGD(SEGD), .SEGE(SEGE), .SEGF(SEGF), .SEGG(SEGG),
                              .CLK100MHZ(CLK100MHZ), .RST(RST), .Err (ERROR),
                              .DIN31(R15), .DIN30(R14), .DIN29(R13), .DIN28(R12), .DIN27(R11), .DIN26(R10), .DIN25(R9), .DIN24(R8), 
                              .DIN23(R7), .DIN22(R6), .DIN21(R5), .DIN20(R4), .DIN19(R3), .DIN18(R2), .DIN17(R1), .DIN16(R0), 
                              .DIN15(B[7]), .DIN14(B[6]), .DIN13(B[5]), .DIN12(B[4]), .DIN11(B[3]), .DIN10(B[2]), .DIN9(B[1]), .DIN8(B[0]), 
                              .DIN7(A[7]), .DIN6(A[6]), .DIN5(A[5]), .DIN4(A[4]), .DIN3(A[3]), .DIN2(A[2]), .DIN1(A[1]), .DIN0(A[0]),
                              .AE7(AE7), .AE6(AE6), .AE5(AE5), .AE4(AE4), .AE3(AE3), .AE2(AE2), .AE1(AE1), .AE0(AE0)) ;
          

// Data Unit circuits
        
    assign OPRENTERED = (ADD | SUB | MUL | DIV | EXP) ;   
  
           
 // Data and Control Unit circuits described together below  
               
    always @ (posedge CLK4HZ) begin
       case (STREG)
          RESET : begin C <= 16'd0 ; A <= 8'd0 ; B <= 8'd0 ; 
                        ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; ERROR <= 0 ;
                        AE7<= 1 ; AE6<= 1 ; AE5<= 1 ; AE4<=1 ; AE3<= 1 ; AE2<= 1 ; AE1<= 1 ; AE0<= 1 ; 
                         if (CLEAR) STREG <= RESET ;
                             else if (DIGITENTERED) STREG <= S1 ; 
                  end
  
          S1 : begin A[3:0] <= KEYVAL ; AE0 <= 0 ; 
                     if (CLEAR) STREG <= RESET ;
                          else if (~DIGITENTERED) STREG <= S2 ;
               end
                
          S2 :  if (CLEAR) STREG <= RESET ;
                    else if (DIGITENTERED) STREG <= S3 ;
                             else if (OPRENTERED)          
                                      begin
                                         STREG <= S5 ; 
                                         if (ADD) begin  ADDOP <= 1 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                             else if (SUB) begin ADDOP <= 0 ; SUBOP <= 1 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                                     else if (MUL) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 1 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                                             else if (DIV) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 1 ; EXPOP <= 0 ; end
                                                                      else if (EXP) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 1 ; end 
                                     end 
          
          S3 : begin if (A[3:0] != 0) begin A[7:4] <= A[3:0] ; AE1 <= 0 ; end
                     if (CLEAR) STREG <= RESET ;
                         else if (~DIGITENTERED) STREG <= S4 ; 
               end      
          
          S4 : begin A[3:0] <= KEYVAL ; 
                     if (CLEAR) STREG <= RESET ;
                         else if (OPRENTERED)
                                  begin
                                       STREG <= S5 ; 
                                       if (ADD) begin  ADDOP <= 1 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                           else if (SUB) begin ADDOP <= 0 ; SUBOP <= 1 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                                else if (MUL) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 1 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                                   else if (DIV) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 1 ; EXPOP <= 0 ; end
                                                            else if (EXP) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 1 ; end 
                                 end 
                end
                
          S5 : begin
                    if (ADD) begin  ADDOP <= 1 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                       else if (SUB) begin ADDOP <= 0 ; SUBOP <= 1 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                else if (MUL) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 1 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                        else if (DIV) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 1 ; EXPOP <= 0 ; end 
                                                 else if (EXP) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 1 ; end
                  if (CLEAR) STREG <= RESET ;
                  else if (DIGITENTERED) STREG <= S6 ; 
               end
          
          S6 : begin B[3:0] <= KEYVAL ; AE2 <= 0 ; 
                     if (CLEAR) STREG <= RESET ;
                         else if (~DIGITENTERED) STREG <= S7 ;
               end
               
          S7 : if (CLEAR) STREG <= RESET ;
                  else if (DIGITENTERED) STREG <= S8 ;
                           else if (ENTER)STREG <= S10 ;       
          
          S8 : begin if (B[3:0] != 0) begin B[7:4] <= B[3:0] ; AE3 <= 0 ; end 
                     if (CLEAR) STREG <= RESET ;
                         if (~DIGITENTERED) STREG <= S9 ;
                end
          
          S9 :  begin B[3:0] <= KEYVAL ; 
                      if (CLEAR) STREG <= RESET ;
                          else if (ENTER) STREG <= S10 ;
               end
          
          S10 : begin if (((B == 8'd0) & DIVOP) | ((B[7] == 1) & EXPOP) | (OVF)) ERROR <= 1 ;
                      else C <= D ;
                      if (CLEAR) STREG <= RESET ;
                         else STREG <= S11 ; 
                end
                
          S11 :  begin if ((C[3:0] != 0) | (C[7:4] != 0) | (C[11:8] != 0)| (C[15:12] != 0))  AE4<= 0;
                       if ((C[7:4] != 0) | (C[11:8] != 0)| (C[15:12] != 0)) AE5 <=0;
                       if ((C[11:8] != 0) | (C[15:12] != 0)) AE6 <=0;
                       if (C[15:12] != 0) AE7<= 0;
                       if (CLEAR) STREG <= RESET ;
                         else if (DIGITENTERED) STREG <= S12 ; 
                 end           
          
          S12 : begin C <= 16'd0 ; A <= 8'd0 ; B <= 8'd0 ; 
                     ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ;ERROR <= 0 ;
                     AE7<= 1 ; AE6<= 1 ; AE5<= 1 ; AE4<=1 ; AE3<= 1 ; AE2<= 1 ; AE1<= 1 ; AE0<= 1 ;
                     if (CLEAR == 1) STREG <= RESET ;
                        else STREG <= S13 ;
                end                               
          
          S13 : begin if (KEYVAL != 0) begin A[3:0] <= KEYVAL ; AE0 <= 0 ; end
                      if (CLEAR) STREG <= RESET ;
                          else if (~DIGITENTERED) STREG <= S2 ;
                end
          
          default STREG <= RESET ;
        endcase
     end                       
       
       
// Data Unit circuits below
                                                  
//  The ADDITION, SUBTRACTION, MULTIPLICATION and DIVISION LED light ouputs receive their values from their registers

       assign {R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0} = C ;
       assign ADDITION = ADDOP;
       assign SUBTRACTION = SUBOP ;
       assign MULTIPLICATION = MULOP ;
       assign DIVISION = DIVOP ;
       assign EXPONENT = EXPOP ;
       assign STREGVAL = STREG ;
   
   
/////////////////////////////////////////////////////////////////


endmodule