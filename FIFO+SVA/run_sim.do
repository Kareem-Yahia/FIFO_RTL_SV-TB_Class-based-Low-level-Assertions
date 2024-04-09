vlib work
vlog shared_pkg.sv FIFO_transaction_pkg.sv   FIFO_scoreboard_pkg.sv   FIFO.sv FIFO_if.sv  FIFO_tb.sv monitor.sv top.sv  FIFO_coverage_pkg.sv  +cover +define+asser
vsim -voptargs=+acc work.top -cover -classdebug -sv_seed 111
add wave *

add wave -position insertpoint  \
sim:/top/FIFO_if/FIFO_WIDTH \
sim:/top/FIFO_if/FIFO_DEPTH \
sim:/top/FIFO_if/clk \
sim:/top/FIFO_if/data_in \
sim:/top/FIFO_if/rst_n \
sim:/top/FIFO_if/wr_en \
sim:/top/FIFO_if/rd_en \
sim:/top/FIFO_if/data_out \
sim:/top/FIFO_if/wr_ack \
sim:/top/FIFO_if/overflow \
sim:/top/FIFO_if/full \
sim:/top/FIFO_if/empty \
sim:/top/FIFO_if/almostfull \
sim:/top/FIFO_if/almostempty \
sim:/top/FIFO_if/underflow
add wave -position insertpoint  \
sim:/top/MONITOR/t

add wave -position insertpoint  \
sim:/top/DUT/mem

add wave -position insertpoint  \
sim:/@FIFO_scoreboard@1

add wave /top/DUT/full_flag_sva /top/DUT/empty_flag_sva /top/DUT/almostfull_flag_sva /top/DUT/almostempty_flag_sva /top/DUT/overflow_flag_sva /top/DUT/underflow_flag_sva /top/DUT/wr_acknowledgment_sva /top/DUT/write_pointer_sva /top/DUT/read_pointer_sva /top/DUT/counter_element1_sva /top/DUT/counter_element2_sva

add wave /top/DUT/check_async_reset

coverage save top.ucdb -onexit -du FIFO
run -all
coverage report -output functional_coverage_rpt.txt -srcfile=* -detail -all -dump -annotate -directive -cvg
coverage report -output assertion_coverage.txt -detail -assert 
quit -sim
vcover report top.ucdb -details -annotate -all -output code_coverage_rpt.txt

#you can add -option to functional coverage
#you can add -classdebug in vsim command to access the classes in waveform

 