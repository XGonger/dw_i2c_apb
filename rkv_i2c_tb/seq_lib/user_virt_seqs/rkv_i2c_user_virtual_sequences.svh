
`ifndef RKV_I2C_USER_VIRTUAL_SEQUENCES_SVH
`define RKV_I2C_USER_VIRTUAL_SEQUENCES_SVH

// cg seq
`include "rkv_i2c_master_sda_control_cg_virt_seq.sv"

`include "rkv_i2c_master_address_cg_virt_seq.sv"
`include "rkv_i2c_master_enabled_cg_virt_seq.sv"
`include "rkv_i2c_master_timeout_cg_virt_seq.sv"

// function seq
`include "rkv_i2c_master_start_byte_virt_seq.sv"
`include "rkv_i2c_master_hs_master_code_virt_seq.sv"

// intr seq
`include "rkv_i2c_master_tx_empty_intr_virt_seq.sv"
`include "rkv_i2c_master_rx_over_intr_virt_seq.sv"
`include "rkv_i2c_master_rx_full_intr_virt_seq.sv"
`include "rkv_i2c_master_tx_full_intr_virt_seq.sv"

`include "rkv_i2c_master_tx_over_intr_virt_seq.sv"

`include "rkv_i2c_master_activity_intr_output_virt_seq.sv"

// abrt source seq
`include "rkv_i2c_master_abrt_7b_addr_noack_virt_seq.sv"
`include "rkv_i2c_master_abrt_sbyte_norstrt_virt_seq.sv"
`include "rkv_i2c_master_abrt_txdata_noack_virt_seq.sv"
`include "rkv_i2c_master_abrt_10b_rd_norstrt_virt_seq.sv"
`include "rkv_i2c_slave_abrt_slvrd_intx_virt_seq.sv"
`include "rkv_i2c_slave_abrt_slv_arblost_virt_seq.sv"
`include "rkv_i2c_master_abrt_hs_norstrt_virt_seq.sv"
`include "rkv_i2c_master_abrt_sbyte_ackdet_virt_seq.sv"
`include "rkv_i2c_master_abrt_hs_ackdet_virt_seq.sv"
`include "rkv_i2c_master_abrt_gcall_read_virt_seq.sv"
`include "rkv_i2c_master_abrt_gcall_noack_virt_seq.sv"
`include "rkv_i2c_master_abrt_10addr1_noack_virt_seq.sv"

// cnt seq
`include "rkv_i2c_master_ss_cnt_virt_seq.sv"
`include "rkv_i2c_master_fs_cnt_virt_seq.sv"
`include "rkv_i2c_master_hs_cnt_virt_seq.sv"

// other seq
`include "rkv_i2c_master_restart_control_virt_seq.sv"
`include "rkv_i2c_master_tx_abrt_intr_virt_seq.sv"
`include "rkv_i2c_master_tx_tl_cover_virt_seq.sv"
`include "rkv_i2c_master_rx_tl_cover_virt_seq.sv"
`include "rkv_i2c_slave_gen_call_virt_seq.sv"
`include "rkv_i2c_slave_rx_done_intr_virt_seq.sv"
`include "rkv_i2c_master_rx_under_intr_virt_seq.sv"



`endif // RKV_I2C_USER_VIRTUAL_SEQUENCES_SVH

