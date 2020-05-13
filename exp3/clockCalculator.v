

module clockCalculator (SETSECOND, SETMINUTE, SETHOUR, SETB, SHOWTIME_DIV, 
           TIMERSTARTS_ADD, PAUSETIMER_SUB, CONTINUETIMER_MUL, RESETa, CLK100MHZ,
           ONEHERTZOUT, MODETIMER, MODECLOCK,
           SBUS6, SBUS5, SBUS4, SBUS3, SBUS2, SBUS1, SBUS0, DCDEN7, DCDEN6, DCDEN5, DCDEN4, DCDEN3, DCDEN2, DCDEN1, DCDEN0,
           STREGVAL,
           TOGGLE,
           KEYINPOUT, DIGITENTERED,ENTER, EXP, 
           ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, EXPONENT) ;
         
      
         
///////////////////////////////////////////////////////////////// 
//              Module Declarations Start Below
/////////////////////////////////////////////////////////////////         
   
   //clock      
input TOGGLE;
input SETSECOND, SETMINUTE, SETHOUR, SHOWTIME_DIV, TIMERSTARTS_ADD, PAUSETIMER_SUB, CONTINUETIMER_MUL, RESETa, CLK100MHZ;
input [7:0] SETB;
output ONEHERTZOUT, MODETIMER, MODECLOCK;
output DCDEN7, DCDEN6, DCDEN5, DCDEN4, DCDEN3, DCDEN2, DCDEN1, DCDEN0, SBUS6, SBUS5, SBUS4, SBUS3, SBUS2, SBUS1, SBUS0 ; 
//output [2:0] STREG;
output [4:0] STREGVAL ;

// calculator
input DIGITENTERED, ENTER, EXP ;
inout [7:0] KEYINPOUT ;
//output AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0,SEGA, SEGB, SEGC, SEGD, SEGE, SEGF, SEGG ; 
output ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, EXPONENT ;



//clock
reg [7:0] T;
integer setTime;
//wire [7:0] SETB ;


integer hoursl, hoursr, secondsl, secondsr, minutesl, minutesr, centisecondsl, centisecondsr;
integer thoursl, thoursr, tsecondsl, tsecondsr, tminutesl, tminutesr, tcentisecondsl, tcentisecondsr;


//reg signed [15:0] C ;

// ADDOP, SUBOP, MULOP, DIVOP, EXPOP ;
reg [4:0] STREG ;
reg [7:0] cH, cS ,cM,cC;



integer ci ;
wire CLK1HZ, CLK800HZ, CLK100HZ, CLK4HZ ;
reg AE7, AE6, AE5, AE4, AE3, AE2, AE1, AE0 ;

reg clk, tim;
reg timerON, clockON;

//calculator
wire signed [15:0] D ;
wire R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0 ;
wire [3:0] KEYVAL ;
wire OPRENTERED ;
reg signed [15:0] C ;
reg ADDOP, SUBOP, MULOP, DIVOP, EXPOP ;
reg signed [7:0] A, B ;
reg ERROR ;

integer i ;
wire RST = 0 ;
wire OVF ;

//use wire to grab switch

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
                   S13 = 4'b1101,
                   S14 = 5'b10000,
                   S15 = 5'b10001,
                   S16 = 5'b10010,
                   S17 = 5'b10011,
                   S18 = 5'b10100,
                   S19 = 5'b10101,
                   S20 = 5'b10110,
                   S21 = 5'b10111;
                
                                
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
   ssdCtrl seven_segment_ctrl(.AN7(DCDEN7), .AN6(DCDEN6), .AN5(DCDEN5), .AN4(DCDEN4), .AN3(DCDEN3), .AN2(DCDEN2), .AN1(DCDEN1), .AN0(DCDEN0),
                              .SEGA(SBUS6), .SEGB(SBUS5), .SEGC(SBUS4), .SEGD(SBUS3), .SEGE(SBUS2), .SEGF(SBUS1), .SEGG(SBUS0),
                              .CLK100MHZ(CLK100MHZ), .RST(RST), .Err (ERROR),
                              .DIN31(cH[7]), .DIN30(cH[6]), .DIN29(cH[5]), .DIN28(cH[4]), .DIN27(cH[3]), .DIN26(cH[2]), .DIN25(cH[1]), .DIN24(cH[0]), 
                              .DIN23(cM[7]), .DIN22(cM[6]), .DIN21(cM[5]), .DIN20(cM[4]), .DIN19(cM[3]), .DIN18(cM[2]), .DIN17(cM[1]), .DIN16(cM[0]), 
                              .DIN15(cS[7]), .DIN14(cS[6]), .DIN13(cS[5]), .DIN12(cS[4]), .DIN11(cS[3]), .DIN10(cS[2]), .DIN9(cS[1]), .DIN8(cS[0]), 
                              .DIN7(cC[7]), .DIN6(cC[6]), .DIN5(cC[5]), .DIN4(cC[4]), .DIN3(cC[3]), .DIN2(cC[2]), .DIN1(cC[1]), .DIN0(cC[0]),
                              .AE7(AE7), .AE6(AE6), .AE5(AE5), .AE4(AE4), .AE3(AE3), .AE2(AE2), .AE1(AE1), .AE0(AE0)) ;
          

// Data Unit circuits
        
    assign OPRENTERED = (TIMERSTARTS_ADD | PAUSETIMER_SUB | CONTINUETIMER_MUL | SHOWTIME_DIV | EXP) ;   

           
 // Data and Control Unit circuits described together below  
               
    always @ (posedge CLK100HZ) begin
    
        if (clockON == 1) begin // Clock test
            if (centisecondsr == 9) begin
                centisecondsr = 0;
                if (centisecondsl == 9) begin
                    centisecondsl = 0;
                    if (secondsr == 9) begin
                        secondsr = 0;
                        if (secondsl == 5) begin
                            secondsl = 0;
                            if (minutesr == 9) begin
                                minutesr = 0;
                                if (minutesl == 5) begin
                                    minutesl = 0;
                                    if (hoursr == 9) begin
                                        hoursr = 0;
                                            hoursl = hoursl + 1;
                                    end
                                    else if (hoursr == 3 && hoursl == 2) begin
                                        hoursr = 0;
                                        hoursl = 0;
                                    end
                                    else begin
                                        hoursr = hoursr + 1;
                                    end
                                end
                                else begin
                                    minutesl = minutesl + 1;
                                end
                            end
                            else begin
                                minutesr = minutesr + 1;
                            end
                        end
                        else begin
                            secondsl = secondsl + 1;
                        end
                    end
                    else begin
                        secondsr = secondsr + 1;
                    end
                end
                else begin
                    centisecondsl = centisecondsl + 1;
                end
            end
            else begin
                centisecondsr = centisecondsr + 1;
            end
        end
    
        if (timerON == 1) begin // timer test
                if (tcentisecondsr == 9) begin
                    tcentisecondsr = 0;
                    if (tcentisecondsl == 9) begin
                        tcentisecondsl = 0;
                        if (tsecondsr == 9) begin
                            tsecondsr = 0;
                            if (tsecondsl == 5) begin
                                tsecondsl = 0;
                                if (tminutesr == 9) begin
                                    tminutesr = 0;
                                    if (tminutesl == 5) begin
                                        tminutesl = 0;
                                        if (thoursr == 9) begin
                                            thoursr = 0;
                                                thoursl = thoursl + 1;
                                        end
                                        else if (thoursr == 3 && thoursl == 2) begin
                                            thoursr = 0;
                                            thoursl = 0;
                                        end
                                        else begin
                                            thoursr = hoursr + 1;
                                        end
                                    end
                                    else begin
                                        tminutesl = tminutesl + 1;
                                    end
                                end
                                else begin
                                    tminutesr = tminutesr + 1;
                                end
                            end
                            else begin
                                tsecondsl = tsecondsl + 1;
                            end
                        end
                        else begin
                            tsecondsr = tsecondsr + 1;
                        end
                    end
                    else begin
                        tcentisecondsl = tcentisecondsl + 1;
                    end
                end
                else begin
                    tcentisecondsr = tcentisecondsr + 1;
                end
            end
        
 
       case (STREG)
          RESET : begin cH <= 8'd0 ; cM <= 8'd0 ; cS <= 8'd0 ; cC <= 8'd0 ; 
                        tim <= 0;
                        clk = 0;
                        clockON <= 0;
                        timerON <= 0;
                        //AE7<= 1 ; AE6<= 1 ; AE5<= 1 ; AE4<=1 ; AE3<= 1 ; AE2<= 1 ; AE1<= 1 ; AE0<= 1 ; 
                        hoursl = 0;
                        minutesl = 0;
                        secondsl = 0;
                        centisecondsl = 0;
                        thoursl = 0;
                        tminutesl = 0;
                        tsecondsl = 0;
                        tcentisecondsl = 0;
                        hoursr = 0;
                        minutesr = 0;
                        secondsr = 0;
                        centisecondsr = 0;
                        thoursr = 0;
                        tminutesr = 0;
                        tsecondsr = 0;
                        tcentisecondsr = 0;
                        
                        AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                        if (TOGGLE == 1) begin
                            STREG <= S8;
                        end
                        else if (TOGGLE == 0) begin
                          if (RESETa) STREG <= RESET ;
                          else if (SETSECOND) STREG <= S1 ; 
                          else if (SETMINUTE) STREG <= S2 ;
                          else if (SETHOUR) STREG <= S3 ;
                          else if (SHOWTIME_DIV) STREG <= S4 ;
                        end
          end
  
          S1 : begin ci <= SETB ; AE2 <= 0 ; AE3 <= 0; 
                     secondsl = ci/10;
                     secondsr = ci%10;
                     cS[3:0] <= secondsr;
                     cS[7:4] <= secondsl;
                     if (TOGGLE == 1) begin
                         STREG <= S8;
                     end
                     else if (TOGGLE == 0) begin
                        if (RESETa) STREG <= RESET ;
                        else if (SETSECOND) STREG <= S1 ; 
                        else if (SETMINUTE) STREG <= S2 ;
                        else if (SETHOUR) STREG <= S3 ; // not in state diagram but this is more helpful for user
                        else if (SHOWTIME_DIV) STREG <= S4 ;
                     end
          end
                
          S2 : begin ci <= SETB ; AE4 <= 0 ; AE5 <= 0;
                    minutesl <= ci/10;
                    minutesr <= ci%10;
                    cM[7:4] <= minutesl;
                    cM[3:0] <= minutesr;
                    if (TOGGLE == 1) begin
                            STREG <= S8;
                        end
                    else if (TOGGLE == 0) begin
                        if (RESETa) STREG <= RESET ;
                        else if (SETSECOND) STREG <= S1 ; // not in state diagram but this is more helpful for user
                        else if (SETMINUTE) STREG <= S2 ;
                        else if (SETHOUR) STREG <= S3 ;
                        else if (SHOWTIME_DIV) STREG <= S4 ;
                    end
          end           
          
          S3 : begin ci <= SETB ; AE6 <= 0 ; AE7 <= 0;
                    hoursl = ci/10;
                    hoursr = ci%10;
                    cH[7:4] <= hoursl;
                    cH[3:0] <= hoursr;
                    if (TOGGLE == 1) begin
                            STREG <= S8;
                        end
                    else if (TOGGLE == 0) begin
                        if (RESETa) STREG <= RESET ;
                        else if (SETSECOND) STREG <= S1 ; // not in state diagram but this is more helpful for user
                        else if (SETMINUTE) STREG <= S2 ; // not in state diagram but this is more helpful for user
                        else if (SETHOUR) STREG <= S3 ;
                        else if (SHOWTIME_DIV) STREG <= S4 ;
                    end
          end
          
          S4 : begin clockON <= 1;
               AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
               clk <= 1;
               cH[7:4] <= hoursl;
               cH[3:0] <= hoursr;
               cM[7:4] <= minutesl;
               cM[3:0] <= minutesr;
               cS[7:4] <= secondsl;
               cS[3:0] <= secondsr;
               cC[7:4] <= centisecondsl;
               cC[3:0] <= centisecondsr;
               if (TOGGLE == 1) begin
                    STREG <= S8;
               end
               else if (TOGGLE == 0) begin
                   if (RESETa) STREG <= RESET ;
                   else if (SETSECOND) STREG <= S1 ;
                   else if (SETMINUTE) STREG <= S2 ;
                   else if (SETHOUR) STREG <= S3 ;
                   else if (TIMERSTARTS_ADD) STREG <= S5 ;
                   else if (PAUSETIMER_SUB) STREG <= S6 ;
                   else if (CONTINUETIMER_MUL) STREG <= S7 ; 
               end
          end    
                
                
          S5 : begin cC[7:0] <= SETB ; 
                   AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                   timerON <= 1;
                   tim <=1;
                   clk <= 0;
                   cH[7:4] <= thoursl;
                   cH[3:0] <= thoursr;
                   cM[7:4] <= tminutesl;
                   cM[3:0] <= tminutesr;
                   cS[7:4] <= tsecondsl;
                   cS[3:0] <= tsecondsr;
                   cC[7:4] <= tcentisecondsl;
                   cC[3:0] <= tcentisecondsr;
                   if (TOGGLE == 1) begin
                      STREG <= S8;
                   end
                   else if (TOGGLE == 0) begin
                       if (RESETa) STREG <= RESET ;
                       else if (SHOWTIME_DIV) STREG <= S4 ;
                       else if (TIMERSTARTS_ADD) STREG <= S5 ;
                       else if (PAUSETIMER_SUB) STREG <= S6 ;         
                   end          
          end
          
          S6 : begin cC[7:0] <= SETB ;
                   AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                   timerON <= 0;
                   tim <=0;
                   clk <= 0;
                   if (TOGGLE == 1) begin
                        STREG <= S8;
                   end
                   else if (TOGGLE == 0) begin
                       if (RESETa) STREG <= RESET ;
                       else if (SHOWTIME_DIV) STREG <= S4 ;
                       else if (PAUSETIMER_SUB) STREG <= S6 ;   
                       else if (CONTINUETIMER_MUL) STREG <= S7 ;      
                   end            
          end
               
          S7 : begin cC[7:0] <= SETB ; 
                   AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                   timerON <= 1;
                   tim <= 1;
                   clk <= 0;
                   cH[7:4] <= thoursl;
                   cH[3:0] <= thoursr;
                   cM[7:4] <= tminutesl;
                   cM[3:0] <= tminutesr;
                   cS[7:4] <= tsecondsl;
                   cS[3:0] <= tsecondsr;
                   cC[7:4] <= tcentisecondsl;
                   cC[3:0] <= tcentisecondsr;
                   if (TOGGLE == 1) begin
                        STREG <= S8;
                   end
                   else if (TOGGLE == 0) begin
                       if (RESETa) STREG <= RESET ;
                       else if (SHOWTIME_DIV) STREG <= S4 ;
                       else if (CONTINUETIMER_MUL) STREG <= S7 ; 
                   end
          end 
          
          S8: begin cM[7:0] <= 8'd0 ; cH[7:0] <= 8'd0; cC <= 8'd0 ; cS <= 8'd0 ; 
                        ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; ERROR <= 0 ;
                        AE7<= 1 ; AE6<= 1 ; AE5<= 1 ; AE4<=1 ; AE3<= 1 ; AE2<= 1 ; AE1<= 1 ; AE0<= 1 ; 
                        if (TOGGLE == 0) begin
                            if(clockON == 1) STREG <= S4;
                            else if(clockON == 0) STREG <= RESET;
                        end
                        else if (TOGGLE == 1) begin
                            if (RESETa) STREG <= S8 ;
                            else if (DIGITENTERED) STREG <= S9 ; 
                        end
          end
  
          S9 : begin 
                cC[3:0] <= KEYVAL ; 
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else if (~DIGITENTERED) STREG <= S10 ;
                end
          end
                
          S10 : begin //cC <= A; cS <= B; cM <= C[7:0]; cH <= C[15:8];
                if (TOGGLE == 0) begin
                     if(clockON == 1) STREG <= S4;
                     else if(clockON == 0) STREG <= RESET;
                 end
                 else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else if (DIGITENTERED) STREG <= S11 ;
                    else if (OPRENTERED)          
                        begin
                        STREG <= S13 ; 
                        if (TIMERSTARTS_ADD) begin  ADDOP <= 1 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                        else if (PAUSETIMER_SUB) begin ADDOP <= 0 ; SUBOP <= 1 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                        else if (CONTINUETIMER_MUL) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 1 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                        else if (SHOWTIME_DIV) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 1 ; EXPOP <= 0 ; end
                        else if (EXP) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 1 ; end 
                    end 
                end
          end
          
          S11 : begin if (cC[3:0] != 0) begin cC[7:4] <= cC[3:0] ; AE1 <= 0 ; end //cC <= A; cS <= B; cM <= C[7:0]; cH <= C[15:8];
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                     if (RESETa) STREG <= S8 ;
                     else if (~DIGITENTERED) STREG <= S12 ; 
               end      
          end
          
          S12 : begin 
                cC[3:0] <= KEYVAL ; 
                 AE1 = 0;
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else if (OPRENTERED)
                    begin
                        STREG <= S13 ; 
                        if (TIMERSTARTS_ADD) begin  ADDOP <= 1 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                        else if (PAUSETIMER_SUB) begin ADDOP <= 0 ; SUBOP <= 1 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                        else if (CONTINUETIMER_MUL) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 1 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                        else if (SHOWTIME_DIV) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 1 ; EXPOP <= 0 ; end
                        else if (EXP) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 1 ; end 
                    end 
                end
          end
                
          S13 : begin //cC <= A; cS <= B; cM <= C[7:0]; cH <= C[15:8];
                    if (TIMERSTARTS_ADD) begin  ADDOP <= 1 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                       else if (PAUSETIMER_SUB) begin ADDOP <= 0 ; SUBOP <= 1 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                else if (CONTINUETIMER_MUL) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 1 ; DIVOP <= 0 ; EXPOP <= 0 ; end
                                        else if (SHOWTIME_DIV) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 1 ; EXPOP <= 0 ; end 
                                                 else if (EXP) begin ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 1 ; end
                  if (TOGGLE == 0) begin
                      if(clockON == 1) STREG <= S4;
                      else if(clockON == 0) STREG <= RESET;
                  end
                  else if (TOGGLE == 1) begin
                      if (RESETa) STREG <= S8 ;
                      else if (DIGITENTERED) STREG <= S14 ; 
                  end
          end
          
          S14 : begin 
                cS[3:0] <= KEYVAL ;  AE2 <= 0 ; 
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else if (~DIGITENTERED) STREG <= S15 ;
                end
          end
               
          S15 : begin //cC <= A; cS <= B; cM <= C[7:0]; cH <= C[15:8];
          if (TOGGLE == 0) begin
              if(clockON == 1) STREG <= S4;
              else if(clockON == 0) STREG <= RESET;
          end
          else if (TOGGLE == 1) begin
              if (RESETa) STREG <= S8 ;
              else if (DIGITENTERED) STREG <= S16 ;
              else if (ENTER)STREG <= S18 ;
          end
          end
          
          S16 : begin //cC <= A; cS <= B; cM <= C[7:0]; cH <= C[15:8];
                if (cS[3:0] != 0) begin cS[7:4] <= cS[3:0] ; AE3 <= 0 ; end 
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                     if (RESETa) STREG <= S8 ;
                     else if (~DIGITENTERED) STREG <= S17 ;
                end
          end
          
          S17 :  begin 
                cS[3:0] <= KEYVAL ;  AE2 = 0;
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else if (ENTER) STREG <= S18 ;
                end
          end
          
          S18 : begin //cC <= A; cS <= B; cM <= C[7:0]; cH <= C[15:8];
                if (((cS == 8'd0) & DIVOP) | ((cS[7] == 1) & EXPOP) | (OVF)) ERROR <= 1 ; 
                      else begin
                       cH <= D[15:8] ;
                       cM <= D[7:0];
                       end
                      
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else STREG <= S19 ; 
                end
          end
                
          S19 :  begin 
                       if ((cM[3:0] != 0) | (cM[7:4] != 0) | (cH[3:0] != 0)| (cH[8:4] != 0)) AE4<= 0;
                       if ((cM[7:4] != 0) | (cH[3:0] != 0)| (cH[7:4] != 0)) AE5 <=0;
                       if ((cH[3:0] != 0) | (cH[7:4] != 0)) AE6 <=0;
                       if (cH[7:4] != 0) AE7<= 0;
                       if (TOGGLE == 0) begin
                            if(clockON == 1) STREG <= S4;
                            else if(clockON == 0) STREG <= RESET;
                        end
                        else if (TOGGLE == 1) begin
                            if (RESETa) STREG <= S8 ;
                            else if (DIGITENTERED) STREG <= S20 ; 
                            
                        end
          end           
        
          S20 : begin cM[7:0] <= 8'd0 ; cH[7:0] <= 8'd0; cC <= 8'd0 ; cS <= 8'd0 ;  
                     ADDOP <= 0 ; SUBOP <= 0 ; MULOP <= 0 ; DIVOP <= 0 ; EXPOP <= 0 ;ERROR <= 0 ;
                     AE7<= 1 ; AE6<= 1 ; AE5<= 1 ; AE4<=1 ; AE3<= 1 ; AE2<= 1 ; AE1<= 1 ; AE0<= 1 ;
                     if (TOGGLE == 0) begin
                         if(clockON == 1) STREG <= S4;
                         else if(clockON == 0) STREG <= RESET;
                     end
                     else if (TOGGLE == 1) begin
                         if (RESETa == 1) STREG <= S8 ;
                         else STREG <= S21 ;
                     end
          end
          
          S21 : begin if (KEYVAL != 0) begin cC[3:0] <= KEYVAL ; end 
                if (TOGGLE == 0) begin
                    if(clockON == 1) STREG <= S4;
                    else if(clockON == 0) STREG <= RESET;
                end
                else if (TOGGLE == 1) begin
                    if (RESETa) STREG <= S8 ;
                    else if (~DIGITENTERED) STREG <= S10 ;
                end
          end
               
         
          
          default STREG <= RESET ;
        endcase
     end   
       



       
// Data Unit circuits below
                                                  
//  The ADDITION, SUBTRACTION, MULTIPLICATION and DIVISION LED light ouputs receive their values from their registers

       //assign {R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0} = C ;
       //assign CLKINP = CLK100MHZ;
       assign MODECLOCK = clk;
       assign MODETIMER = tim;
       assign ONEHERTZOUT = CLK1HZ;
       assign STREGVAL = STREG ;
   
   
/////////////////////////////////////////////////////////////////


endmodule