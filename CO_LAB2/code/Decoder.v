//OPcode transform into those 4 output
module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

//Main function
/*your code here*/
assign RegWrite_o=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|
		  (instr_op_i[5] & instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);
assign ALUOp_o[2]=0;
assign ALUOp_o[1]=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);
assign ALUOp_o[0]=0;
assign ALUSrc_o=(instr_op_i[5] & instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);
assign RegDst_o=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);

endmodule
   