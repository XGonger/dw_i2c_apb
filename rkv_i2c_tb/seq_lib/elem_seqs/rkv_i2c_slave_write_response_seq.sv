
`ifndef RKV_I2C_SLAVE_WRITE_RESPONSE_SEQ_SV
`define RKV_I2C_SLAVE_WRITE_RESPONSE_SEQ_SV

class rkv_i2c_slave_write_response_seq extends rkv_i2c_slave_base_sequence;

  `uvm_object_utils(rkv_i2c_slave_write_response_seq)

  constraint def_cstr {
    soft nack_addr == 0;
    soft nack_data == 0;
    soft nack_addr_count == 0;
    soft NACK_START_BYTE == 1;
    soft NACK_HS_CODE == 1;
    soft ACK_GEN_CALL == 1;
  }

  function new (string name = "rkv_apb_config_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    `uvm_create(req)
    req.reasonable_nack_addr.constraint_mode(0);
    `uvm_rand_send_with(req,  
                        {local::nack_addr >= 0 -> nack_addr == local::nack_addr;
                         local::nack_data >= 0 -> nack_data == local::nack_data;
                         local::nack_addr_count >= 0-> nack_addr_count == local::nack_addr_count;
                         NACK_START_BYTE == local::NACK_START_BYTE;
                         NACK_HS_CODE == local::NACK_HS_CODE;
                         ACK_GEN_CALL == local::ACK_GEN_CALL;
                        })

    if(cfg.enable_put_response == 1) get_response(rsp);

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // RKV_I2C_SLAVE_WRITE_RESPONSE_SEQ_SV
