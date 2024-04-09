package FIFO_scoreboard_pkg;
	import shared_pkg::*;
	import FIFO_transaction_pkg::*;

	class FIFO_scoreboard;

		parameter FIFO_WIDTH = 16;

		FIFO_transaction received_t;
		logic [FIFO_WIDTH-1:0] data_out_ex;
		logic wr_ack_ex, overflow_ex;
		logic full_ex, empty_ex, almostfull_ex, almostempty_ex, underflow_ex;

		bit [15:0] mem [7:0];
		reg [2:0] wr_ptr, rd_ptr;
		reg [3:0] counter;

		task golden_model(FIFO_transaction t);
			
			fork 
				//write operation 
				begin

					if(!t.rst_n) 
						{wr_ptr,overflow_ex,wr_ack_ex}<=0;
					else begin
						if(t.wr_en && !full_ex) begin
							mem[wr_ptr]<=t.data_in;
							wr_ack_ex<=1;
							wr_ptr<=wr_ptr+1;
							if(wr_ptr==7)
								wr_ptr<=0; //condition to continue
						end
						else begin
							wr_ack_ex<=0;
							if(full_ex && t.wr_en )
								overflow_ex<=1;
							else 
								overflow_ex<=0;
						end
					end
				end




				//read operation
				begin
					if(!t.rst_n)
						{rd_ptr,underflow_ex,data_out_ex}<=0;
					else begin
						if(t.rd_en && !empty_ex) begin
							data_out_ex<=mem[rd_ptr];
							rd_ptr<=rd_ptr+1;
							if(rd_ptr==7)
								rd_ptr<=0;
						end
						else begin
							if(t.rd_en && empty_ex)
								underflow_ex<=1;
							else
								underflow_ex<=0;
						end
					end
				end



				//counter

				begin
					if(!t.rst_n)
						counter<=0;
					else begin
						if( (t.wr_en && t.rd_en==0) && !full_ex )
							counter<=counter+1;
						else if( (t.wr_en==0 && t.rd_en==1) && !empty_ex)
							counter<=counter-1;
					end

				end

				//here we list flags

			join
				#1;
				full_ex=(counter==8)? 1'b1:1'b0;
				almostfull_ex=(counter==7)? 1'b1:1'b0;
				empty_ex=(counter==0)? 1'b1:1'b0;
				almostempty_ex=(counter==1)? 1'b1:1'b0;

		endtask

		task check_data(FIFO_transaction t);
			received_t=t;
			 golden_model(received_t);
			 	if({t.data_out,t.full,t.almostfull,t.empty,t.almostempty,t.overflow,t.underflow,t.wr_ack} !=
			 		{data_out_ex,full_ex,almostfull_ex,empty_ex,almostempty_ex,overflow_ex,underflow_ex,wr_ack_ex}) begin
			 			$display("ERROR:Time=%0t \n received_t=%p \n  but---> data_out_ex=%b full_ex =%b almostfull_ex=%b empty_ex =%b almostempty_ex=%b overflow_ex=%b underflow_ex=%b wr_ack_ex=%b \n \n ",
			 				$time,received_t,data_out_ex,full_ex,almostfull_ex,empty_ex,almostempty_ex,overflow_ex,underflow_ex,wr_ack_ex);
			 			error_count++;
			 		end
			 		else begin
			 			$display("Done:Time=%0t \n received_t=%p \n  but---> data_out_ex=%b full_ex =%b almostfull_ex=%b empty_ex =%b almostempty_ex=%b overflow_ex=%b underflow_ex=%b wr_ack_ex=%b \n \n ",
			 				$time,received_t,data_out_ex,full_ex,almostfull_ex,empty_ex,almostempty_ex,overflow_ex,underflow_ex,wr_ack_ex);
			 			correct_count++;
			 		end
			 //here we check result
		endtask

		function new();
			received_t=new();
		endfunction

	endclass
endpackage 