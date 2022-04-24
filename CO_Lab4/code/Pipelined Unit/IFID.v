module IFID( clk_i, pc_i, IF2ID_write, IF2ID_flush, instr_i, pc_o, instr_o);
     
//I/O ports
input           clk_i;
input  [32-1:0] pc_i;
input IF2ID_write;
input IF2ID_flush;
input [32-1:0] instr_i;
output [32-1:0] pc_o;
output [32-1:0] instr_o;
//Internal Signals
reg    [32-1:0] pc_o;
reg    [32-1:0] instr_o;

//Main function
always @(posedge clk_i) begin
	if(IF2ID_write) begin
		instr_o <= instr_i;
		pc_o <= pc_i;
	end
	
	if(IF2ID_flush) 
		instr_o <= 32'b0;
end
    
//Initial Memory Contents
initial begin
	instr_o = 32'b0;
	pc_o = 32'b0;
		
end
endmodule
