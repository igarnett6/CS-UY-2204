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
    reg atb, btb, ctb, dtb, keytb3, keytb2, keytb1, keytb0 ;
    wire ytb3, ytb2, ytb1, ytb0 ;
        crypto UUT (.a(atb), .b(btb), .c(ctb), .d(dtb), .key3(keytb3), .key2(keytb2), .key1(keytb1), .key0(keytb0), .y3(ytb3), .y2(ytb2), .y1(ytb1), .y0(ytb0));

        initial begin : crypto_test_bench
           integer i;
           reg [3:0] OUT ;
           for (i=0; i <= 255; i=i+1) 
              begin
                 {atb, btb, ctb, dtb, keytb3, keytb2, keytb1, keytb0} = i ;
                 #10    // Wait for 10 ns then print the results
                 OUT = {ytb3, ytb2, ytb1, ytb0} ;
                $display ("Time: %4d ns I: %3d DATA: %4b  KEY: %4b Output: %4b", $time, i, {atb, btb, ctb, dtb}, {keytb3, keytb2, keytb1, keytb0}, OUT) ; 
             end
         end
endmodule
