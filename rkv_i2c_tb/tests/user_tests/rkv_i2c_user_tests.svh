
`ifndef RKV_I2C_USER_TESTS_SVH
`define RKV_I2C_USER_TESTS_SVH

// cg test
`include "rkv_i2c_master_sda_control_cg_test.sv"

`include "rkv_i2c_master_address_cg_test.sv"
`include "rkv_i2c_master_enabled_cg_test.sv"
`include "rkv_i2c_master_timeout_cg_test.sv"

// function test
`include "rkv_i2c_master_start_byte_test.sv"
`include "rkv_i2c_master_hs_master_code_test.sv"

// interrupt test
`include "rkv_i2c_master_tx_empty_intr_test.sv"
`include "rkv_i2c_master_rx_over_intr_test.sv"
`include "rkv_i2c_master_rx_full_intr_test.sv"
`include "rkv_i2c_master_tx_full_intr_test.sv"
`include "rkv_i2c_master_tx_over_intr_test.sv"
`include "rkv_i2c_master_activity_intr_output_test.sv"


//	abort test
`include "rkv_i2c_master_abrt_7b_addr_noack_test.sv"
`include "rkv_i2c_master_abrt_sbyte_norstrt_test.sv"
`include "rkv_i2c_master_abrt_txdata_noack_test.sv"
`include "rkv_i2c_master_abrt_10b_rd_norstrt_test.sv"
`include "rkv_i2c_master_abrt_hs_norstrt_test.sv"
`include "rkv_i2c_master_abrt_sbyte_ackdet_test.sv"
`include "rkv_i2c_master_abrt_hs_ackdet_test.sv"
`include "rkv_i2c_master_abrt_gcall_read_test.sv"
`include "rkv_i2c_master_abrt_gcall_noack_test.sv"
`include "rkv_i2c_master_abrt_10addr1_noack_test.sv"

// cnt seq
`include "rkv_i2c_master_ss_cnt_test.sv"
`include "rkv_i2c_master_fs_cnt_test.sv"
`include "rkv_i2c_master_hs_cnt_test.sv"

//other test
`include "rkv_i2c_master_restart_control_test.sv"
`include "rkv_i2c_master_tx_abrt_intr_test.sv"
`include "rkv_i2c_master_tx_tl_cover_test.sv"
`include "rkv_i2c_master_rx_tl_cover_test.sv"
`include "rkv_i2c_slave_gen_call_test.sv"
`include "rkv_i2c_slave_rx_done_intr_test.sv"
`include "rkv_i2c_master_rx_under_intr_test.sv"
`include "rkv_i2c_slave_abrt_slvrd_intx_test.sv"
`include "rkv_i2c_slave_abrt_slv_arblost_test.sv"

`endif // RKV_I2C_USER_TESTS_SVH

