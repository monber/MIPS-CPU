`define pc_add 32'h00000004
module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] pc_i;
wire [32-1:0] pc_4;
wire [32-1:0] pc_branch;
wire [32-1:0] pc_o;
wire [32-1:0] pc_buf;
wire [32-1:0] pc_j;
wire [32-1:0] pc_i2;

wire [32-1:0] instr;

wire [4:0] addrWriteReg;

wire [32-1:0] RSdata;
wire [32-1:0] RTdata;

wire RegWrite;
wire [2:0] ALUOp;
wire ALUSrc;
wire RegDst;
wire MemToReg;
wire Branch;
wire BranchType;
wire MemWrite;
wire MemRead;
wire jump;

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

wire [31:0] Mux3to1_o;
wire [31:0] dataMemory_o;
wire [31:0] retWriteReg;

wire  PCsrc;
wire branch_o;

wire [32-1:0] pcJr;
wire pcJrSrc;
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_i2) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
        .src1_i(pc_o),     
	    .src2_i(`pc_add),
	    .sum_o(pc_4)    
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
	.instr_op_i(instr[31:26]), 
	.pc_4_i(pc_4),
	.funct_i(instr[5:0]),
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(addrWriteReg) ,  
        .RDdata_i(retWriteReg)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata),
	.pcJr_o(pcJr),
	.pcJrSrc_o(pcJrSrc) 
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),
	    .MemToReg_o(MemToReg),
	    .Branch_o(Branch),
	    .BranchType_o(BranchType),
 	    .MemWrite_o(MemWrite),
	    .MemRead_o(MemRead),
	    .jump_o(jump)  
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt),
	.leftRight(leftRight)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(dataSE)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(dataZF)
        );
		
Mux2to1 #(.size(32)) ALU_src2ALU(
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
		
//PC calculation
Mux2to1 #(.size(1)) branchType(
        .data0_i(zero),
        .data1_i(~zero),
        .select_i(BranchType),
        .data_o(branch_o)
        );	
assign PCsrc=branch_o&Branch;

Adder Adder2(
        .src1_i(pc_4),     
	    .src2_i((dataSE<<2)),
	    .sum_o(pc_branch)    
	    );

Mux2to1 #(.size(32)) branch2PC(
        .data0_i(pc_4),
        .data1_i(pc_branch),
        .select_i(PCsrc),
        .data_o(pc_buf)
        );	

assign pc_j={pc_4[31:28],instr[25:0],2'b00};
Mux2to1 #(.size(32)) j2PC(
        .data0_i(pc_buf),
        .data1_i(pc_j),
        .select_i(jump),
        .data_o(pc_i)
        );	

Mux2to1 #(.size(32)) jr2PC(
        .data0_i(pc_i),
        .data1_i(pcJr),
        .select_i(pcJrSrc),
        .data_o(pc_i2)
        );	

///
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
        .data_o(Mux3to1_o)
        );		

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(Mux3to1_o),
	.data_i(RTdata),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(dataMemory_o)
);	

Mux2to1 #(.size(32)) DM2Reg(
        .data0_i(Mux3to1_o),
        .data1_i(dataMemory_o),
        .select_i(MemToReg),
        .data_o(retWriteReg)
        );	
		

endmodule



