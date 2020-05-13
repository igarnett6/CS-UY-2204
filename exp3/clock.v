

module clockCalculator (SETSECOND, SETMINUTE, SETHOUR, SETB, SHOWTIME, 
           TIMERSTARTS, PAUSETIMER, CONTINUETIMER, RESETa, CLK100MHZ,
           ONEHERTZOUT, MODETIMER, MODECLOCK,
           SBUS6, SBUS5, SBUS4, SBUS3, SBUS2, SBUS1, SBUS0, DCDEN7, DCDEN6, DCDEN5, DCDEN4, DCDEN3, DCDEN2, DCDEN1, DCDEN0,
           STREGVAL) ;
         
      
         
///////////////////////////////////////////////////////////////// 
//              Module Declarations Start Below
/////////////////////////////////////////////////////////////////         
         
input SETSECOND, SETMINUTE, SETHOUR, SHOWTIME, TIMERSTARTS, PAUSETIMER, CONTINUETIMER, RESETa, CLK100MHZ;
input [7:0] SETB;
output ONEHERTZOUT, MODETIMER, MODECLOCK;
output DCDEN7, DCDEN6, DCDEN5, DCDEN4, DCDEN3, DCDEN2, DCDEN1, DCDEN0, SBUS6, SBUS5, SBUS4, SBUS3, SBUS2, SBUS1, SBUS0 ; 
//output [2:0] STREG;
output [2:0] STREGVAL ;

reg [7:0] T;
integer setTime;
//wire [7:0] SETB ;


integer hoursl, hoursr, secondsl, secondsr, minutesl, minutesr, centisecondsl, centisecondsr;
integer thoursl, thoursr, tsecondsl, tsecondsr, tminutesl, tminutesr, tcentisecondsl, tcentisecondsr;

wire signed [15:0] D ;
wire R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0 ;

wire OPRENTERED ;
//reg signed [15:0] C ;

// ADDOP, SUBOP, MULOP, DIVOP, EXPOP ;
reg [2:0] STREG ;
reg [7:0] H, S ,M,C;
reg ERROR ;

integer i ;
wire RST = 0 ;
wire CLK1HZ, CLK800HZ, CLK100HZ, CLK4HZ ;
reg AE7, AE6, AE5, AE4, AE3, AE2, AE1, AE0 ;
wire OVF ;

reg clk, tim;
reg timerON, clockON;

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
                   S13 = 4'b1101 ;
                
                                
// Data Unit and Control descriptions start below

// Instantiate the Frequency Divider in the Data Unit
   FREQDIV freq_divider (.ONEHUNDREDMEGAHERTZ(CLK100MHZ), .RESET(RST), 
                         .ONEHERTZ(CLK1HZ), .EIGHTHUNDREDHERTZ(CLK800HZ), .ONEHUNDREDHERTZ(CLK100HZ), .FOURHERTZ(CLK4HZ)) ;
 
 // Instantiate the Key Pad Pmod Controller in the Data Unit
    //PmodKEYPAD KeyPad_ctrl (.clk(CLK100MHZ), .JA(KEYINPOUT), .Keypadout(KEYVAL)) ;
   

// Instantiate the ALU Block in the Data Unit
   //alu alu_1 (.R15(D[15]), .R14(D[14]), .R13(D[13]), .R12(D[12]), .R11(D[11]), .R10(D[10]), .R9(D[9]), .R8(D[8]),
   //                      .R7(D[7]), .R6(D[6]), .R5(D[5]), .R4(D[4]), .R3(D[3]), .R2(D[2]), .R1(D[1]), .R0(D[0]), .OVF(OVF), 
   //                      .K7(A[7]), .K6(A[6]), .K5(A[5]), .K4(A[4]), .K3(A[3]), .K2(A[2]), .K1(A[1]), .K0(A[0]),
   //                      .M7(B[7]), .M6(B[6]), .M5(B[5]), .M4(B[4]), .M3(B[3]), .M2(B[2]), .M1(B[1]), .M0(B[0]),
   //                      .ADD(ADDOP), .SUB(SUBOP), .MUL(MULOP), .DIV(DIVOP), .EXP(EXPOP)); 
                         

// Instantiate the 7-Segment Controller in the Data Unit
   ssdCtrl seven_segment_ctrl(.AN7(DCDEN7), .AN6(DCDEN6), .AN5(DCDEN5), .AN4(DCDEN4), .AN3(DCDEN3), .AN2(DCDEN2), .AN1(DCDEN1), .AN0(DCDEN0),
                              .SEGA(SBUS6), .SEGB(SBUS5), .SEGC(SBUS4), .SEGD(SBUS3), .SEGE(SBUS2), .SEGF(SBUS1), .SEGG(SBUS0),
                              .CLK100MHZ(CLK100MHZ), .RST(RST), .Err (ERROR),
                              .DIN31(H[7]), .DIN30(H[6]), .DIN29(H[5]), .DIN28(H[4]), .DIN27(H[3]), .DIN26(H[2]), .DIN25(H[1]), .DIN24(H[0]), 
                              .DIN23(M[7]), .DIN22(M[6]), .DIN21(M[5]), .DIN20(M[4]), .DIN19(M[3]), .DIN18(M[2]), .DIN17(M[1]), .DIN16(M[0]), 
                              .DIN15(S[7]), .DIN14(S[6]), .DIN13(S[5]), .DIN12(S[4]), .DIN11(S[3]), .DIN10(S[2]), .DIN9(S[1]), .DIN8(S[0]), 
                              .DIN7(C[7]), .DIN6(C[6]), .DIN5(C[5]), .DIN4(C[4]), .DIN3(C[3]), .DIN2(C[2]), .DIN1(C[1]), .DIN0(C[0]),
                              .AE7(AE7), .AE6(AE6), .AE5(AE5), .AE4(AE4), .AE3(AE3), .AE2(AE2), .AE1(AE1), .AE0(AE0)) ;
          

// Data Unit circuits
        
   // assign OPRENTERED = (ADD | SUB | MUL | DIV | EXP) ;   

           
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
          RESET : begin H <= 8'd0 ; M <= 8'd0 ; S <= 8'd0 ; C <= 8'd0 ; 
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
                        
                         if (RESETa) STREG <= RESET ;
                         else if (SETSECOND) STREG <= S1 ; 
                         else if (SETMINUTE) STREG <= S2 ;
                         else if (SETHOUR) STREG <= S3 ;
                         else if (SHOWTIME) STREG <= S4 ;
                  end
  
          S1 : begin i <= SETB ; AE2 <= 0 ; AE3 <= 0; 
                     secondsl = i/10;
                     secondsr = i%10;
                     S[3:0] <= secondsr;
                     S[7:4] <= secondsl;
                     if (RESETa) STREG <= RESET ;
                     else if (SETSECOND) STREG <= S1 ; 
                     else if (SETMINUTE) STREG <= S2 ;
                     else if (SETHOUR) STREG <= S3 ; // not in state diagram but this is more helpful for user
                     else if (SHOWTIME) STREG <= S4 ;
               end
                
          S2 : begin i <= SETB ; AE4 <= 0 ; AE5 <= 0;
                    minutesl <= i/10;
                    minutesr <= i%10;
                    M[7:4] <= minutesl;
                    M[3:0] <= minutesr;
                    if (RESETa) STREG <= RESET ;
                    else if (SETSECOND) STREG <= S1 ; // not in state diagram but this is more helpful for user
                    else if (SETMINUTE) STREG <= S2 ;
                    else if (SETHOUR) STREG <= S3 ;
                    else if (SHOWTIME) STREG <= S4 ;
               end           
          
          S3 : begin i <= SETB ; AE6 <= 0 ; AE7 <= 0;
                    hoursl = i/10;
                    hoursr = i%10;
                    H[7:4] <= hoursl;
                    H[3:0] <= hoursr;
                    if (RESETa) STREG <= RESET ;
                    else if (SETSECOND) STREG <= S1 ; // not in state diagram but this is more helpful for user
                    else if (SETMINUTE) STREG <= S2 ; // not in state diagram but this is more helpful for user
                    else if (SETHOUR) STREG <= S3 ;
                    else if (SHOWTIME) STREG <= S4 ;
               end
          
          S4 : begin clockON <= 1;
               AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
               clk <= 1;
               H[7:4] <= hoursl;
               H[3:0] <= hoursr;
               M[7:4] <= minutesl;
               M[3:0] <= minutesr;
               S[7:4] <= secondsl;
               S[3:0] <= secondsr;
               C[7:4] <= centisecondsl;
               C[3:0] <= centisecondsr;
               if (RESETa) STREG <= RESET ;
               else if (SETSECOND) STREG <= S1 ;
               else if (SETMINUTE) STREG <= S2 ;
               else if (SETHOUR) STREG <= S3 ;
               else if (TIMERSTARTS) STREG <= S5 ;
               else if (PAUSETIMER) STREG <= S6 ;
               else if (CONTINUETIMER) STREG <= S7 ; 
               end
                
                
          S5 : begin C[7:0] <= SETB ; 
                   AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                   timerON <= 1;
                   tim <=1;
                   clk <= 0;
                   H[7:4] <= thoursl;
                   H[3:0] <= thoursr;
                   M[7:4] <= tminutesl;
                   M[3:0] <= tminutesr;
                   S[7:4] <= tsecondsl;
                   S[3:0] <= tsecondsr;
                   C[7:4] <= tcentisecondsl;
                   C[3:0] <= tcentisecondsr;
                   if (RESETa) STREG <= RESET ;
                   else if (SHOWTIME) STREG <= S4 ;
                   else if (TIMERSTARTS) STREG <= S5 ;
                   else if (PAUSETIMER) STREG <= S6 ;                   
               end
          
          S6 : begin C[7:0] <= SETB ;
                   AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                   timerON <= 0;
                   tim <=0;
                   clk <= 0;
                   if (RESETa) STREG <= RESET ;
                   else if (SHOWTIME) STREG <= S4 ;
                   else if (PAUSETIMER) STREG <= S6 ;   
                   else if (CONTINUETIMER) STREG <= S7 ;                  
               end
               
          S7 : begin C[7:0] <= SETB ; 
                   AE7<= 0 ; AE6<= 0 ; AE5<= 0 ; AE4<=0 ; AE3<= 0 ; AE2<= 0 ; AE1<= 0 ; AE0<= 0 ; 
                   timerON <= 1;
                   tim <= 1;
                   clk <= 0;
                   H[7:4] <= thoursl;
                   H[3:0] <= thoursr;
                   M[7:4] <= tminutesl;
                   M[3:0] <= tminutesr;
                   S[7:4] <= tsecondsl;
                   S[3:0] <= tsecondsr;
                   C[7:4] <= tcentisecondsl;
                   C[3:0] <= tcentisecondsr;
                   if (RESETa) STREG <= RESET ;
                   else if (SHOWTIME) STREG <= S4 ;
                   else if (CONTINUETIMER) STREG <= S7 ; 
               end
               
         
          
          default STREG <= RESET ;
        endcase
     end   
       




//// Timer
//    always @ (posedge CLK100HZ) begin
//        if (timerON == 1) begin
//            if (tcentiseconds == 99) begin
//                tcentiseconds = 0;
//                if (tseconds == 59) begin
//                    tseconds = 0;
//                    if (tminutes == 59) begin
//                        tminutes = 0;
//                        if (thours == 23) begin
//                            thours = 0;
//                        end
//                        else begin
//                            thours = thours + 1;
//                        end
//                    end
//                    else begin
//                        tminutes = tminutes + 1;
//                    end
//                end
//                else begin
//                    tseconds = tseconds + 1;
//                end
//            end
//            else begin
//                tcentiseconds = tcentiseconds + 1;
//            end
//        end
    
//    end

       
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