module top();
	
	parameter clk_period=10;
	bit clk;

	initial begin
		clk=0;
		forever
		#(clk_period/2) clk=~clk;
	end

	FIFO_if FIFO_if(clk); 

	FIFO DUT(FIFO_if);
	FIFO_tb TEST(FIFO_if);
	Monitor MONITOR(FIFO_if);

endmodule