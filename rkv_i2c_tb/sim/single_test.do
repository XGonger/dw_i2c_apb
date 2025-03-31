#======================================#
# TCL script for a mini regression     #
#======================================#
onbreak resume
onerror resume

# set environment variables
setenv DUT_SRC ../../rkv_dw_apb_i2c
setenv TB_SRC .

set INCDIR "+incdir+../../rkv_dw_apb_i2c/src \
					  +incdir+../agents/lvc_apb3 \
					  +incdir+../agents/lvc_i2c \
					  +incdir+../cfg \
					  +incdir+../cov \
					  +incdir+../reg \
					  +incdir+../env \
					  +incdir+../seq_lib \
					  +incdir+../seq_lib/elem_seqs \
					  +incdir+../seq_lib/user_elem_seqs \
					  +incdir+../seq_lib/user_virt_seqs \
					  +incdir+../tests/user_tests \
					  +incdir+../tests "

set VCOMP "vlog -cover bst -timescale=1ns/1ps -l comp.log $INCDIR"


# clean the environment and remove trash files
set delfiles [glob work *.log *.ucdb sim.list]

file delete -force {*}$delfiles

# compile the design and dut with a filelist
vlib work
eval $VCOMP -f  rkv_i2c.flist
eval $VCOMP -sv ../agents/lvc_apb3/lvc_apb_if.sv 
eval $VCOMP -sv ../agents/lvc_apb3/lvc_apb_pkg.sv 
eval $VCOMP -sv ../agents/lvc_i2c/lvc_i2c_if.sv 
eval $VCOMP -sv ../agents/lvc_i2c/lvc_i2c_pkg.sv 
eval $VCOMP -sv ../env/rkv_i2c_pkg.sv 
eval $VCOMP -sv ../tb/rkv_i2c_if.sv 
eval $VCOMP -sv ../tb/rkv_i2c_tb.sv 

# call a UVM test
# tests are listed below:

# basic test
# rkv_i2c_master_directed_write_packet_test
# rkv_i2c_master_directed_read_packet_test
# rkv_i2c_master_directed_interrupt_test
# rkv_i2c_slave_directed_write_packet_test
# rkv_i2c_slave_directed_read_packet_test

# register test
# rkv_i2c_reg_hw_reset_test
# rkv_i2c_reg_bit_bash_test
# rkv_i2c_reg_access_test

# i2c protocol
# rkv_i2c_master_address_cg_test
# rkv_i2c_master_ss_cnt_test
# rkv_i2c_master_fs_cnt_test
# rkv_i2c_master_hs_cnt_test
# rkv_i2c_master_restart_control_test
# rkv_i2c_master_tx_abrt_intr_test
# rkv_i2c_master_tx_full_intr_test
# rkv_i2c_master_rx_full_intr_test
# rkv_i2c_master_tx_tl_cover_test
# rkv_i2c_master_rx_tl_cover_test
# rkv_i2c_master_start_byte_test
# rkv_i2c_master_hs_master_code_test

# interrupt state
# rkv_i2c_slave_gen_call_test
# rkv_i2c_slave_rx_done_intr_test
# rkv_i2c_master_tx_over_intr_test
# rkv_i2c_master_rx_over_intr_test
# rkv_i2c_master_rx_under_intr_test
# rkv_i2c_master_activity_intr_output_test

# tx_abrt_source
# rkv_i2c_slave_abrt_slvrd_intx_test
# rkv_i2c_slave_abrt_slv_arblost_test
# rkv_i2c_master_abrt_10b_rd_norstrt_test
# rkv_i2c_master_abrt_sbyte_norstrt_test
# rkv_i2c_master_abrt_hs_norstrt_test
# rkv_i2c_master_abrt_sbyte_ackdet_test
# rkv_i2c_master_abrt_hs_ackdet_test
# rkv_i2c_master_abrt_gcall_read_test
# rkv_i2c_master_abrt_txdata_noack_test
# rkv_i2c_master_abrt_gcall_noack_test
# rkv_i2c_master_abrt_10addr1_noack_test

# sda control
# rkv_i2c_master_sda_control_cg_test

# timeout control
# rkv_i2c_master_timeout_cg_test

set TEST rkv_i2c_master_timeout_cg_test
set VERB UVM_HIGH
# set SEED 0	
set SEED [expr int(rand() * 100)]

# prepare simrun folder
set timetag [clock format [clock seconds] -format "%Y%b%d_%H_%M"]

set run_cmd "vsim work.rkv_i2c_tb -classdebug \
						-sv_seed $SEED +UVM_TESTNAME=$TEST +UVM_VERBOSITY=$VERB -l sim.log"

# whether sim with getting coverage 
set get_cover 0
if {$get_cover} {
	if {![file exists ${TEST}_ucdb]} {
			file mkdir ${TEST}_ucdb
	}
	set run_cmd "$run_cmd -cover"
	coverage save ${TEST}_ucdb/${TEST}_${timetag}.ucdb
}

eval $run_cmd
log -r /*
do wave.do

# run -all
# vcover merge -testassociated ${TEST}_ucdb/regr_${timetag}.ucdb ../doc/questa_vplan.ucdb {*}[glob ${TEST}_ucdb/*.ucdb]
# quit -f