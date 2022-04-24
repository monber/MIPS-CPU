`define Add 4'b0010
`define Sub 4'b0110
`define And 4'b0000
`define Or 4'b0001
`define Nand 4'b1101
`define Nor 4'b1100
`define Slt 4'b0111
module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	[4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;
wire [32-1:0] retAdd;
wire [32-1:0] retSub;
wire [32-1:0] retAnd;
wire [32-1:0] retOr;
wire [32-1:0] retNand;
wire [32-1:0] retNor;
//Main function
/*your code here*/

  assign retAdd=aluSrc1+aluSrc2;
  assign retSub=aluSrc1-aluSrc2;
  assign retAnd=aluSrc1&aluSrc2;  
  assign retOr=aluSrc1|aluSrc2;
  assign retNand=(~aluSrc1)|(~aluSrc2);
  assign retNor=(~aluSrc1)&(~aluSrc2);
  assign retSlt=(retSub[31])?1:0;
  assign result= (ALU_operation_i==`Add)? retAdd:
                 (ALU_operation_i==`Sub)? retSub:
                 (ALU_operation_i==`And)? retAnd: 
                 (ALU_operation_i==`Or)? retOr:
                 (ALU_operation_i==`Nand)? retNand: 
                 (ALU_operation_i==`Nor)? retNor:
                 (ALU_operation_i==`Slt)? retSlt:0;

  assign zero= (result==0);
  assign overflow=(((ALU_operation_i==`Add) && ((aluSrc1[31]&&aluSrc2[31]&&!result[31]) || (!aluSrc1[31]&&!aluSrc2[31]&&result[31])))||
                  ((ALU_operation_i==`Sub) && ((aluSrc1[31]&&!aluSrc2[31]&&!result[31]) || (!aluSrc1[31]&&aluSrc2[31]&&result[31]))))?1:0;

          
endmodule
