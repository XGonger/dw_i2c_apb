`ifndef RKV_I2C_CONFIG_SV
`define RKV_I2C_CONFIG_SV

class rkv_i2c_config extends uvm_object;

  lvc_apb_config apb_cfg;
  lvc_i2c_system_configuration i2c_cfg;
  ral_block_rkv_i2c rgm;
  virtual rkv_i2c_if vif;

  bit master_scoreboard_enable = 1;
  bit coverage_model_enable = 1;

  `uvm_object_utils(rkv_i2c_config)

  function new (string name = "rkv_i2c_config");
    super.new(name);
    apb_cfg = lvc_apb_config::type_id::create("apb_cfg");
    i2c_cfg = lvc_i2c_system_configuration::type_id::create("i2c_cfg");
    do_apb_cfg();
    do_i2c_cfg();
  endfunction

  function void do_apb_cfg();
    // TODO
  endfunction


  function void do_i2c_cfg();
    i2c_cfg.num_masters = 1;
    i2c_cfg.num_slaves = 1;
    i2c_cfg.create_sub_cfgs(i2c_cfg.num_masters, i2c_cfg.num_slaves);

    // By default 
    // I2C master agent as passive
    i2c_cfg.master_cfg[0].bus_speed             = lvc_i2c_pkg::FAST_MODE;
    i2c_cfg.master_cfg[0].master_code           = 3'b000;
    i2c_cfg.master_cfg[0].enable_10bit_addr     = 0;
    i2c_cfg.master_cfg[0].is_active             = 1;

    // I2C slave agent as active
    i2c_cfg.slave_cfg[0].slave_address          = `LVC_I2C_SLAVE0_ADDRESS;
    i2c_cfg.slave_cfg[0].enable_10bit_addr      = 0;
    i2c_cfg.slave_cfg[0].device_id              = 24'b0;
    i2c_cfg.slave_cfg[0].is_active              = 1;
  endfunction

endclass

`endif // RKV_I2C_CONFIG_SV
