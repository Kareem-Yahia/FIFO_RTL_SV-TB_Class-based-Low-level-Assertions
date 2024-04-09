package FIFO_transaction_pkg;

	class FIFO_transaction;
		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;
		rand logic [FIFO_WIDTH-1:0] data_in;
		rand logic  rst_n, wr_en, rd_en;
		logic [FIFO_WIDTH-1:0] data_out;
		logic wr_ack, overflow;
		logic full, empty, almostfull, almostempty, underflow;

		int wr_en_on_dist=70;
		int rd_en_on_dist=30;

		constraint constr1 {rst_n dist {0:=5,1:=95};}
		constraint constr2 {wr_en dist {1:= wr_en_on_dist,0:= (100-wr_en_on_dist)};}
		constraint constr3 {rd_en dist {1:=rd_en_on_dist,0:= (100-rd_en_on_dist)};}

	endclass
endpackage