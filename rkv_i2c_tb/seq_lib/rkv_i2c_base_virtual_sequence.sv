

`ifndef RKV_I2C_BASE_VIRTUAL_SEQUENCE_SV
`define RKV_I2C_BASE_VIRTUAL_SEQUENCE_SV

virtual class rkv_i2c_base_virtual_sequence extends uvm_sequence;

  ral_block_rkv_i2c rgm;
  virtual rkv_i2c_if vif;
  virtual lvc_i2c_if i2c_if;
  rkv_i2c_env env;
  rkv_i2c_config cfg;


  // Register model variables:
  uvm_status_e status;
  rand uvm_reg_data_t data;

  // element sequences
  rkv_apb_config_seq                          apb_cfg_seq;
  rkv_apb_write_packet_seq                    apb_write_packet_seq;
  rkv_apb_read_packet_seq                     apb_read_packet_seq;
  rkv_apb_wait_empty_seq                      apb_wait_empty_seq;
  rkv_apb_intr_wait_seq                       apb_intr_wait_seq;
  rkv_apb_intr_clear_seq                      apb_intr_clear_seq;
  rkv_apb_noread_packet_seq                   apb_noread_packet_seq;
  rkv_apb_write_nocheck_packet_seq            apb_write_nocheck_packet_seq;
  rkv_apb_user_address_check_seq              apb_user_address_check_seq;
  rkv_i2c_slave_write_response_seq            i2c_slv_write_resp_seq;
  rkv_i2c_slave_read_response_seq             i2c_slv_read_resp_seq;

  rkv_i2c_master_read_response_seq            i2c_mst_read_resp_seq;
  rkv_i2c_master_write_response_seq           i2c_mst_write_resp_seq; 

  rkv_apb_user_config_seq                     apb_user_cfg_seq;
  rkv_apb_user_read_packet_seq                apb_user_read_packet_seq;
  rkv_apb_user_read_rx_fifo_seq               apb_user_read_rx_fifo_seq;
  rkv_apb_user_wait_detect_abort_source_seq   apb_user_wait_detect_abort_source_seq;
  rkv_apb_user_wait_empty_seq                 apb_user_wait_empty_seq;
  rkv_apb_user_write_packet_seq               apb_user_write_packet_seq;


  uvm_reg_hw_reset_seq                reg_rst_seq;
  uvm_reg_single_bit_bash_seq         reg_single_bit_bash_seq;
  uvm_reg_bit_bash_seq                reg_bit_bash_seq;
  uvm_reg_single_access_seq           reg_single_access_seq;
  uvm_reg_access_seq                  reg_access_seq;
  uvm_reg_shared_access_seq           reg_shared_access_seq;

  `uvm_declare_p_sequencer(rkv_i2c_virtual_sequencer)

  function new (string name = "rkv_i2c_base_virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    rgm = p_sequencer.rgm;
    vif = p_sequencer.vif;
    i2c_if = p_sequencer.i2c_if;
    cfg = p_sequencer.cfg;
    void'($cast(env, p_sequencer.m_parent));
    do_reset_callback();
    // TODO
    // Attach element sequences below
  endtask

  virtual task do_reset_callback();
    fork
      forever begin
        vif.wait_rstn_release();
        rgm.reset();
      end
    join_none
  endtask

  function bit diff_value(int val1, int val2, string id = "value_compare");
    if(val1 != val2) begin
      `uvm_error("[CMPERR]", $sformatf("ERROR! %s val1 %8x != val2 %8x", id, val1, val2)) 
      return 0;
    end
    else begin
      `uvm_info("[CMPSUC]", $sformatf("SUCCESS! %s val1 %8x == val2 %8x", id, val1, val2), UVM_LOW)
      return 1;
    end
  endfunction

  virtual task update_regs(uvm_reg regs[]);
    uvm_status_e status;
    foreach(regs[i]) regs[i].update(status);
  endtask

endclass

`endif // RKV_I2C_BASE_VIRTUAL_SEQUENCE_SV
