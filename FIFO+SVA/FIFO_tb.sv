import shared_pkg::*;
import FIFO_transaction_pkg::*;

module FIFO_tb(FIFO_if.TEST FIFO_if);

	FIFO_transaction t;
	initial begin
		t=new();
		//here we randomize_data
		assert(t.randomize() with {rst_n==0;});
		    FIFO_if.data_in<=t.data_in;
			FIFO_if.wr_en<=t.wr_en;
			FIFO_if.rd_en<=t.rd_en;
			FIFO_if.rst_n<=t.rst_n;
		for (int i = 0; i < 100000; i++) begin
			@(negedge FIFO_if.clk);
			assert(t.randomize());
			FIFO_if.data_in<=t.data_in;
			FIFO_if.wr_en<=t.wr_en;
			FIFO_if.rd_en<=t.rd_en;
			FIFO_if.rst_n<=t.rst_n;
		end
		// 
		test_finished=1;
	end

endmodule