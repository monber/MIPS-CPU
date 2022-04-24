module Hazard_Detect_Unit(MEM_branch, MEM_jump, EX_Rtaddr, ID_Rsaddr, ID_Rtaddr, EX_MemRead, pcWrite, ID2EX_write, IF2ID_write, IF2ID_flush, EX2MEM_write);
input MEM_branch;
input MEM_jump;
input      [5-1:0] EX_Rtaddr;
input      [5-1:0] ID_Rsaddr;
input      [5-1:0] ID_Rtaddr;
input       EX_MemRead;

output wire pcWrite;
output wire ID2EX_write;
output wire IF2ID_write;
output wire IF2ID_flush;
output wire EX2MEM_write;
//10for EX hazard 01 for MEM hazard
assign pcWrite=(EX_MemRead &&(EX_Rtaddr==ID_Rsaddr || EX_Rtaddr==ID_Rtaddr))?0:1;
assign ID2EX_write=(EX_MemRead &&(EX_Rtaddr==ID_Rsaddr || EX_Rtaddr==ID_Rtaddr)||MEM_branch || MEM_jump)?0:1;
assign IF2ID_write=(EX_MemRead &&(EX_Rtaddr==ID_Rsaddr || EX_Rtaddr==ID_Rtaddr))?0:1;
assign IF2ID_flush=(MEM_branch |MEM_jump);
assign EX2MEM_write=( MEM_branch||MEM_jump)?0:1;

endmodule