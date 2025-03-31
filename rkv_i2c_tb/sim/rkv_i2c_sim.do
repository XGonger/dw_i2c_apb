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
set TEST rkv_i2c_quick_reg_access_test
set VERB UVM_HIGH
set SEED 0

# prepare simrun folder
set timetag [clock format [clock seconds] -format "%Y%b%d_%H_%M"]

if {![file exists regr_ucdb_merge]} {
  file mkdir regr_ucdb_merge
}

# simulate with specific testname sequentially
set TestSets {
  # basic test
  {rkv_i2c_master_directed_write_packet_test 1} \ 
  {rkv_i2c_master_directed_read_packet_test 1} \ 
  {rkv_i2c_master_directed_interrupt_test 1} \ 
  {rkv_i2c_slave_directed_write_packet_test 1} \ 
  {rkv_i2c_slave_directed_read_packet_test 1} \ 
  # register test
  {rkv_i2c_reg_hw_reset_test 1} \ 
  {rkv_i2c_reg_bit_bash_test 1} \ 
  {rkv_i2c_reg_access_test 1} \ 
  # i2c protocol
  {rkv_i2c_master_address_cg_test 1} \ 
  {rkv_i2c_master_ss_cnt_test 1} \ 
  {rkv_i2c_master_fs_cnt_test 1} \ 
  {rkv_i2c_master_hs_cnt_test 1} \
  {rkv_i2c_master_restart_control_test 1} \
  {rkv_i2c_master_tx_abrt_intr_test 1} \ 
  {rkv_i2c_master_tx_full_intr_test 1} \ 
  {rkv_i2c_master_rx_full_intr_test 1} \ 
  {rkv_i2c_master_tx_tl_cover_test 1} \ 
  {rkv_i2c_master_rx_tl_cover_test 1} \
  {rkv_i2c_master_start_byte_test 1} \  
  {rkv_i2c_master_hs_master_code_test 1} \ 
  # interrupt state 
  {rkv_i2c_slave_gen_call_test 1} \ 
  {rkv_i2c_slave_rx_done_intr_test 1} \ 
  {rkv_i2c_master_tx_over_intr_test 1} \ 
  {rkv_i2c_master_rx_over_intr_test 1} \ 
  {rkv_i2c_master_rx_under_intr_test 1} \ 
  {rkv_i2c_master_activity_intr_output_test 1} \
  # tx_abrt_source  
  {rkv_i2c_slave_abrt_slvrd_intx_test 1} \ 
  {rkv_i2c_slave_abrt_slv_arblost_test 1} \  
  {rkv_i2c_master_abrt_10b_rd_norstrt_test 1} \
  {rkv_i2c_master_abrt_sbyte_norstrt_test 1} \
  {rkv_i2c_master_abrt_hs_norstrt_test 1} \
  {rkv_i2c_master_abrt_sbyte_ackdet_test 1} \
  {rkv_i2c_master_abrt_hs_ackdet_test 1} \
  {rkv_i2c_master_abrt_gcall_read_test 1} \
  {rkv_i2c_master_abrt_txdata_noack_test 1} \
  {rkv_i2c_master_abrt_gcall_noack_test 1} \
  {rkv_i2c_master_abrt_10addr1_noack_test 1} \
  # sda control
  {rkv_i2c_master_sda_control_cg_test 1} \
  # timeout control
  {rkv_i2c_master_timeout_cg_test 1}                
}


foreach testset $TestSets {
  set testname [lindex $testset 0]
  set LoopNum [lindex $testset 1]
  for {set loop 0} {$loop < $LoopNum} {incr loop} {
    set seed [expr int(rand() * 100)]
    echo simulating $testname
    echo $seed +UVM_TESTNAME=$testname -l regr_ucdb_merge/run_${testname}_${seed}.log
    vsim -onfinish stop -cover -sv_seed $seed \
         +UVM_TESTNAME=$testname -l regr_ucdb_merge/run_${testname}_${seed}.log work.rkv_i2c_tb
    run -all
    coverage save regr_ucdb_merge/${testname}_${seed}.ucdb
    quit -sim
  }
}

# merge the ucdb per test
vcover merge -testassociated regr_ucdb_merge/regr_${timetag}.ucdb ../doc/questa_vplan.ucdb {*}[glob regr_ucdb_merge/rkv_i2c*.ucdb]

# quit -f

