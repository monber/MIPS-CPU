module IDEX( pc_i,pc_jump_i, clk_i, ID2EX_write, ctrl_signal_i, RSdata_i, RTdata_i, dataSE_i, Rsaddr_i, Rtaddr_i, Rdaddr_i, pc_o, pc_jump_o, ctrl_signal_o, RSdata_o, RTdata_o, dataSE_o, Rsaddr_o, Rtaddr_o, Rdaddr_o	);
     
//I/O ports
input clk_i;
input [32-1:0] pc_i;
input [32-1:0] pc_jump_i;
input  [11:0] ctrl_signal_i;
input ID2EX_write;
input [32-1:0] RSdata_i;
input [32-1:0] RTdata_i;
input [32-1:0] dataSE_i;
input [4:0] Rsaddr_i;
input [4:0] Rtaddr_i;
input [4:0] Rdaddr_i;

output reg [32-1:0] pc_o;
output reg [32-1:0] pc_jump_o;
output reg  [11:0] ctrl_signal_o;
output reg [32-1:0] RSdata_o;
output reg [32-1:0] RTdata_o;
output reg [32-1:0] dataSE_o;
output reg [4:0] Rsaddr_o;
output reg [4:0] Rtaddr_o;
output reg [4:0] Rdaddr_o;

//Main function
always @(posedge clk_i) begin
	pc_o <= pc_i;
	if(ID2EX_write)
		ctrl_signal_o <=ctrl_signal_i;
	else
		ctrl_signal_o <=12'b0;
	RSdata_o <=RSdata_i;
	RTdata_o <=RTdata_i;
	dataSE_o <=dataSE_i;
	Rsaddr_o <=Rsaddr_i;
	Rtaddr_o <=Rtaddr_i;
	Rdaddr_o <=Rdaddr_i;
end
    	
	
	
//Initial Memory Contents
initial begin
	pc_o <= 32'b0;
	ctrl_signal_o<=12'b0;
	RSdata_o <=32'b0;
	RTdata_o <=32'b0;
	dataSE_o <=32'b0;
	Rtaddr_o <=5'b0;
	Rtaddr_o <=5'b0;
	Rdaddr_o <=5'b0;
end
endmodule
