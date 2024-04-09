import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg ::*;
module Monitor(FIFO_if.moni FIFO_if);

	FIFO_transaction t;
	FIFO_coverage cov;
	FIFO_scoreboard score;


	initial begin
		t=new();
		cov=new();
		score=new();

		forever begin
			@(negedge FIFO_if.clk );
			 t.data_in<=FIFO_if.data_in;
			 t.rst_n<=FIFO_if.rst_n;
			 t.wr_en<=FIFO_if.wr_en;
			 t.rd_en<=FIFO_if.rd_en;
			 t.data_out<=FIFO_if.data_out;
			 t.wr_ack<=FIFO_if.wr_ack;
			 t.overflow<=FIFO_if.overflow;
			 t.full<=FIFO_if.full;
			 t.empty<=FIFO_if.empty;
			 t.almostfull<=FIFO_if.almostfull;
			 t.almostempty<=FIFO_if.almostempty;
			 t.underflow<=FIFO_if.underflow;
			 #1;

			 fork 
			 	begin
			 		cov.sample_data(t);	
			 	end

			 	begin
			 		score.check_data(t);
			 	end

			 join

			 if(test_finished) begin
			 	$display("Finished: Time=%0t error_count=%d correct_count=%d ",$time,error_count,correct_count);
			 	$stop;
			 end
		end	 
	end
endmodule