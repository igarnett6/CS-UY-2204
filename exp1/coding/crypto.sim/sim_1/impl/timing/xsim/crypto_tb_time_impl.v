// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Sep 27 16:41:16 2019
// Host        : CSE024WK-W10 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               S:/cs2204/exp1/coding/crypto.sim/sim_1/impl/timing/xsim/crypto_tb_time_impl.v
// Design      : crypto
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* ECO_CHECKSUM = "3f063ee9" *) 
(* NotValidForBitStream *)
module crypto
   (a,
    b,
    c,
    d,
    key3,
    key2,
    key1,
    key0,
    y3,
    y2,
    y1,
    y0);
  input a;
  input b;
  input c;
  input d;
  input key3;
  input key2;
  input key1;
  input key0;
  output y3;
  output y2;
  output y1;
  output y0;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire c;
  wire c_IBUF;
  wire d;
  wire d_IBUF;
  wire key0;
  wire key0_IBUF;
  wire key1;
  wire key1_IBUF;
  wire key2;
  wire key2_IBUF;
  wire key3;
  wire key3_IBUF;
  wire y0;
  wire y0_OBUF;
  wire y1;
  wire y1_OBUF;
  wire y2;
  wire y2_OBUF;
  wire y3;
  wire y3_OBUF;

initial begin
 $sdf_annotate("crypto_tb_time_impl.sdf",,,,"tool_control");
end
  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  IBUF c_IBUF_inst
       (.I(c),
        .O(c_IBUF));
  IBUF d_IBUF_inst
       (.I(d),
        .O(d_IBUF));
  IBUF key0_IBUF_inst
       (.I(key0),
        .O(key0_IBUF));
  IBUF key1_IBUF_inst
       (.I(key1),
        .O(key1_IBUF));
  IBUF key2_IBUF_inst
       (.I(key2),
        .O(key2_IBUF));
  IBUF key3_IBUF_inst
       (.I(key3),
        .O(key3_IBUF));
  OBUF y0_OBUF_inst
       (.I(y0_OBUF),
        .O(y0));
  LUT2 #(
    .INIT(4'h6)) 
    y0_OBUF_inst_i_1
       (.I0(key0_IBUF),
        .I1(d_IBUF),
        .O(y0_OBUF));
  OBUF y1_OBUF_inst
       (.I(y1_OBUF),
        .O(y1));
  LUT2 #(
    .INIT(4'h6)) 
    y1_OBUF_inst_i_1
       (.I0(key1_IBUF),
        .I1(c_IBUF),
        .O(y1_OBUF));
  OBUF y2_OBUF_inst
       (.I(y2_OBUF),
        .O(y2));
  LUT2 #(
    .INIT(4'h6)) 
    y2_OBUF_inst_i_1
       (.I0(key2_IBUF),
        .I1(b_IBUF),
        .O(y2_OBUF));
  OBUF y3_OBUF_inst
       (.I(y3_OBUF),
        .O(y3));
  LUT2 #(
    .INIT(4'h6)) 
    y3_OBUF_inst_i_1
       (.I0(key3_IBUF),
        .I1(a_IBUF),
        .O(y3_OBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
