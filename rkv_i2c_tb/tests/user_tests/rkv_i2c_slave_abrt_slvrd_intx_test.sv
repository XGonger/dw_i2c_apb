
`ifndef RKV_I2C_SLAVE_ABRT_SLVRD_INTX_TEST_SV
`define RKV_I2C_SLAVE_ABRT_SLVRD_INTX_TEST_SV

class rkv_i2c_slave_abrt_slvrd_intx_test extends rkv_i2c_base_test;

  `uvm_component_utils(rkv_i2c_slave_abrt_slvrd_intx_test)

  function new(string name = "rkv_i2c_slave_abrt_slvrd_intx_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO
    // modify components' configurations
  endfunction

  task run_phase(uvm_phase phase);
    rkv_i2c_slave_abrt_slvrd_intx_virt_seq seq = rkv_i2c_slave_abrt_slvrd_intx_virt_seq::type_id::create("seq");
    phase.raise_objection(this);
    `uvm_info("SEQ", "sequence starting", UVM_LOW)
    seq.start(env.sqr);
    `uvm_info("SEQ", "sequence finished", UVM_LOW)
    phase.drop_objection(this);
  endtask

endclass

`endif // RKV_I2C_SLAVE_ABRT_SLVRD_INTX_TEST_SV
