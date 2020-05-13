`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2019 07:59:51 PM
// Design Name: 
// Module Name: crypto_tb
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


module crypto_tb();
    reg atb, btb, ctb, dtb ;
    reg [3:0] KEYVALtb ;
    wire ytb3, ytb2, ytb1, ytb0 ;
    
        crypto UUT (.a(atb), .b(btb), .c(ctb), .d(dtb), .y3(ytb3), .y2(ytb2), .y1(ytb1), .y0(ytb0));

        initial begin : crypto_test_bench
           integer i, j ;
           reg [3:0] OUT ;  
           for (i=0; i < 16; i=i+1) 
              begin
                 {atb, btb, ctb, dtb} = i ;
                 for (j=0 ; j<16 ; j=j+1)
                     begin
                        force crypto_tb.UUT.KEYVAL = j ;
                        KEYVALtb = crypto_tb.UUT.KEYVAL ;
                        #10    // Wait for 10 ns then print the results
                        OUT = {ytb3, ytb2, ytb1, ytb0} ;
                        $display ("Time: %4d ns DATA: %4b  KEY: %4b Output: %4b", $time, {atb, btb, ctb, dtb}, crypto_tb.UUT.KEYVAL, OUT) ; 
                        release crypto_tb.UUT.KEYVAL ;
                     end
              end     
          end
endmodule
