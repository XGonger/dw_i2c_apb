`ifndef RKV_I2C_MASTER_ABRT_SBYTE_NORSTRT_TEST_SV
`define RKV_I2C_MASTER_ABRT_SBYTE_NORSTRT_TEST_SV

class rkv_i2c_master_abrt_sbyte_norstrt_test extends rkv_i2c_base_test;

  `uvm_component_utils(rkv_i2c_master_abrt_sbyte_norstrt_test)

  function new(string name = "rkv_i2c_master_abrt_sbyte_norstrt_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO
    // modify components' configurations
  endfunction

  task run_phase(uvm_phase phase);
    rkv_i2c_master_abrt_sbyte_norstrt_virt_seq seq = rkv_i2c_master_abrt_sbyte_norstrt_virt_seq::type_id::create("seq");
    phase.raise_objection(this);
    `uvm_info("SEQ", "sequence starting", UVM_LOW)
    seq.start(env.sqr);
    `uvm_info("SEQ", "sequence finished", UVM_LOW)
    phase.drop_objection(this);
  endtask

endclass

`endif // RKV_I2C_MASTER_ABRT_SBYTE_NORSTRT_TEST_SV
