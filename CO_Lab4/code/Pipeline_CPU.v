`define pc_add 32'h00000004
module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] pc_i;
wire [32-1:0] pc_4;
wire [32-1:0] pc_o;
wire [1:0] fwrd_select_1;
wire [1:0] fwrd_select_2;
wire [32-1:0] Alusrc1;
wire [32-1:0] Alusrc2;
wire pcWrite;
wire ID2EX_write;
wire IF2ID_write;
wire IF2ID_flush;
wire EX2MEM_write;
/*
wire [32-1:0] pc_branch;

wire [32-1:0] pc_buf;
wire [32-1:0] pc_j;
wire [32-1:0] pc_i2;
*/
wire [32-1:0] instr;
wire [3:0] ALU_operation;
wire [31:0] dataAlu;
/*
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


wire [1:0] FURslt;

wire [31:0] dataSE;

wire [31:0] dataZF;



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
*/
////pipeline signal
wire [32-1:0] ID_instr;
wire [32-1:0] ID_pc;
wire [32-1:0] ID_pc_jump;
wire [11:0] ID_ctrl_signal;
wire [32-1:0] ID_RSdata;
wire [32-1:0] ID_RTdata;
wire [32-1:0] ID_dataSE;
wire [3-1:0] ID_ALUOp;

wire [32-1:0] EX_instr;
wire [32-1:0] EX_pc;
wire [32-1:0] EX_pc_jump;
wire [11:0] EX_ctrl_signal;
wire [32-1:0] EX_RSdata;
wire [32-1:0] EX_RTdata;
wire [32-1:0] EX_dataSE;
wire [4:0] EX_Rsaddr;
wire [4:0] EX_Rtaddr;
wire [4:0] EX_Rdaddr;
wire [32-1:0] EX_retAlu;
wire EX_zero;
wire [32-1:0] EX_pc_branch;
wire [4:0] EX_WriReg;

wire [6:0] MEM_ctrl_signal;
wire [32-1:0] MEM_pc_branch;
wire [32-1:0] MEM_pc_jump;
wire [32-1:0] MEM_pc;
wire MEM_zero;
wire [32-1:0] MEM_retAlu;
wire [32-1:0] MEM_Wridata;
wire [32-1:0] MEM_Readdata;
wire [4:0] MEM_WriReg;
wire MEM_PCsrc;

wire [1:0] WB_ctrl_signal;
wire [32-1:0] WB_Readdata;
wire [32-1:0] WB_retAlu;
wire [32-1:0] WB_Writedata;
wire [4:0] WB_WriReg;

//modules
//////
//////IF stage
//////
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),  
		.pcWrite(pcWrite),
	    .pc_in_i(pc_i) ,   
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
	
Mux2to1 #(.size(32)) branch2PC(
        .data0_i(pc_4),
        .data1_i(MEM_pc),
        .select_i(MEM_PCsrc),
        .data_o(pc_i)
        );	
		
IFID IF2ID( 
		.clk_i(clk_i), 
		.instr_i(instr), 
		.IF2ID_write(IF2ID_write),
		.IF2ID_flush(IF2ID_flush),
		.pc_i(pc_i), 
		.instr_o(ID_instr),
		.pc_o(ID_pc)	
		);
//////
//////ID stage
//////
Reg_File RF( 
	.clk_i(clk_i), 
	.rst_n(rst_n), 
	.RSaddr_i(ID_instr[25:21]), 
	.RTaddr_i(ID_instr[20:16]), 
	.Wrtaddr_i(WB_WriReg), 
	.Wrtdata_i(WB_Writedata), 
	.RegWrite_i(WB_ctrl_signal[1]), 
	.RSdata_o(ID_RSdata), 
	.RTdata_o(ID_RTdata)
	);

Decoder Decoder(
        .instr_op_i(ID_instr[31:26]), 
	    .RegWrite_o(ID_RegWrite), 
	    .ALUOp_o(ID_ALUOp),   
	    .ALUSrc_o(ID_ALUSrc),   
	    .RegDst_o(ID_RegDst),
	    .MemToReg_o(ID_MemToReg),
	    .Branch_o(ID_Branch),
	    .BranchType_o(ID_BranchType),
 	    .MemWrite_o(ID_MemWrite),
	    .MemRead_o(ID_MemRead),
	    .jump_o(ID_jump)  
		);

Sign_Extend SE(
		.data_i(ID_instr[15:0]),
		.data_o(ID_dataSE)
);

assign ID_ctrl_signal={ID_RegDst, ID_ALUOp, ID_ALUSrc, ID_Branch, ID_BranchType, ID_jump, ID_MemRead, ID_MemWrite, ID_RegWrite, ID_MemToReg};

assign ID_pc_jump={ID_pc[31:28],ID_instr[25:0],2'b00};

IDEX ID2EX( 
	.pc_i(ID_pc), 
	.pc_jump_i(ID_pc_jump),
	.clk_i(clk_i), 
	.ID2EX_write(ID2EX_write),
	.ctrl_signal_i(ID_ctrl_signal), 
	.RSdata_i(ID_RSdata), 
	.RTdata_i(ID_RTdata), 
	.dataSE_i(ID_dataSE), 
	.Rsaddr_i(ID_instr[25:21]),
	.Rtaddr_i(ID_instr[20:16]), 
	.Rdaddr_i(ID_instr[15:11]), 
	.pc_o(EX_pc), 
	.pc_jump_o(EX_pc_jump),
	.ctrl_signal_o(EX_ctrl_signal), 
	.RSdata_o(EX_RSdata), 
	.RTdata_o(EX_RTdata), 
	.dataSE_o(EX_dataSE), 
	.Rsaddr_o(EX_Rsaddr),
	.Rtaddr_o(EX_Rtaddr), 
	.Rdaddr_o(EX_Rdaddr)
	);
     
//////
//////EX stage
//////
ALU_Ctrl AC(
        .funct_i(EX_dataSE[5:0]),   
        .ALUOp_i(EX_ctrl_signal[10:8]),   
        .ALU_operation_o(ALU_operation)
        );
	
		
Mux2to1 #(.size(32)) ALU_src2ALU(
        .data0_i(EX_RTdata),
        .data1_i(EX_dataSE),
        .select_i(EX_ctrl_signal[7]),
        .data_o(dataAlu)
        );	
		
Mux3to1 #(.size(32)) fwrd_ALU_src1(
        .data0_i(EX_RSdata),
        .data1_i(WB_Writedata),
		.data2_i(MEM_retAlu),
        .select_i(fwrd_select_1),
        .data_o(Alusrc1)
        );
		
Mux3to1 #(.size(32)) fwrd_ALU_src2(
        .data0_i(dataAlu),
        .data1_i(WB_Writedata),
		.data2_i(MEM_retAlu),
        .select_i(fwrd_select_2),
        .data_o(Alusrc2)
        );
		
ALU ALU(
		.aluSrc1(Alusrc1),
	    .aluSrc2(Alusrc2),
	    .ALU_operation_i(ALU_operation),
		.result(EX_retAlu),
		.zero(EX_zero),
		.overflow(overflow)
	    );
		
Adder Adder2(
        .src1_i(EX_pc),     
	    .src2_i((EX_dataSE<<2)),
	    .sum_o(EX_pc_branch)    
	    );		

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(EX_Rtaddr),
        .data1_i(EX_Rdaddr),
        .select_i(EX_ctrl_signal[11]),
        .data_o(EX_WriReg)
        );	

EXMEM EX2MEM( 
		.clk_i(clk_i), 
		.ctrl_signal_i(EX_ctrl_signal[6:0]), 
		.EX2MEM_write(EX2MEM_write),
		.pc_branch_i(EX_pc_branch), 
		.pc_jump_i(EX_pc_jump),
		.zero_i(EX_zero), 
		.retAlu_i(EX_retAlu), 
		.Wridata_i(EX_RTdata), 
		.WBaddr_i(EX_WriReg), 
		.ctrl_signal_o(MEM_ctrl_signal), 
		.pc_jump_o(MEM_pc_jump),
		.pc_branch_o(MEM_pc_branch), 
		.zero_o(MEM_zero), 
		.retAlu_o(MEM_retAlu), 
		.Wridata_o(MEM_Wridata), 
		.WBaddr_o(MEM_WriReg)	
		);
 

//////
//////MEM stage
//////
//PC calculation
Mux2to1 #(.size(1)) branchType(
        .data0_i(MEM_zero),
        .data1_i(~MEM_zero),
        .select_i(MEM_ctrl_signal[5]),
        .data_o(branch_o)
        );	
		
		
assign MEM_PCsrc=(branch_o&MEM_ctrl_signal[6]) | MEM_ctrl_signal[4];

assign MEM_pc=(branch_o&MEM_ctrl_signal[6])?MEM_pc_branch:MEM_pc_jump;



/*
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
*/
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(MEM_retAlu),
	.data_i(MEM_Wridata),
	.MemRead_i(MEM_ctrl_signal[3]),
	.MemWrite_i(MEM_ctrl_signal[2]),
	.data_o(MEM_Readdata)
);	

MEMWB MEM2WB(
	.clk_i(clk_i), 
	.ctrl_signal_i(MEM_ctrl_signal), 
	.Readdata_i(MEM_Readdata), 
	.retAlu_i(MEM_retAlu), 
	.WriReg_i(MEM_WriReg),
	.ctrl_signal_o(WB_ctrl_signal), 
	.Readdata_o(WB_Readdata), 
	.retAlu_o(WB_retAlu),
	.WriReg_o(WB_WriReg)
	);
//////
//////WB stage
//////
Mux2to1 #(.size(32)) DM2Reg(
        .data0_i(WB_retAlu),
        .data1_i(WB_Readdata),
        .select_i(WB_ctrl_signal[0]),
        .data_o(WB_Writedata)
        );

//////
//////
//////

Fwrd_Unit Fwrd_Unit(
	.EX_Rsaddr(EX_Rsaddr), 
	.EX_Rtaddr(EX_Rtaddr), 
	.MEM_WriReg(MEM_WriReg), 
	.MEM_isRegWrite(MEM_ctrl_signal[1]), 
	.WB_WriReg(WB_WriReg), 
	.WB_isRegWrite(WB_ctrl_signal[1]), 
	.src_select_1(fwrd_select_1), 
	.src_select_2(fwrd_select_2)
	);

Hazard_Detect_Unit Hazard_Detect_Unit(
	.MEM_branch(branch_o&MEM_ctrl_signal[6]),
	.MEM_jump(MEM_ctrl_signal[4]),
	.EX_Rtaddr(EX_Rtaddr), 
	.ID_Rsaddr(ID_instr[25:21]), 
	.ID_Rtaddr(ID_instr[20:16]), 
	.EX_MemRead(EX_ctrl_signal[3]), 
	.pcWrite(pcWrite), 
	.ID2EX_write(ID2EX_write), 
	.IF2ID_write(IF2ID_write),
	.IF2ID_flush(IF2ID_flush),
	.EX2MEM_write(EX2MEM_write)
	);

		
endmodule



