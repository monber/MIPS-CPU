module EXMEM( clk_i, ctrl_signal_i, EX2MEM_write, pc_branch_i, pc_jump_i, zero_i, retAlu_i, Wridata_i, WBaddr_i, ctrl_signal_o, pc_branch_o, pc_jump_o, zero_o, retAlu_o, Wridata_o, WBaddr_o	);
     
//I/O ports
input        clk_i;
input  [6:0] ctrl_signal_i;
input EX2MEM_write;
input [32-1:0] pc_branch_i;
input [32-1:0] pc_jump_i;
input  zero_i;
input [32-1:0] retAlu_i;
input [32-1:0] Wridata_i;
input [4:0] WBaddr_i;

output reg  [6:0] ctrl_signal_o;
output reg [32-1:0] pc_branch_o;
output reg [32-1:0] pc_jump_o;
output reg zero_o;
output reg [32-1:0] retAlu_o;
output reg [32-1:0] Wridata_o;
output reg [4:0] WBaddr_o;

//Main function
always @(posedge clk_i) begin
	
	pc_branch_o <= pc_branch_i;
	if(EX2MEM_write)
		ctrl_signal_o <=ctrl_signal_i;
	else
		ctrl_signal_o <=7'b0;
	zero_o <=zero_i;
	retAlu_o <=retAlu_i;
	Wridata_o <=Wridata_i;
	WBaddr_o <=WBaddr_i;
end
    	
	
	
//Initial Memory Contents
initial begin
	pc_branch_o <= 32'b0;
	ctrl_signal_o<=12'b0;
	zero_o <=0;
	retAlu_o <=32'b0;
	Wridata_o <=32'b0;
	WBaddr_o <=5'b0;
end
endmodule
