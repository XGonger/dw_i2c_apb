`ifndef RKV_I2C_SLAVE_DIRECTED_READ_PACKET_VIRT_SEQ_SV
`define RKV_I2C_SLAVE_DIRECTED_READ_PACKET_VIRT_SEQ_SV
class rkv_i2c_slave_directed_read_packet_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_slave_directed_read_packet_virt_seq)

  function new (string name = "rkv_i2c_slave_directed_read_packet_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);

    cfg.i2c_cfg.slave_cfg[0].is_active = 0;
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    cfg.i2c_cfg.master_cfg[0].is_active = 1;
    env.i2c_mst.reconfigure_via_task(cfg.i2c_cfg.master_cfg[0]);

    `uvm_do_on_with(apb_user_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {MASTER_MODE == 0; // master mode disabled
                     SPEED == 2;
                     IC_10BITADDR_SLAVE == 0; // Slave 7Bit addressing
                     IC_SLAVE_DISABLE == 0; // Slave mode is enabled
                     IC_SAR == 10'b11_0011_0011;
                     ENABLE == 1;
                  })             
    fork
        `uvm_do_on_with(apb_read_packet_seq, 
                        p_sequencer.apb_mst_sqr,
                        {packet.size() == 1; 
                        })

        `uvm_do_on_with(i2c_mst_read_resp_seq, 
                      p_sequencer.i2c_mst_sqr,
                      {packet.size() == 1; 
                      packet[0] == 8'b0000_1111;
                      cmd == I2C_WRITE;
                      addr == 10'b1100110011;
                      addr_10bit == 0;                    
                      })
    join

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask


endclass
`endif // RKV_I2C_SLAVE_DIRECTED_READ_PACKET_VIRT_SEQ_SV
