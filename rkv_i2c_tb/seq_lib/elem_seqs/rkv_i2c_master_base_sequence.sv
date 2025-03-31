
`ifndef RKV_I2C_MASTER_BASE_SEQUENCE_SV
`define RKV_I2C_MASTER_BASE_SEQUENCE_SV

virtual class rkv_i2c_master_base_sequence extends uvm_sequence #(lvc_i2c_master_transaction);

  // WRITE/READ data packet content
  rand bit [7:0] packet[];

  rand command_enum cmd;
  rand bit [9:0] addr;
  rand bit addr_10bit;

  ral_block_rkv_i2c rgm;
  lvc_i2c_configuration cfg;

  // Register model variables:
  uvm_status_e status;
  rand uvm_reg_data_t data;

  `uvm_declare_p_sequencer(lvc_i2c_master_sequencer)

  function new (string name = "rkv_i2c_master_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    if(!uvm_config_db #(ral_block_rkv_i2c)::get(m_sequencer, "", "rgm", rgm)) begin
      `uvm_error("body", "Unable to find ral_block_rkv_i2c in uvm_config_db")
    end
    p_sequencer.get_cfg(cfg);
    // TODO
    // Attach element sequences below
  endtask
endclass


`endif // RKV_I2C_SLAVE_BASE_SEQUENCE_SV
