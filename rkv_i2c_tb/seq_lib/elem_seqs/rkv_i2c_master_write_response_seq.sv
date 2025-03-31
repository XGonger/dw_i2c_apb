
`ifndef RKV_I2C_MASTER_WRITE_RESPONSE_SEQ_SV
`define RKV_I2C_MASTER_WRITE_RESPONSE_SEQ_SV

class rkv_i2c_master_write_response_seq extends rkv_i2c_master_base_sequence;

  `uvm_object_utils(rkv_i2c_master_write_response_seq)

  constraint def_cstr {
    soft cmd == I2C_READ;
    soft addr == 10'b1100110011;
    soft addr_10bit == 0;
    soft packet.size() == 0; 
  }

  function new (string name = "rkv_i2c_master_write_response_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    `uvm_do_with(req,  
                {cmd == local::cmd;
                 addr == local::addr;
                 addr_10bit == local::addr_10bit;
                 data.size() ==  local::packet.size();
                })

    if(cfg.enable_put_response == 1) get_response(rsp);

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // RKV_I2C_MASTER_WRITE_RESPONSE_SEQ_SV
