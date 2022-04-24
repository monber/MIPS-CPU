module Fwrd_Unit(EX_Rsaddr, EX_Rtaddr, MEM_WriReg, MEM_isRegWrite, WB_WriReg, WB_isRegWrite, src_select_1, src_select_2);

input      [5-1:0] EX_Rsaddr;
input      [5-1:0] EX_Rtaddr;
input      [5-1:0] MEM_WriReg;
input       MEM_isRegWrite;
input      [5-1:0] WB_WriReg;
input       WB_isRegWrite;

output wire [1:0]src_select_1;
output wire [1:0]src_select_2;
//10for EX hazard 01 for MEM hazard
assign src_select_1=(MEM_isRegWrite && MEM_WriReg!=0 &&MEM_WriReg==EX_Rsaddr)?2'b10:
					(WB_isRegWrite && WB_WriReg!=0 && WB_WriReg==EX_Rsaddr && ~(MEM_isRegWrite && MEM_WriReg!=0 &&MEM_WriReg==EX_Rsaddr))?2'b01:2'b0;
assign src_select_2=(MEM_isRegWrite && MEM_WriReg!=0 &&MEM_WriReg==EX_Rtaddr)?2'b10:
					(WB_isRegWrite && WB_WriReg!=0 && WB_WriReg==EX_Rtaddr && ~(MEM_isRegWrite && MEM_WriReg!=0 &&MEM_WriReg==EX_Rtaddr))?2'b01:2'b0;

endmodule