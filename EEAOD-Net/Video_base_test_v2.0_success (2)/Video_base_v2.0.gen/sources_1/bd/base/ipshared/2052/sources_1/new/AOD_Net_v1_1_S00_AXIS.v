`timescale 1 ns / 1 ps

module AOD_Net_v1_1_S00_AXIS #(
	// Users to add parameters here
	parameter integer PIXEL_WIDTH	= 24,
	parameter integer PIX_W 	= 		1280,
	parameter integer PIX_H 	= 		960,
	// User parameters ends
	// Do not modify the parameters beyond this line

	// AXI4Stream sink: Data Width
	parameter integer C_S_AXIS_TDATA_WIDTH	= 32
)(
	// Users to add ports here
	output reg [PIXEL_WIDTH-1:0]conv1_in,
	output reg conv1_en,
	// User ports ends
	// Do not modify the ports beyond this line

	// AXI4Stream sink: Clock
	input wire S_AXIS_ACLK,
	// AXI4Stream sink: Reset
	input wire S_AXIS_ARESETN,
	// Data is in valid
	input wire S_AXIS_TVALID,
	// Ready to accept data in
	output wire S_AXIS_TREADY,
	// Data in
	input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
	// TKEEP

	// Byte qualifier
	input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
	// TUSER
	// input wire [0:0]S_AXIS_TUSER,
	// Indicates boundary of last packet
	input wire S_AXIS_TLAST
	// TID

	// TDEST

);
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
		begin
		for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
			bit_depth = bit_depth >> 1;
		end
	endfunction

	// Total number of input data.
	// localparam NUMBER_OF_INPUT_WORDS  = 307200;
	localparam NUMBER_OF_INPUT_WORDS = PIX_W*PIX_H;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 

					WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
										// input stream data S_AXIS_TDATA 
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals
	genvar byte_index;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	reg writes_done;
	//*************************************************************************************************修改
	reg [3:0] cnt_8=0;
	wire cnt_8_full;
	//*************************************************************************************************修改
	// I/O Connections assignments

	assign S_AXIS_TREADY	= axis_tready;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
		if (!S_AXIS_ARESETN) 
		// Synchronous reset (active low)
		begin
			mst_exec_state <= IDLE;
		end  
		else
		case (mst_exec_state)
			IDLE: 
				// The sink starts accepting tdata when 
				// there tvalid is asserted to mark the
				// presence of valid streaming data 
				if (S_AXIS_TVALID)
				begin
					mst_exec_state <= WRITE_FIFO;
				end
				else
				begin
					mst_exec_state <= IDLE;
				end
			WRITE_FIFO: 
				// When the sink has accepted all the streaming input data,
				// the interface swiches functionality to a streaming master
				if (writes_done)
				begin
					mst_exec_state <= IDLE;
				end
				else
				begin
					// The sink accepts and stores tdata 
					// into FIFO
					mst_exec_state <= WRITE_FIFO;
				end
		endcase
	end
	// AXI Streaming Sink 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	//*************************************************************************************************修改
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS) && cnt_8_full);
	// assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS-1)) ;
	//*************************************************************************************************修改

	always@(posedge S_AXIS_ACLK)
	begin
		if(!S_AXIS_ARESETN)
		begin
			write_pointer <= 0;
			writes_done <= 1'b0;
		end  
		else
		if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)begin
			if (fifo_wren)
			begin
				// write pointer is incremented after every write to the FIFO
				// when FIFO write signal is enabled.
				write_pointer <= write_pointer + 1;
				writes_done <= 1'b0;
			end
			else if ((write_pointer == NUMBER_OF_INPUT_WORDS)|| S_AXIS_TLAST)
			begin
				// reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
				// has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
				write_pointer <= 0;
				writes_done <= 1'b1;
			end
			else begin
				write_pointer <= write_pointer;
				writes_done <= 1'b0;
			end
		end  
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// // FIFO Implementation
	// generate 
	// 	for(byte_index=0; byte_index<= (C_S_AXIS_TDATA_WIDTH/8-1); byte_index=byte_index+1)
	// 	begin:FIFO_GEN
	// 		reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];
	// 		// Streaming input data is stored in FIFO
	// 		always @( posedge S_AXIS_ACLK )
	// 		begin
	// 			if (fifo_wren)// && S_AXIS_TSTRB[byte_index])
	// 			begin
	// 				stream_data_fifo[write_pointer] <= S_AXIS_TDATA[(byte_index*8+7) -: 8];
	// 			end  
	// 		end  
	// 	end		
	// endgenerate

	// Add user logic here
	//*************************************************************************************************修改
	//每27周期拉高一次axis_tready
	always@(posedge S_AXIS_ACLK)begin
		if(!S_AXIS_ARESETN)begin
			cnt_8 <= 0;
		end
		else if(cnt_8_full||S_AXIS_TLAST)begin
			cnt_8 <= 0;
		end
		else if(mst_exec_state == WRITE_FIFO)begin
			cnt_8 <= cnt_8 + 5'd1;
		end
		else begin
			cnt_8 <= cnt_8;
		end
	end

	assign cnt_8_full = (cnt_8 == 4'd8)?1'b1:1'b0;

	//产生conv1的输入
	always@(posedge S_AXIS_ACLK)begin
		if(!S_AXIS_ARESETN)begin
			conv1_in <= 0;
		end
		else begin
			conv1_in <= {(S_AXIS_TDATA[23:16] + 8'd128),(S_AXIS_TDATA[15:8] + 8'd128),(S_AXIS_TDATA[7:0] + 8'd128)};
		end
	end

	always@(posedge S_AXIS_ACLK)begin
		if(!S_AXIS_ARESETN)begin
			conv1_en <= 0;
		end 
		else if (fifo_wren)begin
			conv1_en <= 1;
		end
		else begin
			conv1_en <= 0;
		end
	end
	//*************************************************************************************************修改
	// User logic ends

endmodule
