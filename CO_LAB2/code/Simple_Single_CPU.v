`define pc_add 32'h00000004
module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] pc_i;
wire [32-1:0] pc_o;

wire [32-1:0] instr;

wire [4:0] addrWriteReg;

wire [32-1:0] RSdata;
wire [32-1:0] RTdata;

wire RegWrite;
wire [2:0] ALUOp;
wire ALUSrc;
wire RegDst;

wire [3:0] ALU_operation;
wire [1:0] FURslt;

wire [31:0] dataSE;

wire [31:0] dataZF;

wire [31:0] dataAlu;

wire [31:0] retAlu;
wire zero;
wire overflow;

wire [31:0] retShift;
wire leftRight;

wire [31:0] retWriteReg;
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_i) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
        .src1_i(pc_o),     
	    .src2_i(`pc_add),
	    .sum_o(pc_i)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_o),  
	    .instr_o(instr)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(addrWriteReg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(addrWriteReg) ,  
        .RDdata_i(retWriteReg)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst)   
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(dataSE)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(dataZF)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(RTdata),
        .data1_i(dataSE),
        .select_i(ALUSrc),
        .data_o(dataAlu)
        );	
		
ALU ALU(
		.aluSrc1(RSdata),
	    .aluSrc2(dataAlu),
	    .ALU_operation_i(ALU_operation),
		.result(retAlu),
		.zero(zero),
		.overflow(overflow)
	    );
		
assign leftRight=(instr[1]==1)?0:1;
Shifter shifter( 
		.result(retShift), 
		.leftRight(leftRight),
		.shamt(instr[10:6]),
		.sftSrc(dataAlu) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(retAlu),
        .data1_i(retShift),
		.data2_i(dataZF),
        .select_i(FURslt),
        .data_o(retWriteReg)
        );			

endmodule



