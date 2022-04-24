module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
assign ALU_operation_o[3]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & funct_i[2] & ~funct_i[1] & funct_i[0] & ALUOp_i[1]);

assign ALU_operation_o[2]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i[1])|
                          (~funct_i[5] & funct_i[4] & ~funct_i[3] & funct_i[2] & ~funct_i[1] & funct_i[0] & ALUOp_i[1])|
			  (funct_i[5] & ~funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i[1]) ;

assign ALU_operation_o[1]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & ~funct_i[2] & funct_i[1] & ~funct_i[0] & ALUOp_i[1])|
			  (~funct_i[5] & funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i[1])|
			  (funct_i[5] & ~funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i[1])|
			   ~ALUOp_i[1];

assign ALU_operation_o[0]=(~funct_i[5] & funct_i[4] & ~funct_i[3] & funct_i[2] & funct_i[1] & ~funct_i[0] & ALUOp_i[1])|
			  (funct_i[5] & ~funct_i[4] & ~funct_i[3] & ~funct_i[2] & ~funct_i[1] & ~funct_i[0] & ALUOp_i[1]);

assign FURslt_o=(funct_i==0||funct_i==2)?1:0;

endmodule     
