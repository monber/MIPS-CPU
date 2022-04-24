module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o);

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
//Internal Signals
wire		[4-1:0] ALU_operation_o;

//Main function
/*your code here*/
assign ALU_operation_o[3]=(ALUOp_i==2&&(~funct_i[5] & funct_i[4] & ~funct_i[3] & funct_i[2] & ~funct_i[1] & funct_i[0] & ALUOp_i[1]));//NOR

assign ALU_operation_o[2]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & funct_i[2] & ~funct_i[1] & funct_i[0] & ALUOp_i==2)|//Nor
			  (funct_i[5] & ~funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i==2)|//slt
			  (~funct_i[5] & funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i==2)|//sub
 			  (~ALUOp_i[2] & ~ALUOp_i[1]& ALUOp_i[0]) | (ALUOp_i[2] & ALUOp_i[1]& ~ALUOp_i[0]);//bne beq;

assign ALU_operation_o[1]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & ~funct_i[2] & funct_i[1] & ~funct_i[0] & ALUOp_i==2)|//add
			  (~funct_i[5] & funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i==2)|//sub
			  (funct_i[5] & ~funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i==2)|//slt
			  (ALUOp_i[2] & ~ALUOp_i[1]& ~ALUOp_i[0])|//addi
			  (~ALUOp_i[2] & ~ALUOp_i[1]& ~ALUOp_i[0])|//lw sw
			  (~ALUOp_i[2] & ~ALUOp_i[1]& ALUOp_i[0]) | (ALUOp_i[2] & ALUOp_i[1]& ~ALUOp_i[0]);//bne beq

assign ALU_operation_o[0]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & funct_i[2] & funct_i[1] & ~funct_i[0] & ALUOp_i==2)|//OR
			  (funct_i[5] & ~funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i==2);//SLT


endmodule     
