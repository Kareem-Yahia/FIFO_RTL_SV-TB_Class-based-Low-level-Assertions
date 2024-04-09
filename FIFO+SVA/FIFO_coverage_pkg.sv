package FIFO_coverage_pkg;
	import FIFO_transaction_pkg::*;

	class FIFO_coverage;

		FIFO_transaction F_cvg_txn;

		covergroup cvr_gp;
			a:coverpoint F_cvg_txn.wr_en;
			b:coverpoint F_cvg_txn.rd_en;
			c:coverpoint F_cvg_txn.wr_ack;
			d:coverpoint F_cvg_txn.overflow;
			e:coverpoint F_cvg_txn.full;
			f:coverpoint F_cvg_txn.empty;
			g:coverpoint F_cvg_txn.almostfull;
			h:coverpoint F_cvg_txn.almostempty;
			k:coverpoint F_cvg_txn.underflow;
			cross_1:cross a,b,c,d,e,f,g,h,k {
				bins bin1=binsof(a) && binsof(b) && binsof(c);
				bins bin2=binsof(a) && binsof(b) && binsof(d);
				bins bin3=binsof(a) && binsof(b) && binsof(e);
				bins bin4=binsof(a) && binsof(b) && binsof(g);
				bins bin5=binsof(a) && binsof(b) && binsof(g);
				bins bin6=binsof(a) && binsof(b) && binsof(h);
				bins bin7=binsof(a) && binsof(b) && binsof(k);
				// option.cross_auto_bin_max=0;
			}

		endgroup

		function void sample_data(FIFO_transaction F_txn);
			F_cvg_txn=F_txn;
			cvr_gp.sample();
		endfunction

		function new();
			cvr_gp=new();
			F_cvg_txn=new();
		endfunction

	
	endclass

endpackage