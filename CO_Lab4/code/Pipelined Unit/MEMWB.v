module MEMWB( clk_i, ctrl_signal_i, Readdata_i, retAlu_i, WriReg_i, ctrl_signal_o, Readdata_o, retAlu_o, WriReg_o);
     
//I/O ports
input          clk_i;
input  [6:0] ctrl_signal_i;
input  [32-1:0] Readdata_i;
input  [32-1:0] retAlu_i;
input  [4:0] WriReg_i;


output reg  [1:0] ctrl_signal_o;
output reg  [32-1:0] Readdata_o;
output reg  [32-1:0] retAlu_o;
output reg  [4:0] WriReg_o;
//Main function
always @(posedge clk_i) begin
    ctrl_signal_o <=ctrl_signal_i[1:0];
	Readdata_o <= Readdata_i;
	retAlu_o <=retAlu_i;
	WriReg_o <=WriReg_i;
end
	
//Initial Memory Contents
initial begin
	ctrl_signal_o<=2'b0;
	Readdata_o<=32'b0;
	retAlu_o<=32'b0;
	WriReg_o <=5'b0;
end
endmodule
