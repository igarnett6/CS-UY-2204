`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2019 04:33:09 PM
// Design Name: 
// Module Name: crypto
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


module crypto(CLK100MHZ, KEYINPOUT, a, b, c, d, y3, y2, y1, y0);
    input CLK100MHZ;
    inout [7:0] KEYINPOUT;
    wire [3:0] KEYVAL;
    
    input a, b, c, d;
    output y3, y2, y1, y0;
        
        PmodKEYPAD KeyPad_Controller (.clk(CLK100MHZ), .JA(KEYINPOUT), .Keypadout(KEYVAL));
        
        assign y3 = a ^ KEYVAL[3];
        assign y2 = b ^ KEYVAL[2];
        assign y1 = c ^ KEYVAL[1];
        assign y0 = d ^ KEYVAL[0];
        
endmodule

