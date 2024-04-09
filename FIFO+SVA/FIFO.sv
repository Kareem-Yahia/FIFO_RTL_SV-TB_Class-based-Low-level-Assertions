module FIFO(FIFO_if.DUT FIFO_if);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	logic [FIFO_WIDTH-1:0] data_in;
	logic clk, rst_n, wr_en, rd_en;
	logic  [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;


	//for interface connection
	assign data_in=FIFO_if.data_in;
	assign clk=FIFO_if.clk;
	assign rst_n=FIFO_if.rst_n;
	assign wr_en=FIFO_if.wr_en;
	assign rd_en=FIFO_if.rd_en;
	assign FIFO_if.data_out=data_out;
	assign FIFO_if.wr_ack=wr_ack;
	assign FIFO_if.overflow=overflow;
	assign FIFO_if.full=full;
	assign FIFO_if.empty=empty;
	assign FIFO_if.almostfull=almostfull;
	assign FIFO_if.almostempty=almostempty;
	assign FIFO_if.underflow=underflow;

	///////////////////////////////////////////////// 
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			{wr_ptr,overflow,wr_ack} <= 0;
		end
		else if (wr_en && count < FIFO_DEPTH) begin
			mem[wr_ptr] <= data_in;
			wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else begin 
			wr_ack <= 0; 
			if (full && wr_en)
				overflow <= 1;
			else
				overflow <= 0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			{rd_ptr,underflow,data_out}<= 0;
		end
		else if (rd_en && count != 0) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end
		else begin
			if(empty && rd_en)
				underflow<=1;
			else
				underflow<=0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			count <= 0;
		end
		else begin
			if	( ({wr_en, rd_en} == 2'b10) && !full) 
				count <= count + 1;
			else if ( ({wr_en, rd_en} == 2'b01) && !empty)
				count <= count - 1;
		end
	end

	assign full = (count == FIFO_DEPTH)? 1 : 0;
	assign empty = (count == 0)? 1 : 0;
	assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
	assign almostempty = (count == 1)? 1 : 0;


//////////////////////here we write assertions ^_____________________^ ///////////////////////////////////////

	`ifdef asser	 
	property full_flag;
		@(posedge clk) disable iff(!rst_n) (count==FIFO_DEPTH) |-> full;
	endproperty	

	property empty_flag;
		@(posedge clk) disable iff(!rst_n) (count==0) |-> empty;
	endproperty

	property almostfull_flag;
		@(posedge clk) disable iff(!rst_n) (count==(FIFO_DEPTH-1'b1)) |-> almostfull;
	endproperty

	property almostempty_flag;
		@(posedge clk) disable iff(!rst_n) (count==1'b1) |-> almostempty;
	endproperty

	property overflow_flag;
		@(posedge clk) disable iff (!rst_n) (wr_en && full) |=> overflow;
	endproperty	

	property underflow_flag;
		@(posedge clk) disable iff (!rst_n) (rd_en && empty) |=> underflow;
	endproperty

	property wr_acknowledgment;
		@(posedge clk)  disable iff (!rst_n) (wr_en && !full) |=> wr_ack;
	endproperty

	property write_pointer;
		@(posedge clk) disable iff (!rst_n) (wr_en && !full) |=> (wr_ptr==$past(wr_ptr)+1'b1);
	endproperty	

	property read_pointer;
		@(posedge clk) disable iff (!rst_n) (rd_en && !empty) |=> (rd_ptr==$past(rd_ptr)+1'b1);
	endproperty	

	property counter_element1;
		@(posedge clk) disable iff (!rst_n) ( (wr_en && !rd_en) && !full) |=> (count== $past(count)+1'b1);
	endproperty

	property counter_element2;
		@(posedge clk) disable iff (!rst_n) ((!wr_en && rd_en) && !empty) |=> (count== $past(count)-1'b1);
	endproperty

	// reset check
	always_comb begin
		if(!rst_n)
		check_async_reset: assert final ( !data_out && !count && !rd_ptr && !wr_ptr && !full && !overflow 
			&& !underflow && !almostfull && !almostempty && empty && !wr_ack ); 
	end

	full_flag_sva: assert property (full_flag);
	empty_flag_sva:assert property (empty_flag);
	almostfull_flag_sva:assert property(almostfull_flag);
	almostempty_flag_sva: assert property(almostempty_flag);
	overflow_flag_sva: assert property (overflow_flag);
	underflow_flag_sva:assert property (underflow_flag);
	wr_acknowledgment_sva:assert property(wr_acknowledgment);
	write_pointer_sva:assert property( write_pointer);
	read_pointer_sva: assert property(read_pointer);
	counter_element1_sva:assert property (counter_element1);
	counter_element2_sva: assert property (counter_element2);


	cover_full_flag_sva: cover property (full_flag);
	cover_empty_flag_sva:cover property (empty_flag);
	cover_almostfull_flag_sva:cover property(almostfull_flag);
	cover_almostempty_flag_sva: cover property(almostempty_flag);
	cover_overflow_flag_sva: cover property (overflow_flag);
	cover_underflow_flag_sva:cover property (underflow_flag);
	cover_wr_acknowledgment_sva:cover property(wr_acknowledgment);
	cover_write_pointer_sva:cover property( write_pointer);
	cover_read_pointer_sva: cover property(read_pointer);
	cover_counter_element1_sva:cover property (counter_element1);
	cover_counter_element2_sva: cover property (counter_element2);

	`endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule