module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o,MemToReg_o,Branch_o,BranchType_o,MemWrite_o,MemRead_o,jump_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
output 			MemToReg_o;
output			Branch_o;
output			BranchType_o;
output			MemWrite_o;
output			MemRead_o;
output			jump_o;

//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;
wire	 		MemToReg_o;
wire			Branch_o;
wire			BranchType_o;
wire			MemWrite_o;
wire			MemRead_o;
wire 			jump_o;

//Main function
/*your code here*/
assign RegWrite_o=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|//R type
		  (instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0])|//lw
		  (instr_op_i[5] & instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|//addi
		  (instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);//jal;

assign ALUSrc_o=(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0])|//lw
		(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|//sw
		(instr_op_i[5] & instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);//addi

assign RegDst_o=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);//R type

assign MemToReg_o=(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0]);//lw

assign Branch_o=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & ~instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|//beq
		(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0]);//bne

assign BranchType_o=(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0]);//bne

assign MemWrite_o=(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);//sw
                  

assign MemRead_o=(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0]);//lw

assign jump_o=(instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & ~instr_op_i[2] & instr_op_i[1] & ~instr_op_i[0])|//jump
	      (instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);//jal
///
assign ALUOp_o[2]=(instr_op_i[5] & instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|//addi
		  (instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0]);//bne

assign ALUOp_o[1]=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & instr_op_i[2] & instr_op_i[1] & instr_op_i[0])|//R type
		  (instr_op_i[5] & ~instr_op_i[4] & ~instr_op_i[3] & instr_op_i[2] & ~instr_op_i[1] & instr_op_i[0]);//bne

assign ALUOp_o[0]=(instr_op_i[5] & instr_op_i[4] & instr_op_i[3] & ~instr_op_i[2] & instr_op_i[1] & instr_op_i[0]);//beq

endmodule
   